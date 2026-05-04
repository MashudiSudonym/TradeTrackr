# AGENTS.md — TradeTrackr

High-signal instructions for AI agents working in this repo. Read the referenced `.md` files for full detail.

## Commands

```bash
flutter pub get                                                    # install deps
dart run build_runner build --delete-conflicting-outputs           # codegen (Freezed + Drift + Riverpod)
dart run build_runner watch --delete-conflicting-outputs           # codegen watch mode
flutter analyze                                                    # static analysis
flutter test                                                       # run tests (no test/ dir yet)
flutter test test/path/to/test.dart                                # single test file
flutter run -d linux                                               # run on device
dart format .                                                      # format
dart fix --apply                                                   # auto-fix lint issues
```

**After editing Freezed classes, Drift tables, or Riverpod providers, always rerun build_runner.**

## Code Generation

Three codegen tools produce generated files that are **gitignored and analyzer-excluded** — never edit them:

| Tool | Generated Extensions | Trigger |
|------|---------------------|---------|
| Freezed | `.freezed.dart`, `.g.dart` | DTOs, state classes, Result type |
| Drift | `.g.dart` | Database table definitions |
| Riverpod generator | `.g.dart` | `@riverpod`-annotated providers |

**Freezed 3.x requires `abstract` keyword** on every `@freezed` class. Omitting it produces a specific build error. Always write:

```dart
@freezed
abstract class MyState with _$MyState { ... }
```

## Architecture

Clean Architecture with strict layer rules. Dependency direction: **Presentation → Domain ← Data**.

- **`domain/`** — pure Dart, zero external deps. No Flutter, no Drift, no Supabase imports. Entities are plain classes (not Freezed). Repository interfaces are abstract.
- **`data/`** — implements domain interfaces. Contains Drift database, Supabase data sources, Freezed DTOs.
- **`presentation/`** — UI + Riverpod providers. **Never imports data layer.**
- **`core/`** — shared infra (sync engine, connectivity, logger, constants).

### Repository Segregation

Repositories split by **operation type**, not entity. Six interfaces in `domain/repositories/`:

- `trade_query_repository.dart` — reads
- `trade_command_repository.dart` — writes
- `trade_import_repository.dart` — CSV import
- `trade_export_repository.dart` — CSV export
- `auth_repository.dart` — authentication
- `user_profile_repository.dart` — profile CRUD

Each use case injects only the interface it needs (ISP). Implementations in `data/repositories/` use `_impl` suffix.

### Dependency Injection

All DI wiring lives in `presentation/providers/di_providers.dart`. That single file chains: Supabase client → data sources → repositories → use cases. Barrel exports exist at `domain/repositories/repositories.dart`, `domain/usecases/usecases.dart`, `presentation/providers/providers.dart`.

## Error Handling: Result<T>

Never throw exceptions from repositories or use cases. Return `Result<T>` (defined at `domain/core/result.dart`):

```dart
// Returning
return Result.success(data);
return Result.failure('Failed to add position: $e');

// Handling
result.when(
  failure: (error) => handleError(error),
  success: (data) => handleSuccess(data),
);

// Or check properties
if (result.isSuccess) { final data = result.value!; }
```

This is a Freezed union type — no `dartz`, no `Either`, no Failure class hierarchy.

## Riverpod Patterns

Use `@riverpod` codegen annotations, NOT manual `StateNotifierProvider`:

```dart
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  @override
  Future<List<ClosedPosition>> build() async { ... }
}
```

- Initialize in `build()`, never in constructors
- `@Riverpod(keepAlive: true)` for long-lived providers (database, auth, theme)
- `ref.read` for callbacks, `ref.watch` for reactive UI, `ref.listen` for side effects
- Use `AsyncValue.guard(() async { ... })` instead of manual try-catch for async operations
- Use `ref.invalidateSelf()` to refresh data

## Environment

`.env` file required at project root (see `.env.example`):

```
SUPABASE_URL=https://bheohnfxjnwdkqvftbnc.supabase.co
SUPABASE_ANON_KEY=<your_key>
```

