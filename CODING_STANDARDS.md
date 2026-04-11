# Coding Standards - TradeTrackr

**Last Updated**: 2026-04-11
**Project**: TradeTrackr (Flutter Trading Journal App)
**Language**: Dart 3.x
**Framework**: Flutter 3.x (latest stable)

---

## Table of Contents
1. [File Naming Conventions](#file-naming-conventions)
2. [Import Organization](#import-organization)
3. [Code Formatting](#code-formatting)
4. [Documentation Standards](#documentation-standards)
5. [Error Handling Patterns](#error-handling-patterns)
6. [Testing Standards](#testing-standards)
7. [Git Commit Conventions](#git-commit-conventions)
8. [Code Review Checklist](#code-review-checklist)

---

## File Naming Conventions

### Directory Structure

```
lib/
├── domain/
│   ├── entities/              # trade_position.dart, user.dart
│   ├── usecases/              # add_trade.dart, get_trade_analytics.dart
│   ├── repositories/          # trade_query_repository.dart
│   └── enums/                 # trade_side.dart, close_reason.dart
├── data/
│   ├── datasources/           # trade_local_data_source.dart
│   ├── models/                # trade_position_dto.dart
│   └── repositories/          # trade_query_repository_impl.dart
└── presentation/
    ├── providers/             # trade_provider.dart, analytics_provider.dart
    ├── pages/                 # dashboard_page.dart, add_trade_page.dart
    └── widgets/               # trade_card.dart, filter_bar.dart
```

### Naming Rules

| Type | Convention | Example |
|------|------------|---------|
| **Entities** | `snake_case.dart` | `trade_position.dart`, `user.dart` |
| **Use Cases** | `verb_noun.dart` | `add_trade.dart`, `import_trades.dart` |
| **Repository Interfaces** | `noun_repository.dart` | `trade_query_repository.dart` |
| **Repository Implementations** | `noun_repository_impl.dart` | `trade_query_repository_impl.dart` |
| **Data Sources** | `noun_data_source.dart` | `trade_local_data_source.dart` |
| **DTOs / Models** | `noun_dto.dart` | `trade_position_dto.dart` |
| **Providers** | `noun_provider.dart` | `trade_provider.dart` |
| **Pages** | `noun_page.dart` | `dashboard_page.dart` |
| **Widgets** | `noun.dart` | `trade_card.dart` |
| **Enums** | `snake_case.dart` | `trade_side.dart` |
| **Themes** | `app_theme.dart` | `app_theme.dart` |

### Examples

```dart
// CORRECT
// lib/domain/entities/trade_position.dart
class ClosedPosition { }

// lib/domain/usecases/add_trade.dart
class AddTradeUseCase { }

// lib/domain/repositories/trade_query_repository.dart
abstract class TradeQueryRepository { }

// lib/data/repositories/trade_query_repository_impl.dart
class TradeQueryRepositoryImpl implements TradeQueryRepository { }

// lib/presentation/providers/trade_provider.dart
@riverpod
class TradeFormNotifier extends _$TradeFormNotifier { }

// lib/presentation/pages/dashboard_page.dart
class DashboardPage extends ConsumerStatefulWidget { }

// WRONG
// lib/domain/entities/TradePosition.dart      // Not snake_case
// lib/domain/usecases/AddTradeUseCase.dart     // Redundant suffix
// lib/domain/repositories/TradeQueryRepo.dart  // Abbreviation
// lib/data/repositories/TradeQueryRepoImpl.dart // Abbreviation
```

---

## Import Organization

### Import Order

Imports should be organized in this order:

1. **Dart SDK** (`dart:*`)
2. **Flutter** (`package:flutter/*`)
3. **Packages** (`package:*`)
4. **Project** (relative imports)

### Example

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

// 4. Project
import 'package:tradetrackr/domain/entities/trade_position.dart';
import 'package:tradetrackr/domain/usecases/add_trade.dart';
import 'package:tradetrackr/presentation/providers/trade_provider.dart';
```

### Barrel Exports

Use barrel files to simplify imports:

```dart
// lib/domain/repositories/repositories.dart
export 'trade_query_repository.dart';
export 'trade_command_repository.dart';
export 'trade_import_repository.dart';
export 'trade_export_repository.dart';
export 'auth_repository.dart';
export 'user_profile_repository.dart';

// Usage - single import instead of six
import 'package:tradetrackr/domain/repositories/repositories.dart';
```

---

## Code Formatting

### Line Length

- **Maximum line length**: 80 characters (soft limit), 120 characters (hard limit)
- **Use trailing commas** for multi-line parameters and arguments

```dart
// GOOD - Trailing comma enables proper formatting
final result = await useCase.execute(
  ClosedPosition(
    id: uuid.v4(),
    userId: currentUser.id,
    symbol: state.symbol,
    openTime: state.openTime!,
    closeTime: state.closeTime!,
    volume: state.volume,
    side: state.side,
    openPrice: state.openPrice,
    closePrice: state.closePrice,
    stopLoss: state.stopLoss,
    takeProfit: state.takeProfit,
    profit: state.side.calculateProfit(
      state.openPrice,
      state.closePrice,
      state.volume,
    ),
    reason: state.reason,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
);

// BAD - Too long, no trailing comma
final result = await useCase.execute(ClosedPosition(id: uuid.v4(), userId: currentUser.id, symbol: state.symbol, openTime: state.openTime!, closeTime: state.closeTime!, volume: state.volume, side: state.side, openPrice: state.openPrice, closePrice: state.closePrice, profit: state.side.calculateProfit(state.openPrice, state.closePrice, state.volume), reason: state.reason, createdAt: DateTime.now(), updatedAt: DateTime.now()));
```

### Indentation

- **2 spaces** for indentation (no tabs)
- **Cascades** (`..`) for method chaining on same object

```dart
// GOOD - Cascades
final query = (select(closedPositions)
  ..where((t) => t.userId.equals(userId))
  ..where((t) => t.isSynced.equals(false))
);
```

### Optional Parameters

```dart
// GOOD - Required positional parameters first, then optional
class ClosedPosition {
  const ClosedPosition({
    required this.id,           // Required
    required this.userId,       // Required
    required this.symbol,       // Required
    this.stopLoss,              // Optional
    this.takeProfit,            // Optional
    this.swap = 0.0,            // Default value
    this.commission = 0.0,      // Default value
  });
}

// BAD - Optional parameters before required
class ClosedPosition {
  const ClosedPosition({
    this.stopLoss,              // Optional first
    required this.id,           // Required after
    required this.symbol,
  });
}
```

---

## Documentation Standards

### Language Requirements

All code comments, documentation, and user-facing content must be written in **English**. TradeTrackr v1 is English-only per the PRD.

```dart
// WRONG - Comments in non-English
/// Representasi posisi trading yang sudah ditutup
/// Harga entry saat posisi dibuka

// CORRECT - Comments in English
/// Represents a closed trade position with entry and exit details.
/// Entry price when the position was opened.
```

### JSDoc-Style Comments

Use documentation comments for public APIs:

```dart
/// Use case for adding a new closed trade position.
///
/// Validates the trade position before adding it to the database.
/// Returns a [Failure] if validation fails or if the database
/// operation fails.
///
/// Example:
/// ```dart
/// final useCase = AddTradeUseCase(repository);
/// final result = await useCase.execute(position);
/// result.fold(
///   (failure) => print('Error: ${failure.message}'),
///   (success) => print('Added: ${success.symbol}'),
/// );
/// ```
class AddTradeUseCase {
  /// Executes the use case with the given [position].
  ///
  /// Returns [Right] with the added position,
  /// or [Left] with a [Failure] if the operation fails.
  Future<Either<Failure, ClosedPosition>> execute(
    ClosedPosition position,
  ) async {
    // Implementation
  }
}
```

### Method Documentation

```dart
/// Queries closed positions with optional filters.
///
/// Parameters:
/// - [startDate]: Filter positions opened after this date
/// - [endDate]: Filter positions closed before this date
/// - [symbols]: Filter by instrument symbols (e.g., EURUSD, NDX100)
/// - [side]: Filter by trade direction (BUY or SELL)
/// - [reasons]: Filter by close reason (TP, SL, User, Manual)
///
/// Returns a list of matching closed positions.
///
/// Throws [DatabaseFailure] if the query fails.
Future<Either<Failure, List<ClosedPosition>>> getClosedPositions({
  DateTime? startDate,
  DateTime? endDate,
  List<String>? symbols,
  TradeSide? side,
  List<CloseReason>? reasons,
}) async {
  // Implementation
}
```

### Inline Comments

Use inline comments sparingly, only for complex logic:

```dart
// Calculate profit using the side-aware formula:
// BUY: (exit - entry) * volume
// SELL: (entry - exit) * volume
final profit = position.side.calculateProfit(
  position.openPrice,
  exitPrice,
  position.volume,
);
```

### TODO Comments

```dart
// TODO(username): Implement pagination for trade list
// https://github.com/MashudiSudonym/TradeTrackr/issues/123

// FIXME: This is a temporary workaround for the CSV date parsing
// TODO(john): Support additional date formats beyond dd/MM/yyyy
```

---

## Error Handling Patterns

### Result Type (Either Pattern)

```dart
import 'package:tradetrackr/core/errors/failures.dart';

// GOOD - Return Result type
Future<Either<Failure, ClosedPosition>> addClosedPosition(
  ClosedPosition position,
) async {
  try {
    final dto = ClosedPositionDto.fromEntity(position);
    await _localDataSource.insertClosedPosition(dto);
    return Right(position);
  } on DatabaseException catch (e) {
    return Left(DatabaseFailure(e.toString()));
  }
}

// BAD - Throw exceptions
Future<ClosedPosition> addClosedPosition(
  ClosedPosition position,
) async {
  try {
    final dto = ClosedPositionDto.fromEntity(position);
    await _localDataSource.insertClosedPosition(dto);
    return position;
  } catch (e) {
    throw Exception('Failed to add trade'); // Don't throw!
  }
}
```

### Failure Types

```dart
/// Base failure class
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Database operation failure (Drift/SQLite errors)
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Input validation failure
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Network/connectivity failure
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Sync operation failure (Supabase push/pull errors)
class SyncFailure extends Failure {
  const SyncFailure(super.message);
}

/// CSV parse/import failure
class CsvParseFailure extends Failure {
  const CsvParseFailure(super.message);
}

/// Authentication failure (Supabase Auth errors)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}
```

### Handling Errors in UI

```dart
// GOOD - Handle errors gracefully with Freezed when/maybeWhen
final state = ref.watch(tradeListProvider);

return state.when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (error, stackTrace) {
    final message = _mapErrorMessage(error);
    return ErrorWidget(
      message: message,
      onRetry: () => ref.invalidate(tradeListProvider),
    );
  },
  data: (positions) => TradeList(positions: positions),
);

// BAD - Let errors crash the app
final state = ref.watch(tradeListProvider);
return TradeList(positions: state.value!); // Crashes if error!
```

### AsyncValue.guard

```dart
// GOOD - Use AsyncValue.guard for automatic error handling
Future<void> importCsv(String filePath) async {
  state = const AsyncValue.loading();
  state = await AsyncValue.guard(() async {
    return await _performImport(filePath);
  });
}

// BAD - Manual try-catch
Future<void> importCsv(String filePath) async {
  state = const AsyncValue.loading();
  try {
    final result = await _performImport(filePath);
    state = AsyncValue.data(result);
  } catch (e, st) {
    state = AsyncValue.error(e, st);
  }
}
```

---

## Testing Standards

### Test File Naming

```
test/
├── unit/                           # Unit tests (domain layer)
│   ├── domain/
│   │   ├── usecases/
│   │   │   └── add_trade_test.dart
│   │   └── entities/
│   │       └── trade_position_test.dart
├── widget/                         # Widget tests (presentation layer)
│   └── presentation/
│       └── pages/
│           └── add_trade_page_test.dart
└── integration/                    # Integration tests
    └── features/
        └── trade_flow_test.dart
```

### Unit Test Structure

```dart
// test/domain/usecases/add_trade_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tradetrackr/domain/usecases/add_trade.dart';

void main() {
  late AddTradeUseCase useCase;
  late MockTradeCommandRepository mockRepository;

  setUp(() {
    mockRepository = MockTradeCommandRepository();
    useCase = AddTradeUseCase(mockRepository);
  });

  group('AddTradeUseCase', () {
    test('should return validation failure when volume is zero', () async {
      // Arrange
      final position = ClosedPosition(
        id: 'test-id',
        userId: 'user-1',
        symbol: 'EURUSD',
        openTime: DateTime(2026, 4, 11, 10, 0),
        closeTime: DateTime(2026, 4, 11, 14, 0),
        volume: 0,    // Invalid
        side: TradeSide.buy,
        openPrice: 1.0850,
        closePrice: 1.0900,
        profit: 50.0,
        reason: CloseReason.user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      final result = await useCase.execute(position);

      // Assert
      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ValidationFailure>());
    });

    test('should add trade successfully', () async {
      // Arrange
      final position = ClosedPosition(
        id: 'test-id',
        userId: 'user-1',
        symbol: 'EURUSD',
        openTime: DateTime(2026, 4, 11, 10, 0),
        closeTime: DateTime(2026, 4, 11, 14, 0),
        volume: 0.1,
        side: TradeSide.buy,
        openPrice: 1.0850,
        closePrice: 1.0900,
        profit: 50.0,
        reason: CloseReason.user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockRepository.addClosedPosition(position))
          .thenAnswer((_) async => Right(position));

      // Act
      final result = await useCase.execute(position);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Should return Right'),
        (r) {
          expect(r.id, 'test-id');
          expect(r.symbol, 'EURUSD');
        },
      );
      verify(mockRepository.addClosedPosition(position)).called(1);
    });
  });
}
```

### Widget Test Structure

```dart
// test/presentation/pages/add_trade_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('should display all form fields', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeFormNotifierProvider
              .overrideWith(() => TradeFormNotifier()),
        ],
        child: const MaterialApp(home: AddTradePage()),
      ),
    );

    expect(find.text('Symbol'), findsOneWidget);
    expect(find.text('Volume'), findsOneWidget);
    expect(find.text('Open Price'), findsOneWidget);
  });

  testWidgets('should show validation error when symbol is empty',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tradeFormNotifierProvider
              .overrideWith(() => TradeFormNotifier()),
        ],
        child: const MaterialApp(home: AddTradePage()),
      ),
    );

    // Tap submit without filling fields
    await tester.tap(find.text('Save Trade'));
    await tester.pump();

    // Verify error message
    expect(find.text('Symbol is required'), findsOneWidget);
  });
}
```

### Drift Database Testing

```dart
// test/data/datasources/trade_local_data_source_test.dart
import 'package:drift/native.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    // Use in-memory database for tests
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('should insert and query closed positions', () async {
    // Arrange
    final companion = ClosedPositionsCompanion.insert(
      id: 'test-id',
      userId: 'user-1',
      symbol: 'EURUSD',
      openTime: DateTime(2026, 4, 11, 10, 0),
      closeTime: DateTime(2026, 4, 11, 14, 0),
      volume: 0.1,
      side: 'BUY',
      openPrice: 1.0850,
      closePrice: 1.0900,
      profit: 50.0,
      reason: 'User',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Act
    await database.insertClosedPosition(companion);
    final results = await database.getAllClosedPositions('user-1');

    // Assert
    expect(results.length, 1);
    expect(results.first.symbol, 'EURUSD');
    expect(results.first.profit, 50.0);
  });

  test('should filter positions by date range', () async {
    // Insert test data
    // ...

    // Query with date range
    final results = await database.getClosedPositionsByDateRange(
      userId: 'user-1',
      start: DateTime(2026, 4, 1),
      end: DateTime(2026, 4, 30),
    );

    expect(results.every((r) =>
      r.closeTime.isAfter(DateTime(2026, 4, 1)) &&
      r.closeTime.isBefore(DateTime(2026, 4, 30))
    ), isTrue);
  });
}
```

### Test Coverage Goals

- **Domain layer**: 90%+ coverage (business logic is critical)
- **Data layer**: 80%+ coverage
- **Presentation layer**: 60%+ coverage (UI is harder to test)

```bash
# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Git Commit Conventions

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

