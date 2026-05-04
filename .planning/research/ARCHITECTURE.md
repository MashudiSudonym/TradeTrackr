# Architecture Research: Missing Feature Integration

**Domain:** Flutter trading journal — Clean Architecture integration
**Researched:** 2026-05-04
**Confidence:** HIGH (verified against actual codebase, not just documentation)

---

## Executive Summary

The existing TradeTrackr codebase has well-established Clean Architecture boundaries with 6 repository interfaces, 6 implementations, 11 use cases, and full Drift + Supabase data sources. **The primary gap is not missing layers — it's disconnected wiring.** Multiple features have complete UI and data implementations but sit behind mock data providers or have `TODO` handlers in buttons.

The 8 missing features fall into 3 integration categories:

1. **Wire existing providers to real data** (analytics, recommendations, finance, dashboard filters)
2. **Wire existing UI handlers to existing providers** (edit/delete, open positions close flow)
3. **Add new platform-level integration** (CSV file picker, theme persistence, open positions page/route)

No new repository interfaces or entities are needed. No new use cases are needed. The domain layer is complete. The work is almost entirely in the presentation layer (providers + pages).

---

## Current State Assessment

### What Already Exists (Complete Stack)

| Layer | Component | Status |
|-------|-----------|--------|
| **Domain** | 6 repository interfaces | ✅ Complete with all needed methods |
| **Domain** | 11 use cases | ✅ Complete (but bypassed by providers) |
| **Domain** | 7 entities | ✅ ClosedPosition, OpenPosition, FinanceRecord, TradeAnalytics, TradeFilter, Recommendation |
| **Data** | 6 repository implementations | ✅ All implemented with Result<T> |
| **Data** | Drift database (4 tables) | ✅ ClosedPositions, OpenPositions, FinanceRecords, Profiles |
| **Data** | Supabase data sources | ✅ Local + remote + auth |
| **Data** | CSV import impl | ✅ Full parsing with date format, batch insert |
| **Data** | CSV export impl | ⚠️ Shell only (header rows, no data query) |
| **Presentation** | `trade_provider.dart` | ✅ 11 providers wired to repos (CRUD, open positions, close flow) |
| **Presentation** | `analytics_provider.dart` | ❌ Returns mock data |
| **Presentation** | `recommendation_provider.dart` | ❌ Returns mock data |
| **Presentation** | `import_export_provider.dart` | ❌ Mock simulation only |
| **Presentation** | `theme_provider.dart` | ⚠️ No persistence |
| **Presentation** | Finance provider | ❌ Does not exist — FinancePage uses `MockData.mockFinanceRecords` directly |
| **Presentation** | 18 pages | ✅ Full UI, design system applied |
| **App** | GoRouter with 4-tab shell | ✅ Auth redirect, onboarding redirect |

### Critical Gap Map

```
Feature                     | Domain | Data  | Provider | Page/UI | Wired?
----------------------------|--------|-------|----------|---------|-------
Dashboard analytics         | ✅     | ✅    | ❌ mock  | ✅      | No
Dashboard filters           | ✅     | ✅    | ❌ mock  | ✅      | No
Recommendation engine       | ✅     | ✅    | ❌ mock  | ✅      | No
Finance page                | ✅     | ✅    | ❌ none  | ✅      | No
CSV import                  | ✅     | ✅    | ❌ mock  | ✅      | No
CSV export                  | ✅     | ⚠️    | ❌ mock  | ✅      | No
Open positions page + close | ✅     | ✅    | ✅       | ❌ page  | Partial
Trade edit                  | ✅     | ✅    | ✅       | ⚠️ TODO | No
Trade delete                | ✅     | ✅    | ✅       | ⚠️ TODO | No
Theme persistence           | N/A    | N/A   | ⚠️ TODO  | ✅      | No
```

---

## Component Boundaries

