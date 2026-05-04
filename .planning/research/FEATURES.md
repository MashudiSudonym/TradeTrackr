# Feature Landscape

**Domain:** Flutter trading journal (TradeTrackr)
**Researched:** 2026-05-04
**Mode:** Ecosystem — mapping missing features against trading journal industry norms

---

## Research Context

TradeTrackr is a **partially-built** Flutter trading journal. The domain layer, data layer, repository interfaces, providers, and most UI pages exist. The primary gap is **wiring existing layers together** — replacing mock data providers with real database queries, completing repository implementations (export is stub-only), and adding the few missing UI flows (open position list, edit/delete from detail page).

Sources for feature norms: Edgewonk, TradeZella, TraderSync, TradesViz (leading trading journal products), plus the project's own PRD.md which already defines the v1 scope.

---

## Table Stakes

Features every trading journal must have. Missing any of these means the product feels incomplete.

### 1. Open Position List & Close Flow

| Aspect | Detail |
|--------|--------|
| **Why expected** | Traders with open positions need to see them at a glance and close them. Every journal (Edgewonk, TradeZella, TraderSync) treats open positions as a first-class view. |
| **What exists** | `OpenPositions` provider reads real data from Drift. `ClosePositionSheet` widget is fully built. `closeOpenPosition` provider calls `TradeCommandRepository.closePosition()`. The repository impl handles the open→closed conversion with transactional semantics (insert closed, delete open). `OpenPositionCard` widget exists. |
| **What's missing** | No dedicated **Open Positions list page** in the screen map / router. The close sheet needs to be wired into whatever list page is created. The trade list page currently only shows closed positions. |
| **Complexity** | Low — it's wiring, not building. Router entry + list page that reuses existing provider + card widget. |
| **Dependencies** | None. This is the top-priority feature per PROJECT.md Key Decisions. |

### 2. Dashboard Analytics (Real Data)

| Aspect | Detail |
|--------|--------|
| **Why expected** | The dashboard is the home screen. Showing mock data when real data exists in the database is the single biggest credibility gap. Every journal product's dashboard is its centrepiece. |
| **What exists** | `TradeAnalytics` entity has all 13 metrics from PRD. `_computeAnalytics()` in `TradeQueryRepositoryImpl` computes winRate, totalPnL, avgProfit, largestWin, largestLoss, profitFactor, bestSymbol, worstSymbol, consecutiveLosses. `Analytics` provider exists but returns `MockData.mockAnalytics`. All 6 chart widgets exist with mock data. |
| **What's missing** | (a) **Provider wiring** — `analytics_provider.dart` must call `getAnalyticsUseCase` instead of returning mock. (b) **Missing analytics fields** — `accountBalance`, `totalDeposits`, `totalWithdrawals` are hardcoded to 0 because the analytics computation doesn't query finance records. `averageRiskRewardRatio`, `averageHoldingDuration`, `openPositions` count are not computed. (c) **Chart data wiring** — chart widgets render mock chart data instead of reading from analytics provider. (d) **Per-symbol, per-day, per-session analytics** — the PRD requires "win/loss by symbol", "profit by day of week", "profit by session" which need grouped queries, not just summary metrics. |
| **Complexity** | Medium — wiring is straightforward, but the grouped analytics (by symbol, day, session) need new query methods in the local data source and new fields in the analytics entity. |
| **Dependencies** | Depends on having closed positions in the database. Works immediately once wired. Finance-tracking metrics depend on Feature 7. |

### 3. Dashboard Filters

| Aspect | Detail |
|--------|--------|
| **Why expected** | Every trading journal allows filtering by date range, symbol, and side. Without filters, the dashboard is only useful as an all-time aggregate. Traders need to answer "how did I do this week?" or "what's my win rate on EURUSD?" |
| **What exists** | `TradeFilter` entity has `startDate`, `endDate`, `symbols`, `side`, `reasons`. `AnalyticsFilterBar` widget exists. `DateRangePicker` widget exists. `MultiSelectChip` widget exists. The query repository accepts all filter parameters. |
| **What's missing** | The filter bar isn't wired to the analytics provider. Provider doesn't accept filter params. No "apply filter" mechanism that re-fetches analytics with the current filter. Symbol list for the multi-select needs to be dynamically populated from existing trade data. |
| **Complexity** | Low — the plumbing exists, it just needs to be connected. |
| **Dependencies** | Depends on Feature 2 (real analytics provider). |

