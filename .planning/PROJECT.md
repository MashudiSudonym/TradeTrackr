# TradeTrackr

## What This Is

A cross-platform Flutter trading journal that lets individual traders record, analyze, and improve their trading performance. Built with an offline-first architecture (Drift/SQLite + Supabase sync) using Clean Architecture patterns. The app runs on Android, iOS, Linux, macOS, Windows, and Web.

## Core Value

Traders can log every trade (manual or CSV import) and see actionable analytics that reveal their strengths, weaknesses, and patterns — turning raw trade data into measurable insight.

## Requirements

### Validated

<!-- Already shipped and functional in the codebase. -->

- ✓ User can sign up, sign in, sign out, and reset password via Supabase Auth — existing
- ✓ User session persists across app restarts — existing
- ✓ Unauthenticated users are redirected to login — existing
- ✓ User can view and edit their profile (display name) — existing
- ✓ User can change their password — existing
- ✓ User can delete their account — existing
- ✓ User can add closed positions with all required fields and auto-calculated profit — existing
- ✓ User can add open positions with all required fields — existing
- ✓ User can view trade detail page — existing
- ✓ User can view trade list page — existing
- ✓ User can add finance records via form — existing
- ✓ Onboarding flow for first-time users — existing
- ✓ Dashboard UI with charts, metrics, and filter bar rendered — existing (mock data)
- ✓ Recommendation page UI rendered — existing (mock data)
- ✓ 6 chart widgets (equity curve, P/L distribution, win/loss by symbol, win/loss by reason, profit by day, profit by session) — existing (mock data)
- ✓ CSV import/export UI shell with format selection — existing (not functional)
- ✓ Theme toggle (light/dark/system) — existing (persistence not working)
- ✓ Responsive layout for mobile and tablet/desktop — existing
- ✓ Design system applied throughout (Manrope, Inter, tonal layering, card styles) — existing

### Active

<!-- Current scope. Building toward these. -->

- [ ] Open Positions list page with ability to close positions
- [ ] Close position flow (close price, close time, reason, auto-calculated profit)
- [ ] Edit trade from detail page
- [ ] Delete trade from detail page
- [ ] CSV import with file picker, format detection, validation, duplicate handling, and summary report
- [ ] CSV export with file generation, naming convention, and platform-specific save/share
- [ ] Dashboard wired to real analytics data (not mock)
- [ ] All 13 summary metrics displayed on dashboard
- [ ] All 6 charts rendering real trade data
- [ ] Dashboard filters functional (date range, symbol, side, reason)
- [ ] Finance page showing real data (not mock)
- [ ] All 10 recommendation rules implemented and wired to real data
- [ ] Theme preference persisted across sessions

### Out of Scope

<!-- Explicit boundaries. Includes reasoning to prevent re-adding. -->

- Real-time price feeds — requires market data API integration, deferred to v2
- Push notifications — not in PRD v1, deferred
- Multi-account support — single trader assumption for v1
- Social features (sharing, leaderboards) — not core to trading journal value
- Mobile app store deployment (CI/CD, signing) — separate milestone after v1 complete
- OAuth login — email/password sufficient for v1
- Live trading integration — journal only, no broker connectivity

## Context

- **Existing codebase**: Well-structured Flutter app with Clean Architecture (domain/data/presentation layers). Drift for local SQLite storage, Supabase for auth + remote sync. Riverpod for DI and state management. Freezed for immutable types and Result<T>.
- **Key gap pattern**: Many features have complete UI and domain/data layers but are disconnected. Analytics, recommendations, and finance page all use mock data despite real providers and use cases existing. The primary work is wiring, not building from scratch.
- **CSV format**: Strict format from broker exports (dd/MM/yyyy HH:mm:ss dates, Total row to skip, uppercase enums). Documented in CSV_FORMAT_REFERENCE.md.
- **Design system**: Comprehensive design tokens in DESIGN.md. No #000000 (use #2d3435), no 1px borders (use tonal layering), no Material shadows. Manrope for headlines, Inter for body.
- **Code generation**: Freezed 3.x (requires `abstract` on @freezed classes), Drift, Riverpod generator. Run build_runner after model/provider changes.
- **Supabase project**: bheohnfxjnwdkqvftbnc with 6 migrations applied (includes RLS and updated_at triggers).

## Constraints

- **Tech stack**: Flutter 3.41+ / Dart 3.11+ — locked by existing codebase
- **Architecture**: Clean Architecture with strict layer rules (Presentation → Domain ← Data) — must maintain
- **Database**: Drift (local) + Supabase (remote) dual-store with sync engine — offline-first is a hard requirement
- **State management**: Riverpod with codegen (@riverpod) — no manual StateNotifierProvider
- **Error handling**: Result<T> union type — never throw from repositories/use cases
- **Platforms**: Must support Android, iOS, Linux, macOS, Windows, Web
- **Design**: Follow DESIGN.md tokens strictly — no deviations from established design system

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Complete PRD v1 features before any new features | Core functionality must be solid before extending | — Pending |
| Open positions as first priority | User-identified as most important missing capability | — Pending |
| Wire existing layers rather than rebuild | Domain/data layers exist; gap is in provider-to-UI connections | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-05-04 after initialization*
