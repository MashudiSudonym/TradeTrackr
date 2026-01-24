# TradeTrackr - Agent Guidelines

This file contains essential information for agentic coding assistants working on the TradeTrackr Flutter project.

## Build, Lint, and Test Commands

### Testing
- `flutter test` - Run all tests
- `flutter test test/path/to/test_file.dart` - Run a single test file
- `flutter test --coverage` - Run tests with coverage report
- `flutter test -v` - Run tests with verbose output

### Code Analysis
- `flutter analyze` - Run static analysis (includes custom_lint and riverpod_lint)
- `dart analyze` - Alternative analysis command

### Code Generation
- `dart run build_runner build` - Generate code (Freezed, Riverpod, JSON, Drift)
- `dart run build_runner watch` - Continuous code generation during development
- `dart run build_runner clean && dart run build_runner build -d` - Clean and rebuild

### Dependencies
- `flutter pub get` - Install/update dependencies
- `flutter clean && flutter pub get` - Clean and reinstall dependencies

### Building
- `flutter run` - Run app on default device
- `flutter run -d linux` - Run on Linux
- `flutter run -d chrome` - Run on Web
- `flutter build apk` - Build Android APK

## Code Style Guidelines

### Language & Framework
- Dart SDK: ^3.9.2
- Flutter SDK: 3.35.5 (exact version required - use mise or fvm)
- State Management: Riverpod with code generation (@riverpod annotation)
- UI Library: Shadcn UI
- Database: SQLite with Drift ORM
- Testing: flutter_test with Mockito

### Architecture - Clean Architecture

#### Layer Structure
- **lib/presentation/** - UI, pages, providers (Riverpod)
- **lib/domain/** - Business logic, entities, use cases, repository interfaces
- **lib/data/** - Repository implementations, data sources (Drift/SQLite)

#### Layer Dependency Rule
Each layer only depends on layers below it. Presentation → Domain → Data. Never reverse.

### File Organization
- `lib/domain/entity/` - Immutable data models (use Freezed)
- `lib/domain/repository/` - Abstract repository interfaces
- `lib/domain/use_case/` - Business logic (group by feature)
- `lib/data/repository/` - Repository implementations (implement interfaces)
- `lib/data/datasource/local/` - Local data sources (Drift database)
- `lib/presentation/page/` - Screen widgets (ConsumerStatefulWidget)
- `lib/presentation/provider/` - Riverpod providers (repositories, use cases, controllers)

### Naming Conventions
- Files and directories: `snake_case.dart` (e.g., `user_repository.dart`)
- Classes: `PascalCase` (e.g., `UserEntity`, `UserRepositoryImpl`)
- Variables/Methods: `camelCase` (e.g., `firstName`, `saveUser`)
- Private members: `_camelCase` with underscore prefix
- Providers: Same name as class/type (e.g., `userRepositoryProvider`)
- Test files: `<name>_test.dart`

### Imports Order
1. Dart SDK imports (dart:*)
2. Package imports (package:*) - sorted alphabetically
3. Relative imports (package:trade_trackr/*) - sorted alphabetically

Example:
```dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:trade_trackr/domain/entity/user_entity.dart';
import 'package:trade_trackr/result.dart';
```

### Type Safety & Null Safety
- All code must be null-safe
- Use `required` for non-nullable constructor parameters
- Use nullable types (`Type?`) for optional values
- Prefer `final` for immutable variables
- Use `const` for compile-time constants

### Data Models (Freezed)
```dart
@freezed
abstract class EntityName with _$EntityName {
  factory EntityName({
    required String id,
    required String name,
    DateTime? optionalField,
  }) = _EntityName;

  factory EntityName.fromJson(Map<String, Object?> json) =>
      _$EntityNameFromJson(json);
}
```

### Repository Pattern
- Define interfaces in `lib/domain/repository/`
- Implement in `lib/data/repository/` with `*Impl` suffix
- Return `Result<T>` from all methods (success/failure pattern)
- Use `abstract interface class` for interfaces

### Use Case Pattern
```dart
class FeatureUseCase implements UseCase<Result<T>, ParamsType> {
  final RepositoryType _repository;

  FeatureUseCase({required RepositoryType repository})
    : _repository = repository;

  @override
  Future<Result<T>> call(ParamsType params) async {
    // Business logic here
  }
}
```

### Riverpod Providers
- Use code generation with `@riverpod` or `@Riverpod(keepAlive: true)`
- Repository providers watch dependencies
- Use `ref.watch()` to read dependencies
- Use `ref.onDispose()` for cleanup in database providers

```dart
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@riverpod
UserRepository userRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserRepositoryImpl(db: db);
}
```

### Error Handling
- Use `Result<T>` pattern from `lib/result.dart`
- Return `Result.success(value)` on success
- Return `Result.failed(message)` on failure
- Log errors using `Constants.logger.e('message: $error')`

### Database (Drift)
- Define tables in `lib/data/datasource/local/drift/`
- Table files: `snake_case_table.dart`
- Use `Value()` wrapper for nullable/non-nullable values in updates
- Use `insertOnConflictUpdate()` for upsert operations

### Logging
- Use `Constants.logger` from `lib/constants.dart`
- Log levels: `.d()` for debug, `.i()` for info, `.w()` for warnings, `.e()` for errors
- In tests, only warnings and errors are logged
- In debug mode, all logs are shown

### Testing
- Test files mirror source structure in `test/` directory
- Use `setUp()` and `tearDown()` for test lifecycle
- Use `group()` to organize related tests
- Repository tests use `NativeDatabase.memory()`
- Use `expect()` assertions

```dart
void main() {
  late Database db;
  late Repository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = RepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('RepositoryName', () {
    test('should do something', () async {
      // Arrange
      // Act
      // Assert
    });
  });
}
```

### UI Components
- Pages extend `ConsumerStatefulWidget`
- Use `ConsumerState` as state class
- Use `ref.watch()` to read provider state
- Use `ref.read()` for callbacks and one-time reads
- Use `ref.listen()` to handle provider state changes

### Formatting
- Line length: 80 characters (for generated code), 100+ for app code
- Use Dart formatter (`flutter format .`) before committing
- No trailing whitespace
- No unnecessary blank lines

### Commit Message Convention
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code refactoring
- `style:` - Code style changes (formatting)
- `test:` - Adding or updating tests
- `docs:` - Documentation changes

### Additional Notes
- Always run `dart run build_runner build` after modifying Freezed models, Riverpod providers, or Drift tables
- Generated files are ignored in git but required to run
- Database provider uses `keepAlive: true` to persist across rebuilds
- Use `shadcn_ui` components for consistent styling
- Route navigation uses `go_router` via `routerProvider`
