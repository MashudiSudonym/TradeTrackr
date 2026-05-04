# Testing Patterns

**Analysis Date:** 2026-05-04

## Test Framework

**Runner:**
- `flutter_test` SDK — built-in Flutter testing framework
- Config: standard Flutter test runner (no custom `test/` config file found)

**Assertion Library:**
- Built-in `expect()` from `package:flutter_test`
- `package:mockito` for mocking (v5.4.5 in dev_dependencies)

**Run Commands:**
```bash
flutter test                                    # Run all tests
flutter test test/path/to/test.dart             # Single test file
flutter test --coverage                         # Coverage report
genhtml coverage/lcov.info -o coverage/html     # View coverage HTML
```

## Test File Organization

**Location:**
- No `test/` directory exists yet — tests are not yet written
- Planned structure (from `CODING_STANDARDS.md`):

```
test/
├── unit/                           # Unit tests (domain layer)
│   ├── domain/
│   │   ├── usecases/
│   │   │   └── add_trade_test.dart
│   │   └── entities/
│   │       └── trade_position_test.dart
│   └── data/
│       ├── repositories/
│       │   └── trade_command_repository_impl_test.dart
│       └── datasources/
│           └── trade_local_data_source_test.dart
├── widget/                         # Widget tests (presentation layer)
│   └── presentation/
│       ├── pages/
│       │   └── add_trade_page_test.dart
│       └── widgets/
│           └── trade_card_test.dart
└── integration/                    # Integration tests
    └── features/
        └── trade_flow_test.dart
```

**Naming:**
- Test files: `noun_test.dart` — `add_trade_test.dart`
- Test directories mirror `lib/` structure under `test/`

## Test Structure

**Suite Organization (prescribed pattern):**
```dart
// test/domain/usecases/add_trade_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tradetrackr/domain/usecases/add_trade.dart';
import 'package:tradetrackr/domain/core/result.dart';

void main() {
  late AddTradeUseCase useCase;
  late MockTradeCommandRepository mockRepository;

  setUp(() {
    mockRepository = MockTradeCommandRepository();
    useCase = AddTradeUseCase(mockRepository);
  });

  group('AddTradeUseCase', () {
    test('should return failure when volume is zero', () async {
      // Arrange
      final position = ClosedPosition(/* ... */);

      // Act
      final result = await useCase.execute(AddTradeParams(position: position));

      // Assert
      expect(result.isFailure, true);
      expect(result.error, contains('Volume must be greater than 0'));
    });

    test('should add trade successfully', () async {
      // Arrange
      when(mockRepository.addClosedPosition(any))
          .thenAnswer((_) async => Result.success(position));

      // Act
      final result = await useCase.execute(AddTradeParams(position: position));

      // Assert
      expect(result.isSuccess, true);
      verify(mockRepository.addClosedPosition(any)).called(1);
    });
  });
}
```

**Patterns:**
- **Arrange-Act-Assert** structure in every test
- `group()` to organize tests by class/method under test
- `setUp()` to create fresh instances per test
- `tearDown()` for cleanup (close databases, dispose containers)

## Mocking

**Framework:** `mockito` (v5.4.5)

**Mock Generation:**
- Use `@GenerateNiceMocks([MockSpec<MyRepository>()])` annotation
- Run `dart run build_runner build` to generate mocks
- Generated mocks follow pattern: `MockSpec<TradeCommandRepository>()` → `MockTradeCommandRepository`

**Mocking repository interfaces:**
```dart
@GenerateNiceMocks([MockSpec<TradeCommandRepository>()])
import 'add_trade_test.mocks.dart';

// In test:
late MockTradeCommandRepository mockRepository;
```

**What to Mock:**
- Repository interfaces (`TradeCommandRepository`, `TradeQueryRepository`)
- Data sources (`TradeLocalDataSource`, `TradeRemoteDataSource`)
- External services (Supabase client, connectivity checker)
- Use cases (when testing providers)

**What NOT to Mock:**
- Domain entities — `ClosedPosition`, `OpenPosition`, `TradeFilter`
- Value objects — enums, Freezed state classes
- `Result<T>` — use directly (`Result.success()`, `Result.failure()`)
- Drift database for integration tests — use `NativeDatabase.memory()` instead

## Provider Testing

**Testing Riverpod providers:**
```dart
void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        tradeCommandRepositoryProvider.overrideWithValue(mockRepo),
        addTradeUseCaseProvider.overrideWithValue(mockUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('should fetch trade list', () async {
    // Arrange
    when(mockRepo.getClosedPositions(userId: anyNamed('userId')))
        .thenAnswer((_) async => Result.success([testPosition]));

    // Act
    final trades = await container.read(tradeListProvider.future);

    // Assert
    expect(trades.length, 1);
    expect(trades.first.symbol, 'EURUSD');
  });
}
```

