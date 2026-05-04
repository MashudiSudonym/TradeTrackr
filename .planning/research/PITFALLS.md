# Domain Pitfalls: Flutter Trading Journal (TradeTrackr)

**Domain:** Offline-first Flutter trading journal with analytics, CSV import/export, and recommendation engine
**Researched:** 2026-05-04
**Method:** Deep code audit of existing codebase + library documentation (Drift, Riverpod, fl_chart)

---

## Critical Pitfalls

Mistakes that cause data loss, silent wrong results, or require substantial rewrites.

### Pitfall 1: Close Position Operation Is Not Atomic

**What goes wrong:** In `trade_command_repository_impl.dart` (line 232-253), the `closePosition` method deletes the open position and then inserts the closed position as two separate database operations. If the app crashes, loses power, or encounters an exception between these two calls, the open position is permanently deleted and the closed position is never created. **Trade data is lost with no recovery path.**

**Why it happens:** The method does not wrap the delete+insert in a Drift `transaction()`. The merge operations in `database.dart` correctly use `transaction()`, but this critical write path does not.

**Consequences:** Lost trade records. User closes a profitable trade, but the record vanishes entirely. The analytics dashboard will show incorrect totals. No way to recover the data.

**Detection:**
- Look for `await _localDataSource.deleteOpenPosition(...)` followed by `await _localDataSource.insertClosedPosition(...)` without a wrapping `transaction(() async { ... })`
- Test: Kill the app process immediately after closing a position, then reopen

**Prevention:** Wrap both operations in a Drift transaction:
```dart
await _localDataSource.db.transaction(() async {
  await _localDataSource.deleteOpenPosition(openPositionId);
  await _localDataSource.insertClosedPosition(closedDataMap);
});
```

**Phase:** Must be fixed in the "Open Position → Close Position" phase before any user-facing release.

---

### Pitfall 2: Analytics Computation Returns Zeros for Finance Metrics

**What goes wrong:** `_computeAnalytics` in `trade_query_repository_impl.dart` (lines 127-201) returns hardcoded zeros for `openPositions`, `accountBalance`, `totalDeposits`, and `totalWithdrawals`. These are 4 of the 13 dashboard metrics. When the analytics provider is wired to the real use case, the dashboard will show `$0.00` for account balance, 0 open positions count, $0 deposits, and $0 withdrawals — regardless of actual data.

**Why it happens:** The method only queries `ClosedPositions` via `queryClosedPositions`. Finance data lives in the `FinanceRecords` table, and open positions in `OpenPositions` — but neither is queried. The `TradeQueryRepository` interface only has `getAnalytics(userId, filter)` which doesn't expose a way to fetch from multiple tables.

**Consequences:** Dashboard shows misleading zero values. Users lose trust in the app when their $100,000 deposit shows as $0.00 balance.

**Detection:**
- Search `_computeAnalytics` for hardcoded `0` values in returned `TradeAnalytics`
- Verify `accountBalance`, `totalDeposits`, `totalWithdrawals`, `openPositions` fields

**Prevention:** The analytics computation must query three tables: `ClosedPositions` (for trade profits), `OpenPositions` (for count), and `FinanceRecords` (for deposits/withdrawals). Options:
1. Add separate query methods to `TradeLocalDataSource` for finance records, then combine in the repository
2. Use a Drift `customSelect` with a SQL expression that joins across tables (best performance for large datasets)
3. Add a dedicated `getAnalyticsRaw()` method to the database class that returns pre-aggregated data

**Phase:** Must be addressed in the "Dashboard Wired to Real Data" phase. This is a prerequisite for charts and metrics to render correctly.

---

### Pitfall 3: Profit Factor Calculation Is Wrong

**What goes wrong:** The `_computeAnalytics` method calculates profit factor as `avgWin / avgLoss` (line 151). The PRD defines profit factor as **"Sum of gross profits / Sum of gross losses"**. Average win/loss is NOT the same as total sums.

Example: 3 winning trades of $100 each and 1 losing trade of $300.
- Correct: `300 / 300 = 1.0`
- Current: `100 / 300 = 0.33`

**Why it happens:** Confusion between average and sum. The calculation divides per-trade averages instead of totals.

**Consequences:** Profit factor displayed to users will be systematically wrong. A breakeven trader (PF=1.0) will see values that don't match any other trading platform.

**Detection:**
- Compare computed profit factor against a known portfolio (e.g., from the mock data)
- Cross-reference with the PRD formula