### 4. CSV Import (Functional)

| Aspect | Detail |
|--------|--------|
| **Why expected** | CSV import is how most traders populate their journal — broker exports. TradeZella, Edgewonk, TraderSync all support broker file import. Without it, users must enter trades manually one-by-one. |
| **What exists** | `TradeImportRepositoryImpl` has complete parsing for all 3 CSV types (closed, open, finance). Date parsing, enum parsing, Total-row filtering, nullable field handling all work. `ImportResult` entity tracks imported/skipped/errors. `ImportExport` provider exists but uses mock progress. UI shell on import/export page exists. |
| **What's missing** | (a) **Provider wiring** — `import_export_provider.dart` must call the real import repository instead of `startMockImport()`. (b) **File picker integration** — the provider must use `file_picker` to let the user select a CSV file, then pass the path to the repository. (c) **Format auto-detection** — the `importFromCsv()` method has a TODO for detecting file type based on headers. The separate `importClosedPositionsFromCsv`, `importOpenPositionsFromCsv`, `importFinanceRecordsFromCsv` methods exist but aren't connected to the UI. (d) **Duplicate handling** — the import repo currently doesn't check for existing IDs before inserting. PRD requires "skip rows whose ID already exists in the database." (e) **Progress reporting** — for large files, the UI should show row-by-row progress. (f) **Error detail reporting** — `ImportResult.errorMessages` list exists but isn't populated during parsing. |
| **Complexity** | Medium — parsing is done. The work is wiring + duplicate detection + format auto-detection + progress reporting. |
| **Dependencies** | None. Can be wired independently. |

### 5. CSV Export (Functional)

| Aspect | Detail |
|--------|--------|
| **Why expected** | Data portability is table stakes. Traders expect to export their journal for backup, spreadsheet analysis, or migration. Every journal supports CSV export. |
| **What exists** | `TradeExportRepositoryImpl` has the correct CSV headers for all 3 types. `ExportTradesUseCase` exists with methods for each type. |
| **What's missing** | (a) **Actual data querying** — all 3 export methods have `// TODO: Query actual data from data source`. They return header-only CSVs. Need to query from `TradeLocalDataSource` and serialize each row. (b) **File naming** — PRD specifies `tradetrackr_{type}_YYYYMMDD_HHmmss.csv`. (c) **Platform-specific saving** — `path_provider` for desktop downloads, `share_plus` for iOS share sheet, `share_plus` for Android. (d) **Provider wiring** — connect to `ImportExport` provider. |
| **Complexity** | Medium — the tricky part is platform-specific file handling, which is a cross-platform concern in Flutter. Data serialization is straightforward. |
| **Dependencies** | Depends on data existing in the database. The query methods in local data source must support the export use case (query all or filtered). |

### 6. Trade Editing & Deletion

| Aspect | Detail |
|--------|--------|
| **Why expected** | Traders make data entry mistakes. Being unable to fix a typo in a trade price or remove an accidental duplicate is a deal-breaker. Every journal supports this. |
| **What exists** | `updateClosedPosition`, `deleteClosedPosition`, `updateOpenPosition`, `deleteOpenPosition` providers all exist and call the command repository. Repository interface has all CRUD methods. `TradeDetailPage` exists. |
| **What's missing** | (a) **Edit flow** — no edit page/form pre-populated with existing trade data. The `AddTradePage` could be reused in "edit mode" if it accepted an initial position. (b) **Delete confirmation** — need a confirmation dialog before deletion. (c) **UI affordances** — edit/delete buttons on the trade detail page. |
| **Complexity** | Low — reuse AddTradePage in edit mode + add confirmation dialog. |
| **Dependencies** | None. |

### 7. Finance Tracking (Real Data)