| Type | Description | Example |
|------|-------------|---------|
| `feat` | New feature | `feat(trade): add CSV import support` |
| `fix` | Bug fix | `fix(analytics): correct win rate calculation` |
| `refactor` | Code refactoring | `refactor(repositories): segregate read/write operations` |
| `style` | Code style changes | `style(theme): apply design system tokens` |
| `docs` | Documentation | `docs(guides): add architecture documentation` |
| `test` | Test changes | `test(usecases): add tests for add trade` |
| `chore` | Build/tooling | `chore(deps): upgrade riverpod to latest` |

### Examples

```bash
# Feature
git commit -m "feat(trade): add position close with profit calculation

- Calculate profit based on trade side (BUY/SELL)
- Remove open position after closing
- Mark record as unsynced for background sync

Closes #12"

# Bug fix
git commit -m "fix(csv): handle dd/MM/yyyy date format in import

- Add date format auto-detection
- Support both dd/MM/yyyy and yyyy-MM-dd formats
- Skip rows with invalid dates instead of crashing

Fixes #34"

# Refactor
git commit -m "refactor(sync): extract sync engine from repository layer

- Move sync logic to core/sync/sync_engine.dart
- Add connectivity-aware push/pull strategy
- Abstract sync status for UI consumption

Follows SRP and DIP principles"
```