**Prevention:** Fix the calculation:
```dart
final totalWins = positions.where((p) => p.profit > 0).fold<double>(0, (sum, p) => sum + p.profit);
final totalLosses = positions.where((p) => p.profit < 0).fold<double>(0, (sum, p) => sum + p.profit.abs());
final profitFactor = totalLosses > 0 ? totalWins / totalLosses : (totalWins > 0 ? double.infinity : 0.0);
```

**Phase:** Fix in "Dashboard Wired to Real Data" phase. Flag as a correctness test case.

---

### Pitfall 4: Consecutive Losses Tracks Historical Max, Not Current Streak

**What goes wrong:** The `_computeAnalytics` method (lines 167-179) iterates all positions and tracks the maximum consecutive loss streak ever observed. The PRD says: "Alert if **currently on** a streak of 3+ consecutive losses". A trader who had a 5-loss streak in January but won their last trade should NOT trigger this alert.

**Why it happens:** The code updates `consecutiveLosses = max(consecutiveLosses, currentStreak)` on every losing trade, preserving the all-time maximum. The positions are ordered by `closeTime` descending (from the database query), so the iteration goes from newest to oldest. The current streak should be counted from the most recent trade backward.

**Consequences:** False positive alerts after a historical losing streak has been broken. The recommendation engine will show "Consecutive Losses" warnings to traders who are currently winning.

**Detection:**
- Create test data: [loss, loss, loss, win, loss, loss]. Current streak = 2, but code returns 3.
- Verify against PRD rule: "currently on a streak"

**Prevention:** Count from the most recent trade (first in the list) and stop at the first non-loss:
```dart
var currentStreak = 0;
for (final pos in positions) { // positions already sorted by closeTime desc
  if (pos.profit < 0) {
    currentStreak++;
  } else {
    break; // Stop at first non-loss — only want CURRENT streak
  }
}
```

**Phase:** Fix in "Recommendation Engine" phase. Test with historical streak scenarios.

---

### Pitfall 5: Close Position Uses Manual Map Parsing Instead of DTO

**What goes wrong:** In `trade_command_repository_impl.dart` (lines 183-200), the `closePosition` method manually parses the database row into an `OpenPosition` entity with type casts like `openDataMap['open_time'] as DateTime`. There's even a TODO: `"TODO: Convert map to OpenPosition entity via DTO. For now, create a mock entity"`.

**Why it happens:** The local data source returns `Map<String, dynamic>` from Drift queries. Drift stores `DateTime` columns as Unix timestamps (integers), not `DateTime` objects. The `as DateTime` cast will throw a `TypeError` at runtime.

**Consequences:** App crash when attempting to close any open position. The entire close-position flow is broken.

**Detection:**
- Run the close position flow end-to-end with a real Drift database
- Look for `as DateTime` casts on values coming from `Map<String, dynamic>` database results

**Prevention:** Use the existing `OpenPositionDto.fromJson()` for deserialization, or use Drift's typed data classes (`OpenPositionData`) directly from the database query instead of raw maps.

**Phase:** Must be fixed before the "Close Position" feature is considered functional.

---

## Moderate Pitfalls

### Pitfall 6: Dashboard Filter Queries Use openTime Instead of closeTime

**What goes wrong:** In `database.dart` (lines 162-165), the date range filter applies to `openTime`:
```dart
if (startDate != null) {
  query = query..where((t) => t.openTime.isBiggerOrEqualValue(startDate));
}
```
For a trading journal analytics dashboard, users expect date filters to apply to when trades were **closed** (realized), not when they were opened. A trade opened in January and closed in March should appear in March's analytics.

**Detection:**
- Apply a date filter for "last 30 days" and verify which trades appear
- Check if the query's date column matches the user's mental model

**Prevention:** Change to `closeTime` for closed position analytics queries, or add a parameter to let the caller choose which timestamp to filter on.

**Phase:** "Dashboard Filters" phase — fix when wiring filter bar to real queries.

---

### Pitfall 7: Chart Widgets Are Hardcoded to Private Mock Data Classes

**What goes wrong:** All 6 chart widgets import from `chart_mock_data.dart` and reference private classes (`_EquityPoint`, `_PLBucket`, `_SymbolPerf`, `_ReasonCount`, `_DayProfit`, `_SessionProfit`). When replacing mock data with real analytics data, you can't pass real data into these widgets without either: (a) making the private classes public, or (b) rewriting the chart widgets to accept different data structures.

**Why it happens:** The charts were built to match Stitch reference designs with static mock data. The data structures were never designed to be replaced.

**Detection:**
- Search chart files for imports of `chart_mock_data.dart`
- Look for references to private `_` prefixed classes outside the defining file