| Aspect | Detail |
|--------|--------|
| **Why expected** | Account balance is a core dashboard metric. Without tracking deposits/withdrawals, the "Account Balance" metric shows $0 forever. Traders need to see their true equity, not just P/L. |
| **What exists** | `FinanceRecord` entity, `FinanceType` enum, `add_finance_page.dart`, `finance_page.dart`, mock finance data, `addFinanceRecord` in command repository. |
| **What's missing** | (a) **Finance page wired to real data** — the finance page must read from Drift instead of mock data. (b) **Balance computation** — `accountBalance = totalDeposits - totalWithdrawals + totalPnL` needs to be computed in the analytics repository (currently hardcoded 0). (c) **Finance query data source** — the local data source needs `getAllFinanceRecords(userId)` method for the list page. (d) **Finance edit/delete** — not in PRD v1 scope but may be expected. |
| **Complexity** | Low-Medium — the main work is wiring the finance page to real data and integrating balance computation into analytics. |
| **Dependencies** | Feature 2 (analytics) depends on this for balance/finance metrics. |

### 8. Theme Persistence

| Aspect | Detail |
|--------|--------|
| **Why expected** | Users who toggle dark mode expect it to stick. A theme toggle that resets every restart feels broken. |
| **What exists** | `ThemeProvider` exists. Toggle UI exists. |
| **What's missing** | Persisting the user's choice to local storage (SharedPreferences or Drift) so it survives app restart. |
| **Complexity** | Low — standard shared_preferences pattern. |
| **Dependencies** | None. |

---

## Differentiators

Features that set TradeTrackr apart from minimal journal apps. Not expected by all users, but highly valued when discovered.

### 9. Recommendation Engine (10 Rules)

| Aspect | Detail |
|--------|--------|
| **Value proposition** | Most free/cheap journals show raw metrics but don't tell you what to DO. Edgewonk's "Edge Finder" is their headline feature and costs $169+. TradeTrackr's recommendation engine, when working, provides similar value for free. |
| **What exists** | `GetRecommendationsUseCase` has 5 rules implemented (best symbol, consecutive losses, low win rate, negative profit factor, strong performance). `Recommendation` entity has title/description/severity. `recommendation_card.dart` widget exists. Recommendation page UI exists. |
| **What's missing** | (a) **5 more rules** from PRD: worst performing symbol, best/worst day to trade, best session, avg win vs avg loss comparison, risk-reward alert, win rate trend (last 10 vs overall), overtrading alert. (b) **Analytics fields needed** — most of these require per-symbol, per-day-of-week, per-session grouped data that doesn't exist yet. (c) **Provider wiring** — `recommendation_provider.dart` currently reads mock data. (d) **Minimum trade thresholds** — PRD specifies "minimum 5 trades" for symbol/day/session recommendations to avoid statistical noise. |
| **Complexity** | Medium-High — the rules themselves are simple logic, but the underlying grouped analytics queries are the hard part. Each rule needs its own slice of data. |
| **Dependencies** | Feature 2 (real analytics with grouped data). |

### 10. Session-Based Analytics (Trading Sessions)

| Aspect | Detail |
|--------|--------|
| **Value proposition** | Most basic journals only show day-of-week breakdown. Session-based analysis (Asian 00:00-08:00 UTC, London 08:00-16:00 UTC, New York 13:00-22:00 UTC) is a professional-grade feature that helps traders identify when their edge is strongest. TradeZella and Edgewonk both offer this. |
| **What exists** | PRD specifies "profit by session" chart. `profit_by_session_chart.dart` widget exists (mock data). |
| **What's missing** | Session definition constants, session grouping logic in analytics computation, integration into the chart widget and recommendation engine. |
| **Complexity** | Low — it's just a time-of-day bucketing function applied to trade open times. |
| **Dependencies** | Feature 2. |

### 11. Equity Curve Chart

| Aspect | Detail |
|--------|--------|
| **Value proposition** | The equity curve is the most important chart in any trading journal — it shows cumulative P/L over time, revealing drawdowns, growth trajectory, and consistency. Every serious journal has one. |
| **What exists** | `equity_curve_chart.dart` exists (mock data). |
| **What's missing** | Real cumulative P/L data. Needs a list of (date, running_total) pairs computed from closed positions sorted by close_time. This is a simple running sum but needs its own provider/data pipeline. |
| **Complexity** | Low — running sum over sorted positions. |
| **Dependencies** | Feature 2. |

---

## Anti-Features

Features to explicitly NOT build. Documented to prevent scope creep.

### Anti-Feature 1: Broker API Auto-Import

