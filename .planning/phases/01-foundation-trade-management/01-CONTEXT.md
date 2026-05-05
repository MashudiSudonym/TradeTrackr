# Phase 1: Foundation & Trade Management - Context

**Gathered:** 2026-05-05
**Status:** Ready for planning

<domain>
## Phase Boundary

Users can manage existing trades (edit, delete) via the trade detail page, and their theme preference persists across app sessions. This phase wires use cases into DI, fixes serialization inconsistency, connects edit/delete UI to real operations, persists theme preference, and performs codebase housekeeping.

**Requirements:** THEM-01, TRAD-01, TRAD-02, TRAD-03, TRAD-04

**In scope:**
- Wire all 11 use cases into DI providers
- Standardize userId access via authProvider (eliminate direct Supabase.instance calls in providers)
- Reuse AddTradePage in edit mode for both closed and open positions
- Wire trade detail page Edit and Delete buttons
- Hard delete with confirmation dialog and sync removal
- Persist theme preference via shared_preferences
- Clean up serialization inconsistency (command + import repos use DTOs)
- Gate Supabase debug mode behind kDebugMode
- Add *.csv to .gitignore (except assets/csv/)
- Test new code introduced in this phase

**Out of scope:**
- Open positions list page (Phase 2)
- Close position flow (Phase 2)
- Analytics/dashboard wiring (Phase 3)
- CSV import/export functionality (Phase 4)
- Recommendation engine (Phase 5)

</domain>

<decisions>
## Implementation Decisions

### Use Case Wiring
- **D-01:** Wire all 11 use cases into `di_providers.dart` in a single batch. Don't limit to Phase 1-only use cases — consistent pattern, no repeat refactoring.
- **D-02:** Providers call `useCase.call(params)` instead of calling repository methods directly. This ensures business validation runs for all operations.
- **D-03:** Keep the `UseCase<T, P>` abstract base class pattern. Use cases accept a typed Params object via `call()` method.
- **D-04:** Standardize userId access: all providers read userId from `authProvider` via `ref.watch(authStateProvider)`. Eliminate `Supabase.instance.client.auth.currentUser` direct access in providers.

### Trade Edit Flow
- **D-05:** Reuse `AddTradePage` for editing — add a mode flag (add vs edit). When `tradeId` parameter is provided, page switches to edit mode with pre-filled data.
- **D-06:** Same form for both open and closed positions. Close-related fields (closePrice, closeReason, closeTime) are shown but disabled when editing open positions.
- **D-07:** Wire both Edit and Delete buttons on the trade detail page (`trade_detail_page.dart` lines 456, 482). Edit navigates to AddTradePage in edit mode; Delete shows confirmation dialog.
- **D-08:** Use case Params should accept entity objects directly (e.g., `UpdateTradeUseCase` accepts `ClosedPosition` or `OpenPosition`). Researcher should verify current Params types and recommend updates.

### Delete Behavior
- **D-09:** Hard delete — permanently remove from local DB. Sync engine propagates deletion to Supabase (mark as deleted or remove).
- **D-10:** Standard `AlertDialog` with Cancel/Delete buttons for confirmation. No bottom sheet or trade summary.
- **D-11:** After deletion, pop back to trade list page. The list auto-refreshes via provider invalidation (TRAD-04).

### List Refresh Strategy
- **D-12:** After edit or delete, call `ref.invalidateSelf()` on the trade list provider to re-fetch from DB. Simple, always consistent. No optimistic in-memory updates.

### Serialization Cleanup
- **D-13:** Refactor `TradeCommandRepositoryImpl` and `TradeImportRepositoryImpl` to use Freezed DTOs (`ClosedPositionDto`, `OpenPositionDto`, `FinanceRecordDto`) for entity↔map conversion, matching the pattern already used by `TradeQueryRepositoryImpl`.
- **D-14:** Clean up both command repo AND import repo in Phase 1. One consistent pass across all repos.
- **D-15:** Local data source keeps its Drift-specific Companion maps (they work correctly). Only the repository layer switches to DTOs. Repos translate DTO → Drift Companion when calling data source methods.

### Theme Persistence
- **D-16:** Use `shared_preferences` directly in the theme provider — no repository wrapper. Matches the existing TODO in `theme_provider.dart`.
- **D-17:** Load saved theme preference in the provider's `build()` method. On theme change, write to `shared_preferences` and update state.

### Codebase Housekeeping
- **D-18:** Gate Supabase debug mode behind `kDebugMode` in `main.dart` (change `debug: true` to `debug: kDebugMode`).
- **D-19:** Add `*.csv` to `.gitignore` (except `assets/csv/` templates). Move any sample CSVs from repo root to `assets/csv/`.

### Testing
- **D-20:** Add tests only for new code introduced in Phase 1 (use case wiring, edit/delete providers, theme persistence). Don't retroactively test existing code.