Loaded via `flutter_dotenv` in `main.dart` → `SupabaseConstants.load()`. Supabase project ref: `bheohnfxjnwdkqvftbnc`.

## Database (Drift)

Database definition: `data/datasources/drift/database.dart` — 4 tables: `ClosedPositions`, `OpenPositions`, `FinanceRecords`, `Profiles`. After changing table definitions, rerun build_runner to regenerate `database.g.dart`.

For tests, use in-memory DB: `AppDatabase(NativeDatabase.memory())`.

## Supabase Migrations

SQL migrations in `supabase/migrations/` (001–006). Apply to the Supabase project via MCP tools or dashboard. Includes RLS policies (005) and updated_at triggers (006).

## Naming & Style

| Type | Convention | Example |
|------|-----------|---------|
| Entities | `snake_case.dart` | `trade_position.dart` |
| Use cases | `verb_noun.dart` | `add_trade.dart` |
| Repositories (interface) | `noun_repository.dart` | `trade_query_repository.dart` |
| Repositories (impl) | `noun_repository_impl.dart` | `trade_query_repository_impl.dart` |
| DTOs | `noun_dto.dart` | `trade_position_dto.dart` |
| Providers | `noun_provider.dart` | `trade_provider.dart` |
| Pages | `noun_page.dart` | `dashboard_page.dart` |

- Import order: Dart SDK → Flutter → Packages → Project (relative)
- Use trailing commas for multi-line parameters
- Use `@Default(0.0)` not `= 0.0` in Freezed factories
- Use `const` factory constructors in Freezed
- All comments and docs in English
- Git commits: `type(scope): subject` (see `CODING_STANDARDS.md`)

## CSV Import Quirks

- Date format: `dd/MM/yyyy HH:mm:ss`
- Ignore the `Total` summary row at end of file
- Close reason values: `TP`, `SL`, `USER`, `MANUAL`
- Side values: `BUY`, `SELL` (uppercase)
- See `CSV_FORMAT_REFERENCE.md` for full column specs

## Design System (Quick Refs)

Full specs in `DESIGN.md` and `CLAUDE.md`. Critical rules an agent will get wrong:

- **Never use `#000000`** — use `#2d3435` (Charcoal Ink) for primary text
- **No 1px borders** for sectioning — use background color shifts (tonal layering)
- **No Material shadows** — depth via tonal layering only; ambient shadow reserved for FABs
- **Win states**: `#006f05` (Forest Depth), **Loss states**: `#9e442c` (Muted Brick) — never use "alert red"
- **Primary accent**: `#be0038` (Crimson Heart)
- **Fonts**: Manrope (headlines, 600–800), Inter (body, 400–700)
- **Data labels**: Inter 500, ALL CAPS, 12px
- **Card radius**: 12px, no borders, no shadows
- **Mobile-first**: 390×780px

## Context7 Rule

Always query MCP Context7 first before using any package API, configuration, or pattern. Resolve the library ID, then query specific docs. Applies to all packages: Flutter, Riverpod, GoRouter, Supabase, Drift, Freezed, etc.

## Reference Documents

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Full project spec, design system, data model, screen map |
| `PRD.md` | Product requirements, features, NFRs |
| `ARCHITECTURE.md` | Clean Architecture patterns, sync engine, DI setup |
| `SOLID.md` | SOLID principles applied to this codebase |
| `CODING_STANDARDS.md` | Naming, formatting, error handling, testing, git conventions |
| `FREEZED_GUIDE.md` | Freezed 3.x patterns, `abstract` keyword requirement |
| `RIVERPOD_GUIDE.md` | Riverpod 3.x `@riverpod` patterns, GoRouter integration |
| `RESULT_PATTERN.md` | `Result<T>` union type usage across all layers |
| `DESIGN.md` | Design system tokens, components, layout rules |
| `CSV_FORMAT_REFERENCE.md` | CSV import/export column formats |

## Workflow Rules

- **Auto-commit**: After every code change (edit, new file, refactor), immediately commit with a descriptive message following the `type(scope): subject` convention. Do not batch changes across multiple edits — one commit per logical change.