| Why avoid | What to do instead |
|-----------|-------------------|
| Requires per-broker integration (each has different APIs, auth, rate limits). The project has no broker SDKs. PRD explicitly defers this. | Support robust CSV import from broker exports. The CSV format reference already matches broker export formats. |

### Anti-Feature 2: Real-Time Price Feeds

| Why avoid | What to do instead |
|-----------|-------------------|
| Requires market data API subscription (paid). Adds real-time infrastructure complexity (WebSockets, streaming). PRD defers to v2. | Open positions show manually-entered "current price" or last-known price from CSV import. Users update if needed. |

### Anti-Feature 3: Multi-Account Support

| Why avoid | What to do instead |
|-----------|-------------------|
| Adds data model complexity (account entity, account switcher, cross-account analytics). Single-user, single-account is the v1 assumption per PRD. | All trades belong to the authenticated user. One account per user. |

### Anti-Feature 4: Social Features / Sharing

| Why avoid | What to do instead |
|-----------|-------------------|
| Not core to journaling value. Edgewonk charges extra for mentor sharing. Adds privacy concerns, infrastructure, moderation needs. | Focus on individual trader improvement through analytics and recommendations. |

### Anti-Feature 5: Strategy Backtesting

| Why avoid | What to do instead |
|-----------|-------------------|
| Requires historical market data, strategy definition language, simulation engine. Completely different product scope. TradeZella offers this but as a separate module. | Journal existing trades. Let the recommendation engine surface pattern-based insights instead. |

### Anti-Feature 6: Tags / Custom Labels on Trades

| Why avoid | What to do instead |
|-----------|-------------------|
| PRD explicitly defers. Adds data model changes (new table, new UI, new filter options, CSV format changes). | Use existing symbol + reason grouping for v1 pattern analysis. Can be added in a minor release later without architecture changes. |

### Anti-Feature 7: Over-Engineered CSV Import

| Why avoid | What to do instead |
|-----------|-------------------|
| Don't build a general-purpose CSV parser with column mapping, drag-and-drop column assignment, or multi-format auto-detection for arbitrary broker formats. This is a common over-engineering trap. | Support only the 3 documented formats (closed positions, open positions, finance records) with exact column headers. The broker-export CSV format is already documented in CSV_FORMAT_REFERENCE.md. If headers don't match, show a clear error. |

---

## Feature Dependencies

```
Open Position List + Close Flow ───────────────────── (independent, top priority)
Theme Persistence ─────────────────────────────────── (independent)
CSV Import Functional ─────────────────────────────── (independent)
CSV Export Functional ───── depends on ──→ data in DB (can develop in parallel)
Trade Edit/Delete ─────────────────────────────────── (independent)
Finance Tracking Real Data ────────────────────────── (independent)
        │
        ▼
Dashboard Analytics (Real) ── depends on ──→ Finance Tracking (for balance)
        │
        ├──→ Dashboard Filters ── depends on ──→ Analytics (Real)
        │
        ├──→ Equity Curve ── depends on ──→ Analytics (Real)
        │
        ├──→ Session Analytics ── depends on ──→ Analytics (Real)
        │
        └──→ Recommendation Engine (10 rules) ── depends on ──→ Analytics (Real) + Session + Day-of-Week
```

---

## MVP Recommendation

### Priority Order (for roadmap phases)

1. **Open Position List + Close Flow** — user-identified as #1 priority. All code exists, just needs a router entry and list page. **Phase 1.**

2. **Theme Persistence** — trivially small, but users notice immediately if it doesn't work. **Phase 1.**

3. **Dashboard Analytics (Real Data)** — replacing mock data is the single highest-impact change. Even partial wiring (without finance metrics) would be a massive improvement. **Phase 2.**

4. **Finance Tracking (Real Data)** — needed for account balance metric. Can be done alongside or just before analytics wiring. **Phase 2.**

5. **Dashboard Filters** — quick win once analytics provider is real. **Phase 2.**

6. **Trade Edit/Delete** — needed for data quality. Trivial implementation. **Phase 2.**

7. **CSV Import (Functional)** — high value for populating the journal. Parsing is done; needs wiring + duplicate detection. **Phase 3.**

8. **CSV Export (Functional)** — data portability. Medium effort due to platform-specific saving. **Phase 3.**

9. **Equity Curve + Session Analytics** — enhances the dashboard from "good" to "professional". **Phase 4.**

