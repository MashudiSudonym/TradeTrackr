# Coding Conventions

**Analysis Date:** 2026-05-04

## Naming Patterns

**Files:**
- Use `snake_case.dart` for all Dart files
- Entity files: `closed_position.dart`, `open_position.dart`, `finance_record.dart`
- Use case files: `verb_noun.dart` — `add_trade.dart`, `import_trades.dart`, `sign_in.dart`
- Repository interfaces: `noun_repository.dart` — `trade_query_repository.dart`
- Repository implementations: `noun_repository_impl.dart` — `trade_command_repository_impl.dart`
- Data sources: `noun_data_source.dart` (interface), `noun_data_source_impl.dart` (impl)
- DTOs: `noun_dto.dart` — `trade_position_dto.dart`, `finance_record_dto.dart`
- Providers: `noun_provider.dart` — `trade_provider.dart`, `analytics_provider.dart`
- State classes: `noun_state.dart` — `import_state.dart`, `sync_status_state.dart`
- Pages: `noun_page.dart` — `dashboard_page.dart`
- Widgets: `noun.dart` — `trade_card.dart`, `metric_card.dart`
- Enums: `snake_case.dart` — `trade_side.dart`, `close_reason.dart`
- Barrel exports: plural noun — `repositories.dart`, `usecases.dart`, `providers.dart`, `widgets.dart`
- Utility classes: `noun_utils.dart` — `string_utils.dart`, `date_utils.dart`
- Constants: `noun_constants.dart` — `app_constants.dart`, `supabase_constants.dart`
- Extensions: `noun_extensions.dart` — `context_extensions.dart`

**Classes:**
- `PascalCase` for all class names
- Use cases: `VerbNounUseCase` — `AddTradeUseCase`, `ImportTradesUseCase`
- Entities: plain `PascalCase` — `ClosedPosition`, `OpenPosition`, `TradeAnalytics`
- DTOs: `PascalCaseDto` — `ClosedPositionDto`, `OpenPositionDto`
- Repository interfaces: `abstract class` — `TradeQueryRepository`
- Repository implementations: class with `Impl` suffix — `TradeCommandRepositoryImpl`
- Notifier classes: `PascalCase` extending generated `_$PascalCase` — `TradeList extends _$TradeList`
- Enums: `PascalCase` values — `TradeSide.buy`, `CloseReason.manual`
- Freezed union variants: `PascalCase` — `ImportIdle`, `ImportLoading`, `ImportSuccess`, `ImportError`

**Variables and Methods:**
- `camelCase` throughout
- Private members prefixed with underscore: `_localDataSource`, `_currentUserId`, `_validateAll()`
- Computed properties use getter syntax: `bool get isWin => profit > 0;`
- Constants in utility classes use `static const`: `AppConstants.defaultPageSize`

**Parameters:**
- Use `required` keyword for mandatory named parameters
- Required positional parameters first, then optional
- Use `@Default(value)` for Freezed defaults (not `= value`)

## Code Style

**Formatting:**
- `dart format .` for formatting (2-space indentation, 80-char soft / 120-char hard line limit)
- Trailing commas for all multi-line parameter lists
- `const` constructors and `const` declarations wherever possible
- Private constructor for utility classes: `StringUtils._();`, `AppConstants._();`

**Linting:**
- Config: `analysis_options.yaml` includes `package:flutter_lints/flutter.yaml`
- Key enforced rules from `analysis_options.yaml`:
  - `avoid_dynamic_calls` — no dynamic dispatch
  - `prefer_const_constructors`, `prefer_const_declarations`, `prefer_const_literals_to_create_immutables`
  - `cancel_subscriptions`, `close_sinks` — prevent stream leaks
  - `unrelated_type_equality_checks` — type-safe comparisons
  - `missing_required_param: error`, `missing_return: error` — strict analyzer
- Generated files excluded: `**/*.g.dart`, `**/*.freezed.dart`, `**/*.drift.dart`

**Analysis commands:**
```bash
flutter analyze          # Static analysis
dart fix --apply         # Auto-fix lint issues
dart format .            # Format all files
```

## Import Organization

