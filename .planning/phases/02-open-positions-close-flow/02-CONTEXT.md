# Phase 2: Open Positions & Close Flow - Context

**Gathered:** 2026-05-06
**Status:** Ready for planning

<domain>
## Phase Boundary

Users can view all their open positions on a dedicated page and close any position with price, time, and reason — the close operation is atomic (Drift transaction) so no data is lost if the app crashes. After closing, dashboard counts refresh immediately.

**Requirements:** OPEN-01, OPEN-02, OPEN-03, OPEN-04

**In scope:**
- Atomic close position transaction wrapping delete+insert in Drift `transaction()` (fix Pitfall 1)
- Dedicated Open Positions page with real data from local database
- Close Position Sheet wired with pre-filled defaults
- Dashboard card tap navigation to Open Positions page
- Dashboard position count refresh after closing
- Pull-to-refresh on the Open Positions page
- Card tap navigates to existing trade detail page

**Out of scope:**
- Analytics/dashboard wiring (Phase 3)
- CSV import/export functionality (Phase 4)
- Recommendation engine (Phase 5)
- Real-time price feeds or live floating P/L (v2)
- Filtering/sorting controls on Open Positions page

</domain>

<decisions>
## Implementation Decisions

### Page Layout
- **D-01:** Cards in a simple `ListView` — matches the `TradeListPage` pattern exactly for consistency. Use the existing `OpenPositionCard` widget.
- **D-02:** Sort positions newest-first by open time — most recent positions appear at top.
- **D-03:** Show position count in the app bar title (e.g., "Open Positions (3)") for quick glance.

### Close Sheet Behavior
- **D-04:** Pre-fill close price with the position's open price and close time with current time. User adjusts from there — fastest workflow for quick closes.
- **D-05:** Default close reason to `USER` — most common reason for manual close. User can change to TP/SL if applicable.

### Navigation & Dashboard Refresh
- **D-06:** Navigate to Open Positions page by tapping the dashboard "open positions" card. No new bottom nav tab needed.
- **D-07:** Invalidate both `openPositionsProvider` and `tradeListProvider` immediately after close — user sees updated counts when they return to dashboard. Consistent with Phase 1 pattern (D-12).
- **D-08:** Full-screen page (not a shell tab) — uses `parentNavigatorKey: _rootNavigatorKey` in GoRouter, with a back button. Route: `/open-positions`.

### Empty State & Error Handling
- **D-09:** Empty state shows centered icon with "No open positions" message and subtitle "Your open positions will appear here". Standard clean pattern.
- **D-10:** On close failure, show a `SnackBar` with error message and dismiss the sheet. User can retry by tapping Close again.

### Card Tap & Refresh
- **D-11:** Tapping an open position card navigates to the existing trade detail page with the position's data. Consistent with how closed positions work.
- **D-12:** Support pull-to-refresh on the list via `RefreshIndicator`. Refreshes data from local DB.

### Dashboard Card Content
- **D-13:** Dashboard card shows only the open positions count. No floating P/L — real-time price feeds are out of scope (v2).

### Agent's Discretion
- Exact empty state icon choice
- Snackbar duration and action text
- Transition animation for close sheet dismissal
- Whether to use `SliverAppBar` or standard `AppBar` for the page header
- Loading state animation (spinner vs shimmer)

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Architecture & Patterns
- `ARCHITECTURE.md` — System overview, Clean Architecture layers, DI wiring pattern
- `SOLID.md` — SOLID principles applied to this codebase
- `CODING_STANDARDS.md` — Naming, formatting, error handling, git conventions
- `RESULT_PATTERN.md` — `Result<T>` union type usage across all layers
- `FREEZED_GUIDE.md` — Freezed 3.x patterns, `abstract` keyword requirement
- `RIVERPOD_GUIDE.md` — Riverpod 3.x `@riverpod` patterns, GoRouter integration