**Provider override patterns:**
- Override repository providers with mock implementations
- Override use case providers with mock use cases
- Use `container.read(provider.notifier)` for notifier testing
- Use `container.read(provider)` for state reading

## Widget Testing

**Pattern:**
```dart
testWidgets('should display all form fields', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        tradeListProvider.overrideWith(() => MockTradeListNotifier()),
      ],
      child: const MaterialApp(home: DashboardPage()),
    ),
  );

  expect(find.text('Symbol'), findsOneWidget);
  expect(find.text('Volume'), findsOneWidget);
});
```

**Key rules:**
- Wrap widgets in `ProviderScope` with appropriate overrides
- Wrap in `MaterialApp` for theme and navigation
- Use `pumpWidget()` then `pump()` for async resolution
- Test user interactions with `tap()`, `enterText()`, `scroll()`

## Drift Database Testing

**In-memory database for tests:**
```dart
import 'package:drift/native.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('should insert and query closed positions', () async {
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

    await database.into(database.closedPositions).insert(companion);
    final results = await database.getAllClosedPositionsByUser('user-1');

    expect(results.length, 1);
    expect(results.first.symbol, 'EURUSD');
  });
}
```

**Key pattern:** `AppDatabase(NativeDatabase.memory())` — no file on disk, fast, isolated per test

## Fixtures and Factories

**Test Data:**
- Mock data exists at `lib/presentation/mock/mock_data.dart` and `lib/presentation/mock/chart_mock_data.dart`
- For tests, create entities inline with known test values
- Use fixed dates (`DateTime(2026, 4, 22, 10, 0)`) not `DateTime.now()` for deterministic tests

**Example test entity:**
```dart
final testPosition = ClosedPosition(
  id: 'test-id',
  userId: 'user-1',
  symbol: 'EURUSD',
  openTime: DateTime(2026, 4, 22, 10, 0),
  closeTime: DateTime(2026, 4, 22, 14, 0),
  volume: 0.1,
  side: TradeSide.buy,
  openPrice: 1.0850,
  closePrice: 1.0900,
  profit: 50.0,
  reason: CloseReason.user,
  createdAt: DateTime(2026, 4, 22),
  updatedAt: DateTime(2026, 4, 22),
);
```

## Coverage

**Requirements:**
- Domain layer: 90%+ coverage (business logic critical)
- Data layer: 80%+ coverage
- Presentation layer: 60%+ coverage (UI harder to test)

**View Coverage:**
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Current state:** No tests written yet — `test/` directory does not exist.

## Test Types

**Unit Tests:**
- Scope: Domain use cases, repository implementations, sync engine, utility functions
- Approach: Mock dependencies, test business logic in isolation
- Pattern: Arrange (create entity + mock responses) → Act (call use case method) → Assert (check Result)

**Widget Tests:**
- Scope: Individual widgets, pages
- Approach: `testWidgets()` with `ProviderScope` overrides
- Pattern: Pump widget → interact → verify widget tree

**Integration Tests:**
- Scope: Full feature flows (add trade → see in list, import CSV → verify data)
- Framework: `integration_test` package
- Approach: Not yet implemented

## Common Patterns

**Async Testing:**
```dart
test('should return success for valid trade', () async {
  final result = await useCase.execute(params);

  expect(result.isSuccess, true);
});
```

**Error Testing:**
```dart
test('should return failure when validation fails', () async {
  // Arrange — create invalid entity
  final invalidPosition = ClosedPosition(
    /* ... */ volume: 0,  // Invalid
  );

  // Act
  final result = await useCase.execute(AddTradeParams(position: invalidPosition));

  // Assert
  expect(result.isFailure, true);
  expect(result.error, contains('Volume must be greater than 0'));
});
```

**Result Pattern Testing:**
```dart
// Exhaustive matching
result.when(
  failure: (_) => fail('Should return success'),
  success: (data) {
    expect(data.id, 'test-id');
    expect(data.symbol, 'EURUSD');
  },
);

// Boolean check
expect(result.isSuccess, true);

// Nullable access
expect(result.value?.symbol, 'EURUSD');
```

**Provider Invalidation Testing:**
```dart
test('should invalidate trade list after add', () async {
  // Arrange
  when(mockRepo.addClosedPosition(any))
      .thenAnswer((_) async => Result.success(testPosition));

  // Act
  await container.read(addClosedPositionProvider)(testPosition);

  // Assert — verify provider was invalidated
  verify(mockRepo.getClosedPositions(userId: anyNamed('userId'))).called(greaterThan(1));
});
```

## Build Commands Reference

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/domain/usecases/add_trade_test.dart

# Run with coverage
flutter test --coverage

# Generate mocks (after adding @GenerateNiceMocks annotation)
dart run build_runner build --delete-conflicting-outputs

# Run analysis before tests
flutter analyze

# Format before commit
dart format .
```

---

*Testing analysis: 2026-05-04*
