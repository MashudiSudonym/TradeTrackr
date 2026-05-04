# Project Research Summary

**Project:** TradeTrackr
**Domain:** Flutter trading journal — offline-first with analytics, CSV import/export, and recommendation engine
**Researched:** 2026-05-04
**Confidence:** HIGH

## Executive Summary

TradeTrackr is a **partially-built** Flutter trading journal with a complete Clean Architecture stack (domain entities, repository interfaces, data layer, UI pages) but with most features returning mock data instead of real database queries. The primary gap across all 9 missing features is **wiring** — connecting existing providers to existing repositories, and connecting existing UI widgets to existing providers. No new domain entities, repository interfaces, or use cases are needed. The domain layer is complete.

The recommended approach is a 6-phase build that starts with standalone quick wins and DI prerequisites (Phase 1), delivers the user-prioritized open positions flow (Phase 2), then builds the critical analytics data pipeline (Phase 3), wires the dashboard and charts (Phase 4), completes CSV import/export (Phase 5), and finishes with the recommendation engine (Phase 6). Three packages should be upgraded before feature work begins: `csv` to v8 (better header-based parsing), `file_picker` to v11 (cross-platform save dialog), and `share_plus` to v13 (modern instance API). `fl_chart` stays at 0.70.x — all 6 chart widgets are already built against it.

The key risks are data integrity bugs in the existing code: the close-position operation is not wrapped in a database transaction (data loss risk), the profit factor formula is wrong (avgWin/avgLoss instead of sumWins/sumLosses), and the close-position flow uses manual map parsing that will crash because Drift stores DateTime as int. These must be fixed in Phases 1–2 before any user-facing release.

## Key Findings

### Recommended Stack

No new packages required. All 9 missing features use the existing dependency set. Three packages need major-version upgrades (zero existing usage, so migration cost is zero). `fl_chart` must NOT be upgraded — 6 chart widgets are already written against 0.70.x.

**Core technologies:**
- **Flutter + Dart** — cross-platform UI framework (already in use)
- **Riverpod 3.x** (`@riverpod` codegen) — state management, all providers use codegen pattern
- **Drift** — local SQLite database (4 tables: ClosedPositions, OpenPositions, FinanceRecords, Profiles)
- **Supabase** — auth + remote sync (project ref: `bheohnfxjnwdkqvftbnc`)
- **GoRouter** — declarative routing (4-tab shell with auth/onboarding redirects)
- **Freezed 3.x** — immutable DTOs and Result<T> union type
- **fl_chart 0.70.x** — chart rendering (6 widgets already built, do NOT upgrade to 1.x)

**Package upgrades needed:**
- `csv` ^6.0.0 → ^8.0.0 — `decodeWithHeaders()` eliminates manual column-index mapping
- `file_picker` ^9.2.3 → ^11.0.2 — `saveFile()` gives cross-platform save dialog + web download
- `share_plus` ^10.1.4 → ^13.1.0 — `SharePlus.instance.share(ShareParams(...))` for mobile share sheet

### Expected Features

The research identified 8 table-stakes features and 3 differentiators. Every feature has partial implementation — the gap is wiring, not greenfield development.

**Must have (table stakes):**
- Open Position List & Close Flow — user-identified #1 priority; providers and card widget exist, needs page + route
- Dashboard Analytics (Real Data) — highest-impact change; `TradeAnalytics` entity has all 13 metrics, 6 chart widgets built
- Dashboard Filters — `TradeFilter` entity, filter bar, and date range picker all exist; needs provider wiring
- CSV Import (Functional) — parsing done for all 3 formats; needs file picker, duplicate detection, format auto-detection
- CSV Export (Functional) — headers defined; needs data querying, platform-specific save/share
- Trade Edit & Deletion — CRUD providers exist; needs edit mode in AddTradePage + confirmation dialog
- Finance Tracking (Real Data) — entity, page, add-form exist; needs provider wiring + balance computation
- Theme Persistence — provider and toggle exist; needs `shared_preferences` wiring (package already latest)

**Should have (differentiators):**
- Recommendation Engine (10 rules) — 5 rules implemented, 5 more needed; requires grouped analytics data
- Session-Based Analytics — `profit_by_session_chart.dart` exists; needs UTC-based session bucketing
- Equity Curve Chart — widget exists; needs cumulative P/L running sum

**Defer (v2+):**
- Broker API auto-import, real-time price feeds, multi-account, social features, strategy backtesting, tags/labels

### Architecture Approach

The codebase follows strict Clean Architecture with Presentation → Domain ← Data dependency direction. The domain layer is complete — 6 repository interfaces, 11 use cases, 7 entities. The data layer has all implementations. The gap is entirely in the presentation layer: 4 providers return mock data, 1 finance provider doesn't exist, and 2 pages need to be created (open positions, close position form).

