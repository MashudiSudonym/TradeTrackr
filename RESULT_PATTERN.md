# Result<T> Pattern - TradeTrackr

**Last Updated**: 2026-04-22
**Project**: TradeTrackr (Flutter Trading Journal App)

---

## Table of Contents

1. [Overview](#overview)
2. [Pattern Definition](#pattern-definition)
3. [Why Result<T>?](#why-resultt)
4. [Implementation](#implementation)
5. [Usage Patterns](#usage-patterns)
6. [Testing with Result<T>](#testing-with-resultt)
7. [Migration from Either](#migration-from-either)
8. [Best Practices](#best-practices)

---

## Overview

TradeTrackr uses the **Result<T> pattern** for error handling throughout the codebase. This is a Freezed union type that encapsulates either a successful value or a failure message, replacing the traditional Either<Failure, T> pattern.

### Key Benefits

- **Type-safe**: Compile-time guarantees for handling both success and failure cases
- **Zero external dependencies**: Pure Freezed union, no dartz package required
- **Simple failure type**: Uses `String` for error messages instead of complex Failure classes
- **Intuitive API**: Clear `when()`, `isSuccess`, `isFailure` methods
- **Consistent**: Single pattern across all layers (domain, data, presentation)

---

## Pattern Definition

### Location

```
lib/domain/core/result.dart
```

### Implementation

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// Result type for operations that can fail.
///
/// Represents either a success with a value [T] or a failure with an error message.
@freezed
class Result<T> with _$Result<T> {
  /// Creates a successful result containing [value].
  const factory Result.success(T value) = Success<T>;

  /// Creates a failure result containing an error [message].
  const factory Result.failure(String message) = Failure<T>;

  /// Returns true if this result is a success.
  bool get isSuccess => maybeWhen(
        success: (_) => true,
        orElse: () => false,
      );

  /// Returns true if this result is a failure.
  bool get isFailure => !isSuccess;

  /// Returns the success value if present, otherwise null.
  T? get value => maybeWhen(
        success: (value) => value,
        orElse: () => null,
      );

  /// Returns the error message if this is a failure, otherwise null.
  String? get error => maybeWhen(
        failure: (message) => message,
        orElse: () => null,
      );
}
```

---

## Why Result<T>?

### Before: Either<Failure, T> (dartz package)

```dart
// Complex: requires Failure class hierarchy
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class DatabaseFailure extends Failure { }
class ValidationFailure extends Failure { }
class NetworkFailure extends Failure { }

// Verbose: Left/Right wrapping
Future<Either<Failure, ClosedPosition>> addTrade(
  ClosedPosition position,
) async {
  try {
    await _dataSource.insert(dto);
    return Right(position);
  } catch (e) {
    return Left(DatabaseFailure(e.toString()));
  }
}

// Awkward: fold() syntax
result.fold(
  (failure) => print('Error: ${failure.message}'),
  (success) => print('Added: ${success.symbol}'),
);
```

### After: Result<T> (Freezed union)

```dart
// Simple: String for errors (enough for our use cases)
Future<Result<ClosedPosition>> addTrade(
  ClosedPosition position,
) async {
  try {
    await _dataSource.insert(dto);
    return Result.success(position);
  } catch (e) {
    return Result.failure('Database error: $e');
  }
}

// Clean: when() syntax
result.when(
  failure: (error) => print('Error: $error'),
  success: (data) => print('Added: ${data.symbol}'),
);
```

### Key Differences

| Aspect | Either<Failure, T> | Result<T> |
|--------|-------------------|-----------|
| Package | dartz (external) | freezed (already used) |
| Failure Type | Class hierarchy | String |
| Success Access | `result.fold((l) => ..., (r) => ...)` | `result.when(failure: ..., success: ...)` |
| Property Access | `isRight()`, `isLeft()` | `isSuccess`, `isFailure` |
| Value Access | `fold` required | `value` property |
| Error Access | `fold` required | `error` property |

---

## Implementation

### Repository Layer

```dart
// lib/data/repositories/trade_command_repository_impl.dart
class TradeCommandRepositoryImpl implements TradeCommandRepository {
  final TradeLocalDataSource _localDataSource;

  TradeCommandRepositoryImpl(this._localDataSource);

  @override
  Future<Result<ClosedPosition>> addClosedPosition(
    ClosedPosition position,
  ) async {
    try {
      final dto = ClosedPositionDto.fromEntity(position);
      await _localDataSource.insertClosedPosition(dto);
      return Result.success(position);
    } catch (e) {
      return Result.failure('Failed to add position: $e');
    }
  }

  @override
  Future<Result<ClosedPosition>> updateClosedPosition(
    ClosedPosition position,
  ) async {
    try {
      final dto = ClosedPositionDto.fromEntity(position);
      await _localDataSource.updateClosedPosition(dto);
      return Result.success(position);
    } catch (e) {
      return Result.failure('Failed to update position: $e');
    }
  }

  @override
  Future<Result<void>> deleteClosedPosition(String id) async {
    try {
      await _localDataSource.deleteClosedPosition(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failure('Failed to delete position: $e');
    }
  }
}
```

### Use Case Layer

```dart
// lib/domain/usecases/add_trade.dart
class AddTradeUseCase {
  final TradeCommandRepository _repository;

  AddTradeUseCase(this._repository);

  Future<Result<ClosedPosition>> execute(
    ClosedPosition position,
  ) async {
    // Business validation
    if (position.closeTime.isBefore(position.openTime)) {
      return const Result.failure('Close time must be after open time');
    }
    if (position.volume <= 0) {
      return const Result.failure('Volume must be greater than 0');
    }
    if (position.symbol.isEmpty) {
      return const Result.failure('Symbol cannot be empty');
    }

    return await _repository.addClosedPosition(position);
  }
}
```

### Presentation Layer (Providers)

```dart
// lib/presentation/providers/trade_provider.dart
@riverpod
class TradeFormNotifier extends _$TradeFormNotifier {
  @override
  TradeFormState build() => const TradeFormState.initial();

  Future<void> submit() async {
    state = const TradeFormState.submitting();

    // Build entity from form state
    final position = ClosedPosition(
      id: uuid.v4(),
      userId: _currentUser.id,
      symbol: state.symbol,
      openTime: state.openTime!,
      closeTime: state.closeTime!,
      volume: state.volume,
      side: state.side,
      openPrice: state.openPrice,
      closePrice: state.closePrice,
      stopLoss: state.stopLoss,
      takeProfit: state.takeProfit,
      profit: _calculateProfit(),
      reason: state.reason,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final useCase = ref.read(addTradeUseCaseProvider);
    final result = await useCase.execute(position);

    result.when(
      failure: (error) {
        state = TradeFormState.error(error);
      },
      success: (data) {
        state = TradeFormState.success(data);
        // Navigate or show success message
      },
    );
  }
}
```

---

## Usage Patterns

### Pattern 1: Basic When

```dart
final result = await repository.addTrade(position);

result.when(
  failure: (error) {
    // Handle error
    showSnackBar(message: error);
  },
  success: (data) {
    // Handle success
    navigateToDetail(data.id);
  },
);
```

### Pattern 2: Property Check

```dart
final result = await repository.getTrade(id);

if (result.isSuccess) {
  final trade = result.value!;
  // Use trade
} else {
  final error = result.error!;
  // Handle error
}
```

### Pattern 3: Chaining Results

```dart
Future<Result<ClosedPosition>> addAndSync(
  ClosedPosition position,
) async {
  // First, add locally
  final addResult = await _repository.addClosedPosition(position);
  if (addResult.isFailure) {
    return addResult;
  }

  // Then, sync to remote
  final syncResult = await _syncEngine.pushUnsyncedRecords();
  if (syncResult.isFailure) {
    // Trade added but sync failed - still return success
    // Background sync will retry
    return addResult;
  }

  return addResult;
}
```

### Pattern 4: Combining Results

```dart
Future<Result<TradeAnalytics>> computeAnalytics(
  List<ClosedPosition> trades,
) async {
  if (trades.isEmpty) {
    return const Result.failure('No trades to analyze');
  }

  try {
    final winRate = _calculateWinRate(trades);
    final totalProfit = trades.fold(0.0, (sum, t) => sum + t.profit);
    final avgProfit = totalProfit / trades.length;

    final analytics = TradeAnalytics(
      totalTrades: trades.length,
      winRate: winRate,
      totalProfit: totalProfit,
      averageProfit: avgProfit,
    );

    return Result.success(analytics);
  } catch (e) {
    return Result.failure('Failed to compute analytics: $e');
  }
}
```

### Pattern 5: AsyncValue Integration

```dart
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  @override
  Future<List<ClosedPosition>> build() async {
    final repository = ref.read(tradeQueryRepositoryProvider);
    final result = await repository.getClosedPositions();

    return result.when(
      failure: (error) => throw Exception(error),
      success: (positions) => positions,
    );
  }
}

// In widget:
class TradeListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tradeListNotifierProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorWidget(message: error.toString()),
      data: (positions) => ListView.builder(
        itemCount: positions.length,
        itemBuilder: (context, index) => TradeCard(trade: positions[index]),
      ),
    );
  }
}
```

---

## Testing with Result<T>

### Unit Test Example

```dart
// test/domain/usecases/add_trade_test.dart
void main() {
  late AddTradeUseCase useCase;
  late MockTradeCommandRepository mockRepository;

  setUp(() {
    mockRepository = MockTradeCommandRepository();
    useCase = AddTradeUseCase(mockRepository);
  });

  group('AddTradeUseCase', () {
    test('should return failure when validation fails', () async {
      // Arrange
      final position = ClosedPosition(
        id: 'test-id',
        userId: 'user-1',
        symbol: 'EURUSD',
        openTime: DateTime(2026, 4, 22, 10, 0),
        closeTime: DateTime(2026, 4, 22, 9, 0), // Invalid: before open time
        volume: 0.1,
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
      expect(result.isFailure, true);
      expect(result.error, contains('Close time must be after open time'));
    });

    test('should return success when trade is valid', () async {
      // Arrange
      final position = ClosedPosition(
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
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(mockRepository.addClosedPosition(position))
          .thenAnswer((_) async => Result.success(position));

      // Act
      final result = await useCase.execute(position);

      // Assert
      expect(result.isSuccess, true);
      result.when(
        failure: (_) => fail('Should return success'),
        success: (data) {
          expect(data.id, 'test-id');
          expect(data.symbol, 'EURUSD');
        },
      );
      verify(mockRepository.addClosedPosition(position)).called(1);
    });
  });
}
```

### Repository Test Example

```dart
// test/data/repositories/trade_command_repository_impl_test.dart
void main() {
  late TradeCommandRepositoryImpl repository;
  late MockTradeLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockTradeLocalDataSource();
    repository = TradeCommandRepositoryImpl(mockDataSource);
  });

  group('TradeCommandRepositoryImpl', () {
    test('should return success when adding position succeeds', () async {
      // Arrange
      final position = ClosedPosition(/* ... */);
      when(mockDataSource.insertClosedPosition(any))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.addClosedPosition(position);

      // Assert
      expect(result.isSuccess, true);
      expect(result.value?.id, position.id);
    });

    test('should return failure when data source throws', () async {
      // Arrange
      final position = ClosedPosition(/* ... */);
      when(mockDataSource.insertClosedPosition(any))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await repository.addClosedPosition(position);

      // Assert
      expect(result.isFailure, true);
      expect(result.error, contains('Failed to add position'));
    });
  });
}
```

---

## Migration from Either

### Step 1: Replace Type Signature

```dart
// Before
Future<Either<Failure, ClosedPosition>> addTrade(ClosedPosition position);

// After
Future<Result<ClosedPosition>> addTrade(ClosedPosition position);
```

### Step 2: Update Return Statements

```dart
// Before
return Right(position);
return Left(DatabaseFailure('Error'));

// After
return Result.success(position);
return Result.failure('Error');
```

### Step 3: Update Call Sites

```dart
// Before
result.fold(
  (failure) => handleError(failure.message),
  (success) => handleSuccess(success),
);

// After
result.when(
  failure: (error) => handleError(error),
  success: (data) => handleSuccess(data),
);
```

### Step 4: Update Tests

```dart
// Before
expect(result.isRight(), true);
result.fold((l) => fail(), (r) => expect(r.id, expectedId));

// After
expect(result.isSuccess, true);
result.when(
  failure: (_) => fail(),
  success: (data) => expect(data.id, expectedId),
);
```

---

## Best Practices

### DO

1. **Use descriptive error messages**
   ```dart
   return Result.failure('Failed to add position: Symbol cannot be empty');
   ```

2. **Handle validation at use case level**
   ```dart
   Future<Result<ClosedPosition>> execute(ClosedPosition position) async {
     if (position.volume <= 0) {
       return const Result.failure('Volume must be greater than 0');
     }
     return await _repository.addClosedPosition(position);
   }
   ```

3. **Always use `when()` for branching**
   ```dart
   result.when(
     failure: (error) => /* handle error */,
     success: (data) => /* handle success */,
   );
   ```

4. **Use `const` for fixed error messages**
   ```dart
   return const Result.failure('Invalid input');
   ```

5. **Chain operations carefully**
   ```dart
   final result1 = await operation1();
   if (result1.isFailure) return result1;
   final result2 = await operation2();
   return result2;
   ```

### DON'T

1. **Don't throw exceptions from repositories**
   ```dart
   // WRONG
   Future<ClosedPosition> addTrade(ClosedPosition position) async {
     throw Exception('Error');
   }

   // CORRECT
   Future<Result<ClosedPosition>> addTrade(ClosedPosition position) async {
     return Result.failure('Error');
   }
   ```

2. **Don't ignore Result in use cases**
   ```dart
   // WRONG
   await _repository.addTrade(position);

   // CORRECT
   final result = await _repository.addTrade(position);
   if (result.isFailure) {
     return result;
   }
   ```

3. **Don't use complex Failure classes**
   ```dart
   // WRONG - overkill for our needs
   abstract class Failure {
     final String message;
     final ErrorCode code;
     final dynamic originalError;
   }

   // CORRECT - simple string message
   Result.failure('Database connection failed: timeout');
   ```

4. **Don't nest `when()` calls**
   ```dart
   // WRONG - hard to read
   result1.when(
     failure: (e1) => result2.when(
       failure: (e2) => /* ... */,
       success: (d2) => /* ... */,
     ),
     success: (d1) => /* ... */,
   );

   // CORRECT - use property checks or extract methods
   if (result1.isFailure) return result1;
   if (result2.isFailure) return result2;
   return Result.success(combined(result1.value!, result2.value!));
   ```

---

## Related Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Clean Architecture patterns
- [CODING_STANDARDS.md](CODING_STANDARDS.md) - Error handling section
- [SOLID.md](SOLID.md) - SOLID principles
- [CLAUDE.md](CLAUDE.md) - Project instructions

---

**Last Updated**: 2026-04-22