10. **Recommendation Engine (full 10 rules)** — the crown jewel feature but depends on all grouped analytics being available. **Phase 4.**

### Defer to v1.1+

- Strategy tags/labels — easy add but requires data model changes
- Finance record editing/deletion — not in PRD v1
- Trade notes/screenshot attachments — not in PRD v1
- Chart drill-down / tap-to-filter — nice-to-have UX enhancement

---

## Gap Analysis by Feature

### Feature 1: Open Position Management

| Sub-feature | Status | Gap |
|-------------|--------|-----|
| Open positions list page | Missing UI | Need new page with OpenPositions provider |
| Close position bottom sheet | **Built** | Just needs to be triggered from list |
| Open→Closed conversion | **Built** (repo + provider) | Working |
| Floating P/L display | **Built** (entity computes it) | Working |
| Sort/filter open positions | Missing | Not in PRD v1 but standard pattern |

### Feature 2: Dashboard Analytics

| Sub-feature | Status | Gap |
|-------------|--------|-----|
| Total Trades, Win Rate, P/L, Avg Profit, Largest Win/Loss | **Computed** in repo | Need provider wiring |
| Profit Factor | **Computed** (but formula may be wrong — uses avgWin/avgLoss instead of sumWins/sumLosses) | Fix formula + wire |
| Best/Worst Symbol | **Computed** (by total profit, not requiring min 5 trades) | Add min-trade threshold |
| Account Balance, Deposits, Withdrawals | **Stub** (hardcoded 0) | Need finance record queries in analytics |
| Average Risk-Reward Ratio | Not computed | Need SL/TP fields from positions |
| Average Holding Duration | Not computed | Need to average closeTime - openTime |
| Open Positions Count | Not computed (hardcoded 0) | Need to query open positions count |
| Per-symbol grouped data | Not computed | Need for chart + recommendations |
| Per-day-of-week grouped data | Not computed | Need for chart + recommendations |
| Per-session grouped data | Not computed | Need for chart + recommendations |
| Equity curve data (cumulative P/L) | Not computed | Need sorted running sum |

### Feature 4: CSV Import

| Sub-feature | Status | Gap |
|-------------|--------|-----|
| CSV parsing (all 3 formats) | **Built** | Working |
| Date parsing (dd/MM/yyyy HH:mm:ss) | **Built** | Working |
| Total row filtering | **Built** | Working |
| Nullable field handling | **Built** | Working |
| File picker integration | Missing | Need file_picker in provider |
| Format auto-detection | **Stub** (TODO in code) | Detect by header columns |
| Duplicate detection by ID | Missing | Need to check existing IDs before insert |
| Error message collection | Missing | errorMessages list not populated |
| Progress reporting | Missing | No row-by-row progress callback |
| Import summary UI | Partial | Provider has mock success state |

### Feature 9: Recommendation Engine

| Rule | Status | Analytics Needed |
|------|--------|-----------------|
| Best performing symbol | **Implemented** (needs min 5 threshold) | Per-symbol totals |
| Worst performing symbol | Not implemented | Per-symbol totals |
| Consecutive losses | **Implemented** | Already computed |
| Low win rate warning | **Implemented** | Already computed |
| Negative profit factor | **Implemented** | Already computed |
| Strong performance | **Implemented** | Already computed |
| Best day to trade | Not implemented | Per-day-of-week averages |
| Worst day to trade | Not implemented | Per-day-of-week averages |
| Best session | Not implemented | Per-session averages |
| Avg win vs avg loss | Not implemented | Already have avgWin/avgLoss |
| Risk-reward alert | Not implemented | avgRiskRewardRatio |
| Win rate trend (last 10 vs overall) | Not implemented | Last-N trades subset |
| Overtrading alert | Not implemented | Trades-per-day count |

---

## Sources

- PRD.md — defines v1 feature scope and acceptance criteria (HIGH confidence)
- PROJECT.md — tracks validated/active/out-of-scope requirements (HIGH confidence)
- Existing codebase analysis — domain entities, repositories, providers, widgets (HIGH confidence)
- Edgewonk features page (edgewonk.com/features) — industry reference for table stakes vs differentiators (MEDIUM confidence)
- TradeZella features page (tradezella.com/features) — industry reference for journal feature norms (MEDIUM confidence)