**Prevention:** Before wiring charts, refactor each chart to accept a standard data interface (e.g., `List<FlSpot>` for equity curve, `List<({String label, int wins, int losses})>` for symbol chart). Create provider methods that compute these from real trade data. Don't expose chart internals to analytics computation.

**Phase:** "Charts Wired to Real Data" phase — refactor chart data interfaces first, then wire providers.

---

### Pitfall 8: Provider Invalidation Cascade Misses Analytics After Trade Mutations

**What goes wrong:** In `trade_provider.dart`, the `closeOpenPosition` provider (lines 206-207) invalidates `openPositionsProvider` and `tradeListProvider` after closing a position, but does NOT invalidate `analyticsProvider`. Similarly, `addClosedPosition`, `updateClosedPosition`, and `deleteClosedPosition` only invalidate `tradeListProvider`.

**Consequences:** After closing a position, the dashboard shows stale analytics (old win rate, old total trades count, old profit factor). The metrics only update when the user manually refreshes or restarts the app.

**Detection:**
- Close a position, then immediately check dashboard metrics
- Verify that total trades count increases, win rate updates

**Prevention:** After any trade mutation (add, close, update, delete), invalidate all dependent providers:
```dart
ref.invalidate(tradeListProvider);
ref.invalidate(openPositionsProvider);
ref.invalidate(analyticsProvider); // Critical: stale analytics without this
```
Alternatively, make analytics a derived provider that automatically watches the trade list.

**Phase:** "Dashboard Wired to Real Data" phase — add invalidation cascade.

---

### Pitfall 9: DI Providers Don't Register Use Cases

**What goes wrong:** `di_providers.dart` wires up data sources and repositories but has **no providers** for `GetTradeAnalyticsUseCase`, `GetRecommendationsUseCase`, `ImportTradesUseCase`, or `ExportTradesUseCase`. The `analytics_provider.dart` currently returns mock data directly without using any use case.

**Why it happens:** The DI file was built incrementally, starting with the working features (auth, CRUD). Analytics/import/export were left as mock shells.

**Consequences:** When replacing mock data with real data, you'll need to either: (a) add use case providers to `di_providers.dart` and then call them from the analytics provider, or (b) call repositories directly from the provider (bypassing the domain layer, violating Clean Architecture).

**Detection:**
- Check `di_providers.dart` for any reference to use case classes
- Verify analytics provider imports — if it imports from `mock/`, it's not using real data

**Prevention:** Add use case providers to `di_providers.dart`:
```dart
@riverpod
GetTradeAnalyticsUseCase getTradeAnalyticsUseCase(Ref ref) {
  return GetTradeAnalyticsUseCase(ref.watch(tradeQueryRepositoryProvider));
}
```
Then update `analytics_provider.dart` to call the use case instead of returning mock data.

**Phase:** First step of "Dashboard Wired to Real Data" phase — must happen before any analytics wiring.

---

### Pitfall 10: CSV Total Row Detection Is Fragile

**What goes wrong:** The CSV format reference says "The last row with `Total` is a summary row and will be ignored during import." But the detection logic needs to handle:
- Is the check case-sensitive? `"Total"` vs `"TOTAL"` vs `"total"`
- What about trailing whitespace from Windows line endings (`"Total\r"`)?
- What about localized broker exports?
- The "last row" assumption breaks if the Total row is not at the end
- Multiple CSV files might have different summary row formats

**Detection:**
- Import a CSV with `"TOTAL"` instead of `"Total"` — it should skip but won't
- Import a CSV with Windows line endings

**Prevention:** Robust Total row detection:
```dart
bool _isSummaryRow(List<String> row) {
  if (row.isEmpty) return false;
  final firstCol = row.first.trim().toLowerCase();
  return firstCol == 'total';
}
```

**Phase:** "CSV Import" phase — implement with defensive parsing from the start.

---

### Pitfall 11: CSV Date Parsing Only Handles One Format

**What goes wrong:** The format reference specifies `dd/MM/yyyy HH:mm:ss`, but real broker CSV exports vary:
- `15/01/2026 08:30:00` (expected)
- `1/5/2026 8:30:00` (single-digit day/month/hour)
- `2026-01-15 08:30:00` (ISO format from some brokers)
- `15-01-2026 08:30:00` (different separator)

**Detection:**
- Try parsing `1/5/2026 8:30:00` with `DateFormat('dd/MM/yyyy HH:mm:ss')` — fails
- Try parsing a date like `01/05/2026` — ambiguous (Jan 5 or May 1)