### System Architecture (Updated for Missing Features)

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         Presentation Layer                                │
│                                                                          │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │  NEW/UPDATED PROVIDERS                                            │  │
│  │                                                                   │  │
│  │  analytics_provider ──watch──> tradeQueryRepo.getAnalytics()      │  │
│  │  recommendation_provider ──watch──> getRecommendationsUseCase     │  │
│  │  finance_provider (NEW) ──watch──> tradeQueryRepo.getFinances()   │  │
│  │  import_export_provider ──read──> tradeImportRepo.importFromCsv() │  │
│  │                          ──read──> tradeExportRepo.export*()       │  │
│  │  dashboard_filter_provider (NEW) ──> TradeFilter state            │  │
│  │  theme_provider ──read──> shared_preferences                      │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │  NEW/UPDATED PAGES                                                │  │
│  │                                                                   │  │
│  │  open_positions_page (NEW) ──watch──> openPositionsProvider       │  │
│  │  close_position_page (NEW) ──read──> closeOpenPositionProvider    │  │
│  │  trade_detail_page ──read──> updateClosedPositionProvider         │  │
│  │                       ──read──> deleteClosedPositionProvider       │  │
│  │  dashboard_page ──watch──> analyticsProvider (real data)          │  │
│  │                  ──watch──> dashboardFilterProvider                │  │
│  │  finance_page ──watch──> financeProvider (NEW, real data)         │  │
│  │  import_export_page ──watch──> importExportProvider (real)        │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │  EXISTING (unchanged)                                             │  │
│  │  trade_provider.dart ── 11 providers, all wired ✅                │  │
│  │  auth_provider.dart ── auth state ✅                               │  │
│  │  di_providers.dart ── all 6 repos wired ✅                        │  │
│  └───────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────┘
            │ watches / reads
            ▼
┌──────────────────────────────────────────────────────────────────────────┐
│  Domain Layer — NO CHANGES NEEDED                                       │
│  All 6 repository interfaces have all required methods.                  │
│  All 11 use cases exist (currently bypassed by providers).               │
│  All entities and enums are complete.                                    │
└──────────────────────────────────────────────────────────────────────────┘
            │ implemented by
            ▼
┌──────────────────────────────────────────────────────────────────────────┐
│  Data Layer — MINOR CHANGES                                              │
│  trade_export_repository_impl: needs TradeLocalDataSource injected       │
│    to query actual data (currently returns header-only CSVs)             │
│  trade_query_repository_impl._computeAnalytics: needs finance data       │
│    for accountBalance, totalDeposits, totalWithdrawals fields            │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Feature-by-Feature Integration Plan

### Feature 1: Dashboard Analytics → Real Data

**What changes:**
- `analytics_provider.dart`: Replace `MockData.mockAnalytics` with real `TradeQueryRepository.getAnalytics(userId, filter)` call
- Needs `userId` from auth (use `supabaseAuthStateProvider` pattern from `trade_provider.dart`)
- Dashboard page already watches `analyticsProvider` — no page changes

**Data flow:**
```
DashboardPage watches analyticsProvider
  → analyticsProvider.build() calls tradeQueryRepo.getAnalytics(userId, filter)
    → TradeQueryRepositoryImpl queries Drift via _localDataSource.queryClosedPositions()
      → Computes TradeAnalytics from ClosedPosition list
        → Returns Result<TradeAnalytics>
          → Provider unwraps with getOrElse(TradeAnalytics.empty)
```

**Files touched:** `analytics_provider.dart` only

**Anti-pattern to fix:** Analytics computation currently lives in `TradeQueryRepositoryImpl._computeAnalytics()` (data layer). Per the codebase's own ARCHITECTURE.md anti-pattern notes, this business logic should move to the domain layer. However, moving it now would be a refactor, not integration — **recommend deferring this to a separate cleanup task.** The data layer computation works correctly; it's just architecturally misplaced.

### Feature 2: Dashboard Filters

**What changes:**
- New `dashboard_filter_provider.dart`: `@riverpod` class holding `TradeFilter` state
- `analytics_provider.dart` must accept filter as input (use family provider or watch filter provider)
- Dashboard `AnalyticsFilterBar` widget (already exists) must write to filter provider
- Analytics provider must re-fetch when filter changes (via `ref.watch` on filter)