**Order:**
1. Dart SDK (`dart:async`, `dart:convert`)
2. Flutter (`package:flutter/...`)
3. External packages (`package:riverpod_...`, `package:freezed_...`)
4. Project imports (relative paths)

**Example** (from `lib/presentation/providers/di_providers.dart`):
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';   // packages
import 'package:supabase_flutter/supabase_flutter.dart';          // packages

import '../../data/datasources/auth_remote_data_source.dart';     // project
import '../../data/repositories/auth_repository_impl.dart';       // project
import '../../domain/repositories/auth_repository.dart';          // project
```

**Path Aliases:**
- No path aliases configured — all imports use relative paths
- Use `../../` style relative imports between layers

**Barrel Files:**
- `lib/domain/repositories/repositories.dart` — exports all 6 repository interfaces
- `lib/domain/usecases/usecases.dart` — exports all 11 use cases
- `lib/presentation/providers/providers.dart` — exports all 9 provider files
- `lib/presentation/widgets/widgets.dart` — exports widget library
- `lib/core/utils/utils.dart` — exports utility files

## Error Handling

**Strategy:** Never throw exceptions from repositories or use cases. Return `Result<T>`.

**`Result<T>` Freezed union** — defined at `lib/domain/core/result.dart`:
```dart
@freezed
class Result<T> with _$Result<T> {
  const Result._();
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(String error) = Failure<T>;
}
```

**Returning from repositories** (from `lib/data/repositories/trade_command_repository_impl.dart`):
```dart
Future<Result<ClosedPosition>> addClosedPosition(ClosedPosition position) async {
  try {
    await _localDataSource.insertClosedPosition(dataMap);
    return Result.success(position);
  } catch (e) {
    return Result.failure('Failed to add position: $e');
  }
}
```

**Handling in use cases** (from `lib/domain/usecases/add_trade.dart`):
```dart
Future<Result<ClosedPosition>> call(AddTradeParams params) async {
  if (params.position.volume <= 0) {
    return const Result.failure('Volume must be greater than 0');
  }
  return await _repository.addClosedPosition(params.position);
}
```

**Handling in providers** (from `lib/presentation/providers/trade_provider.dart`):
```dart
final result = await repo.getClosedPositions(userId: userId);
return result.getOrElse([]);
```

**`Result<T>` API:**
- `result.when(failure: (err) => ..., success: (data) => ...)` — exhaustive pattern matching
- `result.isSuccess` / `result.isFailure` — boolean checks
- `result.value` — nullable success value
- `result.error` — nullable error string
- `result.getOrElse(fallback)` — success value or fallback
- `result.getOrThrow()` — success value or throw
- `result.map<R>(fn)` — transform success value
- `result.flatMap<R>(fn)` — chain Result-returning operations

**Failure hierarchy** — defined at `lib/core/errors/failures.dart`:
- `DatabaseFailure` — Drift/SQLite errors
- `ValidationFailure` — input validation errors
- `NetworkFailure` — connectivity errors
- `SyncFailure` — Supabase push/pull errors
- `CsvParseFailure` — CSV import errors
- `AuthFailure` — Supabase Auth errors

**Note:** The `Failure` class hierarchy exists but `Result<T>` uses `String` for errors, not `Failure` objects. The failure classes are used for categorization in logging via `app_logger.logFailure()`.

## Logging

**Framework:** `logger` package — `lib/core/logger/app_logger.dart`

**Global instance:** `final appLogger = Logger(...)` with `PrettyPrinter`

**Provider:** `appLoggerProvider` for Riverpod injection

**Failure logging extension:**
```dart
appLogger.logFailure('addClosedPosition', DatabaseFailure(e.toString()),
    error: e, stackTrace: stackTrace);
```

**Log level mapping:**
- `DatabaseFailure`, `AuthFailure` → `e()` (error)
- `NetworkFailure`, `SyncFailure`, `ValidationFailure`, `CsvParseFailure` → `w()` (warning)

**Global error handling** in `lib/main.dart`:
- `FlutterError.onError` — routes framework errors to logger
- `PlatformDispatcher.instance.onError` — catches async errors outside Flutter zone

## Comments

**When to Comment:**
- All public APIs: use `///` doc comments
- Complex business logic (profit calculation, CSV parsing)
- Freezed union variants — document each variant's purpose