**Major components (existing, need wiring):**
1. **Analytics pipeline** — `TradeQueryRepositoryImpl._computeAnalytics()` → `analyticsProvider` → dashboard metrics + charts
2. **Import/export pipeline** — `TradeImportRepositoryImpl` (parsing done) / `TradeExportRepositoryImpl` (stub) → `importExportProvider`
3. **Trade CRUD pipeline** — `trade_provider.dart` (11 providers, all wired) — edit/delete just need UI handlers
4. **DI container** — `di_providers.dart` chains Supabase → data sources → repositories → use cases; missing use case providers

**Only 2 data-layer changes needed:**
1. Add `getFinanceRecords(userId)` to `TradeQueryRepository` + impl
2. Inject `TradeLocalDataSource` into `TradeExportRepositoryImpl` for real data queries

### Critical Pitfalls

1. **Non-atomic close position** — delete+insert not wrapped in Drift `transaction()`. App crash = lost trade data. Wrap in transaction before any user-facing release.
2. **Wrong profit factor formula** — uses `avgWin / avgLoss` instead of `sumWins / sumLosses`. Systematic wrong values shown to users.
3. **Close position crashes on DateTime cast** — `openDataMap['open_time'] as DateTime` fails because Drift stores DateTime as int. Use DTO or Drift typed data class.
4. **Analytics returns zeros for finance metrics** — `accountBalance`, `totalDeposits`, `totalWithdrawals` hardcoded to 0 because finance records are never queried.
5. **Consecutive losses tracks all-time max, not current streak** — false positive alerts to winning traders.

## Implications for Roadmap

Based on research, suggested 6-phase structure:

### Phase 1: Foundation & Quick Wins
**Rationale:** Standalone features with zero dependencies. Builds momentum and fixes DI prerequisites.
**Delivers:** Theme persistence, trade edit/delete, package upgrades, DI use case registration
**Addresses:** Features 6 (edit/delete), 8 (theme), package upgrades
**Avoids:** Pitfall 9 (missing use case providers) — must register before analytics wiring
**Files:** `di_providers.dart`, `theme_provider.dart`, `trade_detail_page.dart`, `add_trade_page.dart`, `router.dart`, `pubspec.yaml`

### Phase 2: Open Positions + Close Flow
**Rationale:** User-identified #1 priority. All providers exist — just needs page, route, and critical bug fixes.
**Delivers:** Open positions list page, close position flow, atomic transactions, fixed map parsing
**Addresses:** Feature 1 (open positions + close flow)
**Avoids:** Pitfall 1 (non-atomic close), Pitfall 5 (DateTime cast crash)
**Files:** New `open_positions_page.dart`, new route in `router.dart`, fix `trade_command_repository_impl.dart`

### Phase 3: Core Analytics Pipeline
**Rationale:** Analytics is the critical path — dashboard, charts, recommendations, and filters all depend on it. Finance data must come first for balance metrics.
**Delivers:** Real analytics provider, finance provider, fixed profit factor, fixed consecutive losses, finance metrics in analytics, invalidation cascade
**Uses:** Use cases registered in Phase 1, Riverpod providers, Drift queries
**Implements:** Analytics data flow from Drift → repository → use case → provider → dashboard
**Addresses:** Features 2 (analytics), 7 (finance tracking)
**Avoids:** Pitfall 2 (zero finance metrics), Pitfall 3 (wrong profit factor), Pitfall 4 (wrong consecutive losses), Pitfall 8 (stale analytics)
**Files:** `analytics_provider.dart`, new `finance_provider.dart`, `trade_query_repository_impl.dart`, `di_providers.dart`

### Phase 4: Dashboard + Charts + Filters
**Rationale:** Charts and filters consume analytics data. Chart data interfaces must be refactored before wiring (private mock classes block real data).
**Delivers:** All 6 charts with real data, dashboard filters, session analytics, equity curve, filter debounce
**Addresses:** Features 3 (filters), 10 (sessions), 11 (equity curve)
**Avoids:** Pitfall 6 (date filter on wrong column), Pitfall 7 (private mock data classes), Pitfall 15 (full rebuild cascade), Pitfall 17 (UTC timezone)
**Files:** 6 chart widgets, `dashboard_filter_provider.dart`, `AnalyticsFilterBar`, session grouping logic