---

## Code Review Checklist

### Functionality
- [ ] Does the code implement the requirements from PRD.md?
- [ ] Are edge cases handled (null prices, zero volume, empty symbol)?
- [ ] Is error handling appropriate for all failure types?
- [ ] Are validations in place for form inputs and CSV imports?

### Architecture
- [ ] Does it follow Clean Architecture (Presentation → Domain ← Data)?
- [ ] Are dependencies inverted (depend on abstractions)?
- [ ] Are interfaces segregated (small, focused)?
- [ ] Is SRP followed (single responsibility)?

### Offline-First
- [ ] Do all writes go to Drift first?
- [ ] Are new records marked `is_synced = false`?
- [ ] Does the sync engine handle this record type?
- [ ] Are reads always from Drift (never blocking on Supabase)?

### Code Quality
- [ ] Is code readable and self-documenting?
- [ ] Are magic numbers/strings replaced with constants?
- [ ] Is DRY principle followed (no duplication)?
- [ ] Are naming conventions followed?

### Testing
- [ ] Are unit tests included for business logic (use cases)?
- [ ] Are widget tests included for UI (pages)?
- [ ] Is test coverage adequate?

### Documentation
- [ ] Are all code comments written in English?
- [ ] Are public APIs documented?
- [ ] Are complex algorithms explained?