**Prevention:** Try multiple format patterns in order, with strict validation:
```dart
DateTime? parseDate(String input) {
  final formats = [
    'dd/MM/yyyy HH:mm:ss',
    'd/M/yyyy H:mm:ss',
    'yyyy-MM-dd HH:mm:ss',
    'dd-MM-yyyy HH:mm:ss',
  ];
  for (final fmt in formats) {
    try { return DateFormat(fmt).parseStrict(input); }
    catch (_) { continue; }
  }
  return null;
}
```

**Phase:** "CSV Import" phase — implement robust parsing.

---

### Pitfall 12: Cross-Platform CSV Export Save/Share Diverges Per Platform

**What goes wrong:** The PRD specifies different export behaviors: save to Downloads (Android), share sheet (iOS), file dialog (Desktop), download folder (Web). Each platform requires different packages and permissions:
- **Android:** Needs `WRITE_EXTERNAL_STORAGE` permission on older devices, uses `path_provider` + save
- **iOS:** No filesystem access — must use `share_plus` share sheet
- **Desktop (Linux/macOS/Windows):** Uses `file_picker` for save dialog or `path_provider`
- **Web:** Must use `dart:html` AnchorElement download trick (no filesystem)

**Detection:**
- Run export on iOS simulator — file may silently fail to save
- Run export on Web — `path_provider` doesn't work on Web

**Prevention:** Create a platform-aware `FileExportService` that abstracts the behavior:
```dart
abstract class FileExportService {
  Future<Result<String>> export(String fileName, String content);
}
```
Implement per-platform using conditional imports or `kIsWeb` checks. Use `share_plus` for mobile, `file_picker` save dialog for desktop, and AnchorElement for Web.

**Phase:** "CSV Export" phase — build the platform abstraction first.

---

## Minor Pitfalls

### Pitfall 13: Theme Provider Doesn't Persist (Known Gap)

**What goes wrong:** `theme_provider.dart` has a TODO: `"Persisted choice stored locally (TODO: add shared_preferences persistence)"`. On app restart, theme resets to `ThemeMode.system`.

**Prevention:** Initialize the theme from `SharedPreferences` in the `build()` method:
```dart
@override
ThemeMode build() {
  final prefs = ref.read(sharedPreferencesProvider);
  final saved = prefs.getString('theme_mode');
  return switch (saved) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}
```
Save on every change via `setTheme`. Add a `SharedPreferences` provider in `di_providers.dart`.

**Phase:** "Theme Persistence" phase — straightforward, use `shared_preferences`.

---

### Pitfall 14: `reduce` on Empty Lists Will Crash

**What goes wrong:** In `_computeAnalytics` (lines 189-193):
```dart
largestWin: positions.map((p) => p.profit).reduce((a, b) => a > b ? a : b),
```
While the method has an early return for `positions.isEmpty`, any future refactoring that removes this guard will cause `reduce` to throw `StateError` on empty lists.

**Prevention:** Use a null-safe pattern:
```dart
largestWin: positions.map((p) => p.profit).fold<double>(double.nan, (a, b) => a > b ? a : b),
```
Or add explicit handling for the single-position case.

**Phase:** Fix when refactoring `_computeAnalytics` in the analytics phase.

---

### Pitfall 15: Dashboard Filter State Management Causes Full Chart Rebuild Cascade

**What goes wrong:** When dashboard filters (date range, symbol, side, reason) change, all 6 chart widgets will rebuild simultaneously because they all depend on the same `analyticsProvider`. Each chart widget has complex `fl_chart` rendering (gradients, animations, touch handling). Six simultaneous rebuilds with animation recalculations will cause visible jank on mobile devices.

**Detection:**
- Change a filter and observe frame rate on a mid-range Android device
- Profile with Flutter DevTools → check for dropped frames during filter changes

**Prevention:**
1. Use `ref.watch(analyticsProvider.select(...))` to have each chart watch only the data it needs
2. Add `const` constructors where possible
3. Debounce filter changes (300ms) before triggering analytics recomputation
4. Consider `AutomaticKeepAliveClientMixin` on chart widgets to prevent unnecessary rebuilds when scrolling

**Phase:** "Dashboard Filters" phase — add debouncing and selective rebuilds.

---

### Pitfall 16: Recommendation Engine Only Implements 4 of 10 Rules

**What goes wrong:** `GetRecommendationsUseCase` (in `domain/usecases/get_recommendations.dart`) only implements 4 rules:
1. Best performing symbol
2. Consecutive losses
3. Low win rate
4. Negative profit factor
5. Good performance