### Design System
- `DESIGN.md` — Design tokens, components, layout rules (no #000000, no 1px borders, no Material shadows)

### Data Layer
- `lib/data/datasources/drift/database.dart` — Drift tables, existing `transaction()` usage pattern
- `lib/data/models/trade_position_dto.dart` — DTOs with `toEntity()` / `fromJson()` (Phase 1 pattern)
- `lib/data/repositories/trade_command_repository_impl.dart` — closePosition method to make atomic

### Key Implementation Files
- `lib/presentation/providers/di_providers.dart` — DI wiring (god node, handle carefully)
- `lib/presentation/providers/trade_provider.dart` — Open positions provider, close provider
- `lib/presentation/widgets/open_position_card.dart` — Card widget with onTap/onClosePosition callbacks
- `lib/presentation/widgets/close_position_sheet.dart` — Sheet with price/time/reason fields + showClosePositionSheet
- `lib/presentation/pages/trade_list_page.dart` — Pattern reference for new list page
- `lib/presentation/pages/trade_detail_page.dart` — Detail page for card tap navigation
- `lib/app/router.dart` — GoRouter with StatefulShellRoute, full-screen route pattern
- `lib/presentation/pages/pages.dart` — Barrel exports

### Concerns & Codebase Maps
- `.planning/codebase/CONCERNS.md` — Pitfall 1 (non-atomic close), Pitfall 5 (DateTime cast — fixed in Phase 1)
- `.planning/codebase/ARCHITECTURE.md` — Component responsibilities, data flow
- `.planning/codebase/STACK.md` — Technology stack, code generation details

### Prior Phase Context
- `.planning/phases/01-foundation-trade-management/01-CONTEXT.md` — Phase 1 decisions (D-12 invalidation, D-13/14 DTO serialization)
- `.planning/phases/01-foundation-trade-management/01-01-SUMMARY.md` — Phase 1 execution results

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **OpenPositionCard**: Widget already has `onTap` and `onClosePosition` callbacks — just needs wiring in the new page
- **ClosePositionSheet**: Sheet widget exists with `showClosePositionSheet` function, accepts `position` and `onConfirm` callback. Fields for close price, close time, reason.
- **TradeListPage**: Full pattern reference for the new page — `ConsumerStatefulWidget`, `ref.watch(provider)`, loading/error/empty states, `ListView`
- **Drift transaction()**: Already used in `database.dart` for `mergeClosedPositions`, `mergeOpenPositions`, `mergeFinanceRecords` — same pattern for atomic close
- **OpenPositionDto / ClosedPositionDto**: DTOs with `fromJson()` and `toEntity()` established in Phase 1

### Established Patterns
- **Provider invalidation for refresh**: `ref.invalidateSelf()` / `ref.invalidate(provider)` after mutations (Phase 1 D-12)
- **Result<T> error handling**: Repos return `Result.failure('message')`, providers throw on `!result.isSuccess`
- **Full-screen routes in GoRouter**: Use `parentNavigatorKey: _rootNavigatorKey` for pages outside the bottom nav shell
- **AsyncValue pattern**: `when(loading:, error:, data:)` for handling provider states in UI
- **DTO-based serialization**: All repos use DTOs for entity↔map conversion (Phase 1 D-13)

### Integration Points
- **`trade_command_repository_impl.dart` closePosition method**: Replace non-atomic delete+insert with atomic `closePositionInTransaction`
- **`trade_provider.dart`**: Add `ClosePosition` notifier with `ref.invalidate(openPositionsProvider)` and `ref.invalidate(tradeListProvider)` after close
- **`router.dart`**: Add `/open-positions` full-screen route with `OpenPositionsPage` builder
- **Dashboard page**: Wire the open positions card's `onTap` to navigate to `/open-positions`
- **`pages.dart` barrel**: Add `export 'open_positions_page.dart'`

</code_context>

<specifics>
## Specific Ideas

- Close sheet pre-fills: close price = position's open price, close time = DateTime.now(), reason = CloseReason.user
- Page title format: "Open Positions (3)" — count visible at a glance
- Sort: `positions.sort((a, b) => b.openTime.compareTo(a.openTime))` for newest-first
- Empty state subtitle: "Your open positions will appear here"
- Pull-to-refresh wraps the ListView in a RefreshIndicator, calls `ref.invalidate(openPositionsProvider)` on refresh
- Card tap: `context.go('/trade-detail', extra: position)` — navigate to existing detail page

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 2-Open Positions & Close Flow*
*Context gathered: 2026-05-06*
