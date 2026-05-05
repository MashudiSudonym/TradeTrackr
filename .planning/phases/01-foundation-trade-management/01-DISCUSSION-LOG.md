# Phase 1: Foundation & Trade Management - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-05
**Phase:** 1-Foundation & Trade Management
**Areas discussed:** Use case wiring strategy, Trade edit flow, Delete behavior & undo, Serialization cleanup scope, Theme persistence approach, List refresh strategy, UserId access pattern, Supabase debug mode, Testing during Phase 1, CSV files in repo root, Trade detail page buttons, Use case Params alignment, Local data source serialization

---

## Use Case Wiring Strategy

| Option | Description | Selected |
|--------|-------------|----------|
| Wire use cases into DI | All 11 use cases wired in di_providers.dart. Providers call useCase.call(). | ✓ |
| Keep current pattern | Providers → repos direct. Add validation to repos instead. | |
| Hybrid: wire writes only | Wire write use cases only, reads keep current pattern. | |

**Follow-up:**

| Option | Description | Selected |
|--------|-------------|----------|
| Wire all 11 at once | Consistent pattern, one batch refactor. | ✓ |
| Wire only Phase 1 use cases | Less scope but revisit later. | |

| Option | Description | Selected |
|--------|-------------|----------|
| Providers call use cases | Direct call to useCase.call(). Cleanest pattern. | ✓ |
| Facade service wrapping use cases | Thin facade between providers and use cases. | |

| Option | Description | Selected |
|--------|-------------|----------|
| Keep UseCase<T,P> pattern | Accept typed Params objects. No refactoring needed. | ✓ |
| Remove UseCase base | Plain classes with typed call() methods. | |
| Keep as-is | No changes to base class. | |

**Notes:** User wants consistent architecture — all 11 wired at once, providers call use cases, keep existing base class pattern.

---

## Trade Edit Flow

| Option | Description | Selected |
|--------|-------------|----------|
| Reuse AddTradePage, pre-fill | Navigate to AddTradePage with pre-filled data. Consistent. | ✓ |
| New EditTradePage | Separate page with different UX. More work. | |

| Option | Description | Selected |
|--------|-------------|----------|
| Single page with mode flag | AddTradePage detects tradeId → edit mode. | ✓ |
| Router-based dispatch | Wrapper decides which page to show. | |

| Option | Description | Selected |
|--------|-------------|----------|
| Same form for both | All fields visible for open and closed positions. | ✓ |
| Different form configs per type | Different field sets per position type. | |

| Option | Description | Selected |
|--------|-------------|----------|
| Show all fields, disable close fields | Close fields disabled but visible for open positions. | ✓ |
| Hide close fields for open positions | Form shrinks to only relevant fields. | |

**Notes:** Edit reuses AddTradePage with mode flag. Close fields shown but disabled for open positions.

---

## Delete Behavior & Undo

| Option | Description | Selected |
|--------|-------------|----------|
| Hard delete, sync removal | Permanent removal, sync propagates to Supabase. | ✓ |
| Soft delete with isDeleted flag | Hidden but recoverable. More complex. | |
| Hard delete with undo Snackbar | Temporary undo window. | |

| Option | Description | Selected |
|--------|-------------|----------|
| AlertDialog with Cancel/Delete | Standard Material confirmation. | ✓ |
| Bottom sheet with trade summary | More context before confirming. | |

| Option | Description | Selected |
|--------|-------------|----------|
| Pop to trade list | Standard detail-page deletion UX. | ✓ |
| Stay on detail page with deleted state | Unusual pattern. | |

**Notes:** Simple hard delete with standard AlertDialog. No undo mechanism. Pop to list after deletion.

---

## Serialization Cleanup Scope

| Option | Description | Selected |
|--------|-------------|----------|
| Clean up in Phase 1 | Refactor command + import repos to use DTOs. | ✓ |
| Clean up only command repo | Phase 1 scope only. | |
| Defer entirely | Leave inconsistency. | |

| Option | Description | Selected |
|--------|-------------|----------|
| Clean up both repos now | Command + import repo in one pass. | ✓ |
| Command repo only, defer import | Less risk for import parsing. | |

**Notes:** Both repos cleaned up now for consistency. Repo layer uses DTOs, data source keeps Drift Companions.

---

## Theme Persistence Approach

| Option | Description | Selected |
|--------|-------------|----------|
| Direct shared_preferences | Use package directly in theme provider. Matches existing TODO. | ✓ |
| Repository wrapper | Create SettingsRepository interface. More testable. | |

| Option | Description | Selected |
|--------|-------------|----------|
| build() loads, setState saves | Load in provider build(), save on change. | ✓ |
| Load in main.dart bootstrap | Earlier loading, more complex. | |

**Notes:** Simple direct approach. shared_preferences already a dependency.

---

## List Refresh Strategy

| Option | Description | Selected |
|--------|-------------|----------|
| Invalidate and re-fetch | ref.invalidateSelf() on trade list provider. | ✓ |
| Optimistic in-memory update | Update list immediately, sync in background. | |

**Notes:** Keep it simple. Re-fetch from DB after mutations.

---

## UserId Access Pattern

| Option | Description | Selected |
|--------|-------------|----------|
| Standardize via authProvider | All providers read userId from authStateProvider. | ✓ |
| Use Supabase via DI provider | Replace direct access with ref.read(supabaseClientProvider). | |

**Notes:** Single source of truth from authProvider. Eliminate Supabase.instance direct access.

---

## Supabase Debug Mode

| Option | Description | Selected |
|--------|-------------|----------|
| Gate behind kDebugMode | Change debug: true to debug: kDebugMode. One-line fix. | ✓ |
| Defer | Not a Phase 1 concern. | |

---

## Testing During Phase 1

| Option | Description | Selected |
|--------|-------------|----------|
| Test new code only | Tests for use case wiring, edit/delete, theme persistence. | ✓ |
| Defer testing entirely | Focus on wiring, tests later. | |
| Comprehensive testing | Test all touched code including existing. | |

**Notes:** Pragmatic — only test new code introduced in Phase 1.

---

## CSV Files in Repo Root

| Option | Description | Selected |
|--------|-------------|----------|
| Add to .gitignore now | Quick housekeeping, prevents data leaks. | ✓ |
| Defer | Not critical. | |

---

## Trade Detail Page Buttons

| Option | Description | Selected |
|--------|-------------|----------|
| Wire both edit & delete on detail page | Meet TRAD-01/TRAD-03 requirements. | ✓ |
| Wire list page only | Less scope, doesn't meet requirements. | |

---

## Use Case Params Alignment

| Option | Description | Selected |
|--------|-------------|----------|
| Accept entities as Params | Use cases accept ClosedPosition/OpenPosition directly. | ✓ |
| Keep existing Params, convert in providers | Handle conversion in provider layer. | |

**Notes:** Researcher should verify current Params types and recommend specific updates.

---

## Local Data Source Serialization

| Option | Description | Selected |
|--------|-------------|----------|
| Repo uses DTOs, data source keeps Companions | Only repo layer changes. Drift-specific code untouched. | ✓ |
| Data source also switches to DTOs | More consistent but more changes to working code. | |

---

## the agent's Discretion

- Exact order of DI wiring entries in di_providers.dart
- Naming of the edit mode flag/parameter on AddTradePage
- Snackbar messaging after successful edit/delete operations
- Whether to group related use case providers or keep them sequential

## Deferred Ideas

None — discussion stayed within phase scope