**Data flow:**
```
User changes filter in AnalyticsFilterBar
  → dashboardFilterProvider.state = newFilter
    → analyticsProvider watches dashboardFilterProvider
      → Re-builds with new filter → tradeQueryRepo.getAnalytics(userId, filter)
        → Dashboard re-renders with filtered data
```

**Dependency:** Feature 1 must be done first (analytics provider needs to exist with real data before filters can work)

**Files touched:** New `dashboard_filter_provider.dart`, modify `analytics_provider.dart`, modify `AnalyticsFilterBar` widget

### Feature 3: Recommendation Engine → Real Data

**What changes:**
- `recommendation_provider.dart`: Replace `MockData.mockRecommendations` with real analytics → recommendation rules
- Option A: Wire `GetRecommendationsUseCase` (domain use case exists)
- Option B: Compute recommendations directly from analytics (simpler, follows current provider pattern of bypassing use cases)

**Recommendation:** Option A (wire the use case). The `GetRecommendationsUseCase` at `lib/domain/usecases/get_recommendations.dart` already generates recommendations from analytics. Add a provider in `di_providers.dart` for it.

**Data flow:**
```
RecommendationsPage watches recommendationsProvider
  → recommendationsProvider.build() calls getRecommendationsUseCase(filter)
    → UseCase calls tradeQueryRepo.getAnalytics(filter)
      → Generates List<Recommendation> from analytics
        → Returns Result<List<Recommendation>>
```

**Dependency:** Feature 1 (needs analytics computation working)

**Files touched:** `recommendation_provider.dart`, `di_providers.dart` (add use case provider)

### Feature 4: Finance Page → Real Data