### the agent's Discretion
- Exact order of DI wiring entries in `di_providers.dart`
- Naming of the edit mode flag/parameter on AddTradePage
- Snackbar messaging after successful edit/delete operations
- Whether to group related use case providers or keep them sequential in DI file

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Architecture & Patterns
- `ARCHITECTURE.md` — System overview, Clean Architecture layers, DI wiring pattern, anti-patterns to avoid
- `SOLID.md` — SOLID principles applied to this codebase
- `CODING_STANDARDS.md` — Naming, formatting, error handling, testing, git conventions
- `RESULT_PATTERN.md` — `Result<T>` union type usage across all layers
- `FREEZED_GUIDE.md` — Freezed 3.x patterns, `abstract` keyword requirement
- `RIVERPOD_GUIDE.md` — Riverpod 3.x `@riverpod` patterns, GoRouter integration

### Design System
- `DESIGN.md` — Design tokens, components, layout rules (no #000000, no 1px borders, no Material shadows)

### Data Layer
- `ARCHITECTURE.md` § Data Layer — Repository implementations, DTO↔Entity mapping, Drift database
- `data/datasources/drift/database.dart` — 4 Drift tables (ClosedPositions, OpenPositions, FinanceRecords, Profiles)
- `data/models/` — Freezed DTOs with `toEntity()` / `fromEntity()` factory methods

### Key Implementation Files
- `lib/presentation/providers/di_providers.dart` — DI wiring (god node, 47 edges, handle carefully)
- `lib/presentation/providers/trade_provider.dart` — Trade list and command providers (currently bypasses use cases)
- `lib/presentation/providers/theme_provider.dart` — Theme provider with TODO for persistence (line 8)
- `lib/presentation/providers/auth_provider.dart` — Auth state provider (userId source of truth)
- `lib/presentation/pages/trade_detail_page.dart` — No-op Edit (line 456) and Delete (line 482) buttons
- `lib/presentation/pages/add_trade_page.dart` — Form page to reuse in edit mode
- `lib/data/repositories/trade_command_repository_impl.dart` — Manual maps to replace with DTOs
- `lib/data/repositories/trade_import_repository_impl.dart` — Manual maps to replace with DTOs (lines 322-382)
- `lib/data/repositories/trade_query_repository_impl.dart` — Correct DTO pattern to follow
- `lib/main.dart` — Supabase init with `debug: true` (line 23)

### Concerns & Codebase Maps
- `.planning/codebase/CONCERNS.md` — Known bugs, tech debt, security considerations, fragile areas
- `.planning/codebase/ARCHITECTURE.md` — Component responsibilities, data flow, key abstractions
- `.planning/codebase/STACK.md` — Technology stack, dependencies, code generation details

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **AddTradePage**: Already has all form fields for both closed and open positions. Add edit mode flag to enable reuse.
- **DTOs in `data/models/`**: `ClosedPositionDto`, `OpenPositionDto`, `FinanceRecordDto` all have `toEntity()` and `fromJson()` — the correct serialization pattern that command/import repos should adopt.
- **Use cases in `domain/usecases/`**: 11 use cases exist but aren't wired in DI. They have `call()` methods accepting typed Params.
- **`shared_preferences`**: Already a dependency (used by `flutter_dotenv`). No new package needed for theme persistence.
- **`TradeQueryRepositoryImpl`**: Uses DTOs correctly — serves as the reference pattern for cleaning up command/import repos.
- **AlertDialog pattern**: Already used elsewhere in the codebase for destructive actions.

### Established Patterns
- **DI wiring in `di_providers.dart`**: Chains Supabase client → data sources → repositories. Follow this pattern for use cases: repo provider → use case provider.
- **`Result<T>` union type**: All repo/use case methods return `Result.success(data)` or `Result.failure('message')`. Never throw.
- **Provider invalidation**: `ref.invalidateSelf()` for refresh after mutations. Established in existing providers.
- **KeepAlive providers**: `authProvider`, `syncControllerProvider`, `themeProvider` use `@Riverpod(keepAlive: true)`.

### Integration Points
- **`di_providers.dart`**: Where all use cases get wired. New use case providers follow the existing repo provider pattern.
- **`trade_detail_page.dart:456,482`**: No-op buttons that need to be wired to navigation (edit) and dialog (delete).
- **`trade_provider.dart`**: Currently calls repos directly — switch to calling use cases after DI wiring.
- **`theme_provider.dart:8`**: TODO for shared_preferences persistence — implement in `build()`.
- **`auth_provider.dart`**: Source of truth for userId. All providers needing userId should read from here.

</code_context>

<specifics>
## Specific Ideas

- Edit mode on AddTradePage: detect `tradeId` parameter → pre-fill form → change Save to Update → call `UpdateTradeUseCase` instead of `AddTradeUseCase`
- Close fields (closePrice, closeReason, closeTime) visible but disabled when editing open positions — user can see them but can't modify until closing
- After delete confirmation: pop to trade list, list auto-refreshes, no undo mechanism
- Serialization cleanup: repo layer uses DTOs, data source layer keeps Drift Companions — the repo translates between them

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 1-Foundation & Trade Management*
*Context gathered: 2026-05-05*