**Documentation pattern** (from `lib/domain/core/result.dart`):
```dart
/// Result type for operations that can fail.
///
/// Represents either a success with a value [T], or a failure with an error.
/// This is a type-safe alternative to throwing exceptions.
```

**Method documentation** (from `lib/domain/repositories/trade_query_repository.dart`):
```dart
/// Get all closed positions with optional filtering.
Future<Result<List<ClosedPosition>>> getClosedPositions({...});
```

**Language:** All comments and documentation in English only

**TODO pattern:**
```dart
// TODO: Replace mock data with real repository when data layer is built.
```

## Function Design

**Size:** Use cases are small, single-responsibility methods. One validation check per `if` statement, early returns for failures.

**Parameters:**
- Named required parameters with `{required ...}`
- Optional nullable parameters (`DateTime? startDate`)
- Wrap multiple params in a params class for complex use cases (`AddTradeParams`)

**Return Values:**
- Repositories: always `Future<Result<T>>`
- Use cases: always `Future<Result<T>>` via `UseCase<T, P>` base class
- Providers: `Future<T>` (convert `Result` to throw on failure) or `T` for sync

**Base use case class** (from `lib/domain/core/usecase.dart`):
```dart
abstract class UseCase<T, P> {
  Future<Result<T>> call(P params);
}
```

## Module Design

**Exports:**
- Every layer has a barrel file for clean imports
- Domain layer: `repositories.dart`, `usecases.dart`
- Presentation: `providers.dart`, `widgets.dart`
- Data layer: no barrel file — imported directly via relative paths

**Barrel Files:**
- `lib/domain/repositories/repositories.dart`
- `lib/domain/usecases/usecases.dart`
- `lib/presentation/providers/providers.dart`
- `lib/presentation/widgets/widgets.dart`
- `lib/core/utils/utils.dart`

**Generated files:**
- `.g.dart` — Riverpod providers, Drift database, JSON serialization
- `.freezed.dart` — Freezed union implementations
- All generated files are gitignored and analyzer-excluded
- Never edit generated files — always rerun `build_runner`

## Code Generation Patterns

**Three codegen tools in use:**

| Tool | Annotation | Generated Extensions | Trigger |
|------|-----------|---------------------|---------|
| Freezed | `@freezed` | `.freezed.dart`, `.g.dart` | DTOs, state classes, `Result<T>` |
| Drift | `@DataClassName` | `.g.dart` | Database table definitions |
| Riverpod | `@riverpod` | `.g.dart` | All providers |

**Required after editing:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**Freezed 3.x critical rule:** Always use `abstract` keyword on `@freezed` classes:
```dart
@freezed
abstract class ImportState with _$ImportState { ... }
```

**Freezed defaults:** Use `@Default(0.0)` not `= 0.0`:
```dart
@Default(0.0) double swap,
@Default(false) bool isSynced,
```

**Custom methods on Freezed classes:** Use private constructor:
```dart
const Result._();  // enables custom getters/methods
```

## Design System Rules

**Enforced color tokens** (see `DESIGN.md`):
- Primary text: `#2d3435` (Charcoal Ink) — never `#000000`
- Win states: `#006f05` (Forest Depth)
- Loss states: `#9e442c` (Muted Brick) — never "alert red"
- Primary accent: `#be0038` (Crimson Heart)

**Layout rules:**
- Card radius: 12px, no borders, no shadows
- Depth via tonal layering only (background color shifts)
- No 1px borders for sectioning
- Mobile-first: 390×780px

**Typography:**
- Manrope for headlines (600–800 weight)
- Inter for body text (400–700 weight)
- Data labels: Inter 500, ALL CAPS, 12px

## Git Commits

**Format:** `type(scope): subject`

| Type | Use For |
|------|---------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code refactoring |
| `style` | Code style changes |
| `docs` | Documentation |
| `test` | Test changes |
| `chore` | Build/tooling |

**Auto-commit rule:** One commit per logical change, immediately after edit.

---

*Convention analysis: 2026-05-04*