### Design System
- [ ] Do UI components follow the design tokens from CLAUDE.md?
- [ ] Is tonal layering used instead of shadows?
- [ ] Are correct color tokens used (Forest for wins, Brick for losses)?
- [ ] Is the no-line rule followed (background color shifts, no borders)?

### Performance
- [ ] Are expensive operations optimized?
- [ ] Are const constructors used where possible?
- [ ] Are unnecessary rebuilds avoided (ref.select)?

---

## Linting and Analysis

### Analysis Options

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    invalid_annotation_target: ignore
    missing_required_param: error
    missing_return: error
  exclude:
    - '**/*.g.dart'
    - '**/*.freezed.dart'
    - '**/*.drift.dart'    # Drift generated code

linter:
  rules:
    # Error rules
    - avoid_dynamic_calls
    - avoid_empty_else
    - avoid_relative_lib_imports
    - avoid_slow_async_io
    - avoid_type_to_string
    - avoid_types_as_parameter_names
    - cancel_subscriptions
    - close_sinks
    - comment_references
    - literal_only_boolean_expressions
    - no_adjacent_strings_in_list
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - test_types_in_equals
    - throw_in_finally
    - unnecessary_brace_in_string_interps
    - unnecessary_getters_setters
    - unnecessary_statements
    - unrelated_type_equality_checks
    - unsafe_html
    - valid_regexps
```

### Running Analysis

```bash
# Analyze code
flutter analyze

# Fix issues automatically
dart fix --apply

# Format code
dart format .
```

---

## Related Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Clean Architecture patterns
- [RIVERPOD_GUIDE.md](RIVERPOD_GUIDE.md) - Riverpod 3.x patterns
- [FREEZED_GUIDE.md](FREEZED_GUIDE.md) - Freezed 3.x guide
- [SOLID.md](SOLID.md) - SOLID principles
- [CLAUDE.md](CLAUDE.md) - Project instructions and quick reference
- [PRD.md](PRD.md) - Product requirements document

---

**Last Updated**: 2026-04-11
**Dart Version**: 3.x
**Flutter Version**: 3.x (latest stable)