### Phase 5: CSV Import/Export
**Rationale:** Most complex integration (platform-specific file handling, CSV edge cases). Independent of analytics but needs data pipeline working for export.
**Delivers:** Functional CSV import with file picker, duplicate detection, robust parsing; functional CSV export with platform-specific save
**Uses:** `file_picker` v11, `csv` v8, `share_plus` v13 (all upgraded in Phase 1)
**Addresses:** Features 4 (import), 5 (export)
**Avoids:** Pitfall 10 (fragile Total row), Pitfall 11 (single date format), Pitfall 12 (platform-specific save)
**Files:** `import_export_provider.dart`, `trade_export_repository_impl.dart`, `trade_import_repository_impl.dart`, new platform export service

### Phase 6: Recommendation Engine
**Rationale:** Depends on all grouped analytics (per-symbol, per-day, per-session) which are completed in Phases 3–4.
**Delivers:** Full 10-rule recommendation engine with minimum trade thresholds
**Addresses:** Feature 9 (recommendations)
**Avoids:** Pitfall 16 (only 4 of 10 rules)
**Files:** `get_recommendations.dart`, `recommendation_provider.dart`, `recommendation_card.dart`

### Phase Ordering Rationale

- **Phase 1 first** because DI use case registration (Pitfall 9) is a prerequisite for all analytics wiring
- **Phase 2 before analytics** because it's the user's top priority and it's independent (providers already exist)
- **Phase 3 before 4** because charts and filters consume analytics data — can't wire charts without real analytics
- **Phase 4 before 6** because the recommendation engine needs grouped analytics (per-symbol, per-day, per-session) that charts also need
- **Phase 5 is independent** but placed after analytics because export needs the data pipeline working for meaningful testing
- **Critical bug fixes** (Pitfalls 1, 3, 5) are placed in the phase where the affected code is first touched

### Research Flags

Phases likely needing deeper research during planning:
- **Phase 4 (Charts):** Chart data interface refactoring is not a standard pattern — need to design per-chart data contracts from `TradeAnalytics` entity
- **Phase 5 (CSV Export):** Platform-specific file handling (Web AnchorElement, mobile share sheet, desktop save dialog) needs testing on all 6 targets

Phases with standard patterns (skip research-phase):
- **Phase 1:** Standard provider wiring, `shared_preferences` pattern — well-documented
- **Phase 2:** Standard page + route creation — follows existing codebase patterns
- **Phase 3:** Standard provider-to-repository wiring — follows `trade_provider.dart` patterns
- **Phase 6:** Pure Dart logic — adding rules to existing use case

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | All packages verified on pub.dev. Zero new packages needed. 3 upgrades verified with API docs via Context7. |
| Features | HIGH | All 11 features cross-referenced against existing codebase. Gap analysis per-feature with file-level detail. Industry norms checked against Edgewonk, TradeZella, TraderSync. |
| Architecture | HIGH | Verified against actual source code. Every file in lib/ analyzed. Component boundaries and data flows traced end-to-end. |
| Pitfalls | HIGH | 17 pitfalls identified from deep code audit. Each verified against actual code (line numbers provided). Priority fix order based on blocking dependencies. |

**Overall confidence:** HIGH

### Gaps to Address

- **Chart data interface design:** 6 chart widgets use private mock data classes. Need to design public data contracts that map from `TradeAnalytics` to each chart's input format. No standard pattern — must be designed during Phase 4 planning.
- **Platform-specific export testing:** `file_picker` saveFile() + `share_plus` share sheet behavior varies across Android, iOS, Linux, macOS, Windows, Web. Needs manual testing on all targets. Can't be fully validated in automated tests.
- **Analytics performance at scale:** Current implementation loads all positions into memory for computation. Works for <1K trades. No pagination or caching strategy yet. Acceptable for v1 but needs monitoring.
- **Session timezone handling:** Session definitions (Asian/London/NY) are UTC-based. Need to verify all `DateTime` values from Drift are consistently UTC. Edge case: trades at session boundaries (00:00, 08:00, 16:00 UTC).

## Sources

### Primary (HIGH confidence)
- TradeTrackr codebase — full audit of `lib/` (domain, data, presentation layers)
- pub.dev — csv v8.0.0, file_picker v11.0.2, share_plus v13.1.0, fl_chart v1.2.0, shared_preferences v2.5.5
- Context7 — Drift (transactions, queries), Riverpod (invalidation, select pattern), fl_chart (API stability)
- PRD.md — v1 feature scope, analytics metrics definitions, recommendation rules

### Secondary (MEDIUM confidence)
- Edgewonk features page — trading journal feature norms (table stakes vs differentiators)
- TradeZella features page — session analytics, equity curve, broker import patterns
- CSV_FORMAT_REFERENCE.md — column specs, date format, Total row behavior

---
*Research completed: 2026-05-04*
*Ready for roadmap: yes*