Missing from the PRD's 10 required rules:
- Worst performing symbol
- Best/worst day to trade
- Best session
- Avg win vs avg loss comparison
- Risk-reward alert
- Win rate trend (last 10 vs overall)
- Overtrading alert

**Detection:** Compare implemented rules against PRD section 2.7.

**Prevention:** The analytics computation must produce additional data points:
- Per-symbol breakdown (already computed)
- Per-day-of-week breakdown (NOT computed — needs SQL GROUP BY or Dart computation)
- Per-session breakdown (NOT computed — needs hour-of-day grouping)
- Last N trades comparison (NOT computed — needs ordered slice)

**Phase:** "Recommendation Engine" phase — complete all 10 rules. This requires extending `TradeAnalytics` or creating a separate analytics breakdown entity.

---

### Pitfall 17: Session-Based Analytics Requires Time Zone Awareness

**What goes wrong:** The "Profit by Session" chart groups trades by time-of-day sessions (Asian: 00-08, London: 07-16, New York: 12-21). But trade times are stored as UTC in the database. If the user is in GMT+8, a London session trade (07:00 UTC) happens at 15:00 local time. The session categorization must use UTC times, not local times.

**Why it happens:** Session names (Asian, London, New York) refer to market hours which are fixed in UTC. But `DateTime` in Dart can be either UTC or local, and it's easy to accidentally use local time.

**Detection:**
- Create a trade at 08:00 local time (which is 00:00 UTC). Check which session it's categorized into.
- Verify that all `DateTime` comparisons use `.toUtc()` consistently.

**Prevention:** Always use UTC for session categorization. Document this clearly in the session mapping logic.

**Phase:** "Charts Wired to Real Data" phase — session chart implementation.

---

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| Close Position Flow | Non-atomic delete+insert (Pitfall 1) | Wrap in Drift transaction |
| Close Position Flow | Manual map parsing crash (Pitfall 5) | Use DTO or Drift typed data class |
| Analytics Computation | Zero finance metrics (Pitfall 2) | Query FinanceRecords table |
| Analytics Computation | Wrong profit factor (Pitfall 3) | Use sum of wins / sum of losses |
| Analytics Computation | Wrong consecutive losses (Pitfall 4) | Count from most recent trade only |
| Analytics Computation | Empty list reduce crash (Pitfall 14) | Add null-safe handling |
| Dashboard Wiring | No use case providers (Pitfall 9) | Add to di_providers.dart first |
| Dashboard Wiring | Stale analytics after mutations (Pitfall 8) | Invalidate analytics provider |
| Dashboard Wiring | Date filter on wrong column (Pitfall 6) | Filter on closeTime, not openTime |
| Charts | Private mock data classes (Pitfall 7) | Refactor chart data interfaces first |
| Charts | Full rebuild cascade (Pitfall 15) | Debounce + select pattern |
| Charts | Session time zone (Pitfall 17) | Use UTC consistently |
| Recommendations | Only 4 of 10 rules (Pitfall 16) | Extend analytics computation |
| CSV Import | Fragile Total row detection (Pitfall 10) | Case-insensitive + trim |
| CSV Import | Single date format (Pitfall 11) | Try multiple patterns |
| CSV Export | Platform-specific save (Pitfall 12) | Build platform abstraction |
| Theme Persistence | No persistence (Pitfall 13) | Add shared_preferences |

## Priority Fix Order

These pitfalls should be addressed in this order based on blocking dependencies:

1. **Pitfall 9** — Register use cases in DI (prerequisite for all wiring)
2. **Pitfall 5** — Fix close position map parsing (data integrity, prevents crashes)
3. **Pitfall 1** — Make close position atomic (data loss prevention)
4. **Pitfall 2** — Add finance metrics to analytics computation
5. **Pitfall 3** — Fix profit factor calculation
6. **Pitfall 4** — Fix consecutive losses to current streak
7. **Pitfall 6** — Fix date filter column (closeTime not openTime)
8. **Pitfall 8** — Add analytics provider invalidation cascade
9. **Pitfall 7** — Refactor chart data interfaces before wiring
10. **Pitfall 16** — Complete all 10 recommendation rules

## Sources

- TradeTrackr codebase audit (all files in `lib/`)
- Drift documentation via Context7 (aggregation queries, transactions, custom selects)
- Riverpod documentation via Context7 (provider invalidation, select pattern, ref lifecycle)
- CSV_FORMAT_REFERENCE.md (date format, Total row, column specs)
- PRD.md section 2.6-2.7 (analytics metrics, recommendation rules)