**What changes:**
- New `finance_provider.dart`: `@riverpod` class that calls `tradeQueryRepo` (or a new method) to get finance records
- Need a `getFinanceRecords(userId)` method — currently `TradeQueryRepository` doesn't have one. Options:
  - Add to `TradeQueryRepository` (violates ISP slightly — finance isn't trades)
  - Create a new `FinanceQueryRepository` interface (cleanest ISP)
  - Use existing `TradeLocalDataSource.getAllFinanceRecords(userId)` directly through existing wiring
- **Recommendation:** Add `getFinanceRecords` to `TradeQueryRepository` since the local data source already has `getAllFinanceRecords`. It's pragmatic and avoids proliferating interfaces for a single method.
- `finance_page.dart`: Replace `MockData.mockFinanceRecords` with `ref.watch(financeProvider)`

**Data flow:**
```
FinancePage watches financeProvider
  → financeProvider.build() calls tradeQueryRepo.getFinanceRecords(userId)
    → TradeQueryRepositoryImpl calls _localDataSource.getAllFinanceRecords(userId)
      → Maps to FinanceRecord entities
        → Returns Result<List<FinanceRecord>>
```

**Files touched:** New `finance_provider.dart`, modify `trade_query_repository.dart` (add method), modify `trade_query_repository_impl.dart` (implement), modify `finance_page.dart`

### Feature 5: Open Positions Page + Close Flow

**What changes:**
- New page: `open_positions_page.dart` — lists open positions
- New page: `close_position_page.dart` — form to close a position
- New route: `/trades/open` in GoRouter
- Provider `openPositionsProvider` already exists in `trade_provider.dart` ✅
- Provider `closeOpenPositionProvider` already exists in `trade_provider.dart` ✅

**Data flow (list):**
```
OpenPositionsPage watches openPositionsProvider
  → openPositionsProvider.build() calls tradeQueryRepo.getOpenPositions(userId)
    → Returns List<OpenPosition>
```

**Data flow (close):**
```
User taps close on OpenPosition card
  → Navigates to ClosePositionPage with openPositionId
    → User enters close price, time, reason
      → Submits via ref.read(closeOpenPositionProvider)(...)
        → tradeCommandRepo.closePosition(openPositionId, closePrice, closeTime, reason)
          → Creates ClosedPosition, deletes OpenPosition
            → Invalidates openPositionsProvider and tradeListProvider
```

**Files touched:** New `open_positions_page.dart`, new `close_position_page.dart`, modify `router.dart` (add route), modify `main_shell.dart` (add tab or route)

### Feature 6: CSV Import → Real

**What changes:**
- `import_export_provider.dart`: Replace mock simulation with real file picker + CSV import
- Add `file_picker` package dependency
- Provider calls: file picker → get path → `tradeImportRepo.importClosedPositionsFromCsv(path, userId)`
- Report `ImportResult` (imported/skipped/errors) to UI

**Data flow:**
```
User taps Import in ImportExportPage
  → file_picker shows file dialog
    → User selects CSV file → gets filePath
      → importExportProvider calls tradeImportRepo.importClosedPositionsFromCsv(filePath, userId)
        → TradeImportRepositoryImpl parses CSV, inserts batch
          → Returns ImportResult
            → Provider updates state: ImportState.success(imported, skipped, errors)
              → Invalidates tradeListProvider
```

**Files touched:** `import_export_provider.dart`, `pubspec.yaml` (add file_picker), `import_export_page.dart` (wire to real provider)

**Platform concern:** `file_picker` works on all 6 target platforms (Android, iOS, Linux, macOS, Windows, Web). On Web, it uses `FileReader` API. On desktop, it uses native file dialogs.

### Feature 7: CSV Export → Real

**What changes:**
- `trade_export_repository_impl.dart`: Inject `TradeLocalDataSource`, query actual data instead of returning header-only CSVs
- `import_export_provider.dart`: Add export methods that call export repo, then save file using platform APIs
- File save: use `path_provider` + `share_plus` for mobile, direct file write for desktop

**Data flow:**
```
User taps Export in ImportExportPage
  → importExportProvider calls tradeExportRepo.exportClosedPositionsToCsv(filters)
    → TradeExportRepositoryImpl queries _localDataSource.getAllClosedPositions(userId)
      → Converts to CSV rows → returns CSV string
        → Provider saves to file (path_provider) and/or shares (share_plus)
```

**Files touched:** `trade_export_repository_impl.dart`, `di_providers.dart` (inject data source), `import_export_provider.dart`, `pubspec.yaml` (add path_provider, share_plus)

**Dependency:** Feature 6 (same provider, same page)

### Feature 8: Trade Edit/Delete Wiring

**What changes:**
- `trade_detail_page.dart`: Wire "Edit Trade" button → navigate to edit form (reuse `AddTradePage` with pre-filled data)
- `trade_detail_page.dart`: Wire "Delete" button → show confirmation dialog → call `deleteClosedPositionProvider`
- Providers `updateClosedPositionProvider` and `deleteClosedPositionProvider` already exist ✅

**Data flow (delete):**
```
User taps Delete button
  → Show AlertDialog confirmation
    → User confirms → ref.read(deleteClosedPositionProvider)(tradeId)
      → tradeCommandRepo.deleteClosedPosition(id)
        → Invalidates tradeListProvider
          → Navigate back to trade list
```

**Data flow (edit):**
```
User taps Edit button
  → Navigate to /trades/:id/edit with trade data
    → Pre-fill AddTradePage form with existing trade data
      → User modifies and submits
        → ref.read(updateClosedPositionProvider)(modifiedPosition)
          → tradeCommandRepo.updateClosedPosition(position)
            → Invalidates tradeListProvider
              → Navigate back to detail page
```

**Files touched:** `trade_detail_page.dart` (wire handlers), `add_trade_page.dart` (support edit mode), `router.dart` (add edit route)

### Feature 9: Theme Persistence

**What changes:**
- Add `shared_preferences` package
- `theme_provider.dart`: Load saved theme on build, save on change
- Keep `@Riverpod(keepAlive: true)` — persists across navigation

**Data flow:**
```
App starts → ThemeProvider.build()
  → SharedPreferences.getInstance()
    → Read saved ThemeMode (key: 'theme_mode')
      → Return saved mode or ThemeMode.system

User toggles theme → ThemeProvider.setTheme(mode)
  → state = mode
    → SharedPreferences.setString('theme_mode', mode.name)
```

**Files touched:** `theme_provider.dart`, `pubspec.yaml` (add shared_preferences)

---

## Dependency Graph & Build Order

### Dependency Graph

```
Phase 1 (Foundation — no dependencies)
├── Theme persistence (standalone)
└── Finance provider + page wiring (standalone)

Phase 2 (Core wiring — depends on Phase 1 finance data)
├── Analytics provider → real data
└── Finance data in analytics (accountBalance, deposits, withdrawals)

Phase 3 (Dependent on analytics being real)
├── Dashboard filters (depends on analytics provider)
└── Recommendation engine (depends on analytics data)

Phase 4 (Trade operations — depends on Phase 2 analytics for trade list)
├── Trade edit wiring
└── Trade delete wiring

Phase 5 (New pages — depends on Phase 4 for close flow)
├── Open positions page + route
└── Close position flow

Phase 6 (CSV — depends on Phase 2 for export data)
├── CSV import (file picker + real import)
└── CSV export (data source injection + file save)
```

### Recommended Build Order

| Order | Feature | Rationale | Dependencies |
|-------|---------|-----------|-------------|
| **1** | Theme persistence | Standalone. Zero coupling to other features. Quick win. | None |
| **2** | Finance provider + page wiring | Standalone. New provider + existing page. Enables analytics finance fields. | None |
| **3** | Analytics → real data | Core data pipe. Everything depends on analytics. | Finance data for balance fields |
| **4** | Dashboard filters | Extends analytics. Needs real analytics first. | Analytics provider |
| **5** | Recommendation engine | Reads analytics. Needs real analytics. | Analytics provider |
| **6** | Trade edit wiring | Small scope. Two button handlers + navigation. | None (providers exist) |
| **7** | Trade delete wiring | Small scope. One button handler + dialog. | None (providers exist) |
| **8** | Open positions page | New page + route. Close flow providers exist. | None (providers exist) |
| **9** | Close position flow | New page. Extends open positions. | Open positions page |
| **10** | CSV import | Platform integration. Needs file_picker. | None (import repo exists) |
| **11** | CSV export | Needs data source injection. Needs path_provider/share_plus. | None |

**Why this order:**
1. Theme persistence is isolated — no risk, builds confidence
2. Finance provider unblocks analytics (accountBalance needs deposit/withdrawal totals)
3. Analytics is the critical path — dashboard, recommendations, and charts all need it
4. Filters and recommendations are pure consumers of analytics
5. Edit/delete are quick wins with existing providers
6. Open positions needs a new page but providers exist
7. CSV is the most complex (file_picker, platform differences, CSV parsing edge cases)

---

## Patterns to Follow

### Pattern 1: Provider-to-Repository Wiring

All new providers follow the same pattern already established in `trade_provider.dart`:

```dart
@riverpod
class Analytics extends _$Analytics {
  @override
  Future<TradeAnalytics> build() async {
    final userId = ref.watch(supabaseAuthStateProvider)?.id;
    if (userId == null) return TradeAnalytics.empty;

    final repo = ref.watch(tradeQueryRepositoryProvider);
    final result = await repo.getAnalytics(userId, TradeFilter.empty);

    return result.getOrElse(() => TradeAnalytics.empty);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
```

**Key rules:**
- Get `userId` from `supabaseAuthStateProvider` (consistent pattern)
- Use `ref.watch` for reactive data, `ref.read` for callbacks
- Unwrap `Result<T>` with `getOrElse` — never throw from providers
- `ref.invalidateSelf()` for manual refresh

### Pattern 2: Family Provider for Filtered Data

When a provider needs external parameters (like a filter):

```dart
@riverpod
Future<TradeAnalytics> filteredAnalytics(Ref ref, TradeFilter filter) async {
  final userId = ref.watch(supabaseAuthStateProvider)?.id;
  if (userId == null) return TradeAnalytics.empty;

  final repo = ref.watch(tradeQueryRepositoryProvider);
  final result = await repo.getAnalytics(userId, filter);

  return result.getOrElse(() => TradeAnalytics.empty);
}
```

### Pattern 3: File Platform Integration

CSV import/export requires platform-specific file handling:

```dart
// Import: file_picker → path → repo.importFromCsv(path, userId)
// Export: repo.exportToCsv() → string → path_provider/save/share_plus
```

Package choices:
- `file_picker` for file selection (all 6 platforms)
- `path_provider` for save directory
- `share_plus` for mobile share sheet
- `csv` already in pubspec for CSV parsing

### Pattern 4: Provider Invalidation Chain

When data changes, invalidate dependent providers:

```
Write operation (add/update/delete/close)
  → invalidate tradeListProvider
  → invalidate analyticsProvider (if analytics data changed)
  → invalidate openPositionsProvider (if open positions changed)
```

This is already implemented in `trade_provider.dart` — follow the same pattern.

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Creating New Repository Interfaces for Single Methods

**Don't:** Create `FinanceQueryRepository` just for `getFinanceRecords`.
**Do:** Add `getFinanceRecords` to `TradeQueryRepository`. The ISP benefit of a separate interface doesn't justify the boilerplate for a single method.

### Anti-Pattern 2: Providers Bypassing Use Cases

**Current state:** All providers in `trade_provider.dart` call repositories directly, not use cases.
**Decision:** Follow the established pattern (call repos directly). Fixing this anti-pattern is a separate refactoring task. Mixing the two patterns within feature integration would be inconsistent.

### Anti-Pattern 3: Mixing Mock and Real Data in the Same Provider

**Don't:** Have analytics provider return mock data for missing fields (like accountBalance).
**Do:** Compute what's available from real data. `TradeAnalytics.empty` is the fallback, not mock data.

### Anti-Pattern 4: Direct Supabase Access in New Providers

**Don't:** Use `Supabase.instance.client.auth.currentUser` directly.
**Do:** Use `ref.watch(supabaseAuthStateProvider)?.id` pattern from `trade_provider.dart`. (Note: existing `TradeList` and `OpenPositions` providers still use the direct pattern — this is a known issue. New providers should use the clean pattern.)

---

## Data Layer Changes Required

### Minimal — Only 2 Data Layer Changes

| Change | File | Reason |
|--------|------|--------|
| Add `getFinanceRecords(userId)` | `trade_query_repository.dart` + impl | Finance page needs to read finance records through the query repo |
| Inject `TradeLocalDataSource` into `TradeExportRepositoryImpl` | `trade_export_repository_impl.dart` + `di_providers.dart` | Export currently returns header-only CSVs — needs to query real data |

### Analytics Finance Fields (accountBalance, totalDeposits, totalWithdrawals)

Currently `_computeAnalytics()` in `TradeQueryRepositoryImpl` returns `0` for these fields. To fix:
1. Query `getAllFinanceRecords(userId)` inside `_computeAnalytics()`
2. Compute totals from finance records
3. `accountBalance = totalDeposits - totalWithdrawals + totalProfitLoss`

This is a data layer change but stays within the existing repository implementation — no interface change.

---

## Scalability Considerations

| Concern | Current (10 trades) | Growth (1000 trades) | Growth (10K trades) |
|---------|---------------------|----------------------|---------------------|
| Analytics computation | Instant | ~50ms in-memory | ~200ms — may need pagination or cached aggregates |
| CSV import batch insert | Instant | ~500ms for batch | ~2-3s — need chunked inserts or progress streaming |
| Trade list rendering | All in memory | All in memory | Need pagination (Drift `limit`/`offset`) |
| Chart rendering | All data points | All data points | Need data sampling for equity curve |

**For v1 (current scope):** No performance work needed. These are future concerns.

---

## Sources

- **Codebase analysis:** All files in `lib/domain/`, `lib/data/`, `lib/presentation/providers/`, `lib/presentation/pages/`, `lib/app/` — direct source reading
- **Architecture documentation:** `ARCHITECTURE.md` (project root), `.planning/codebase/ARCHITECTURE.md`
- **Confidence:** HIGH — all findings verified against actual source code, not documentation claims
