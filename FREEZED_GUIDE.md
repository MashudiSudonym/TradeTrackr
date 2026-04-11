# Freezed 3.x Guide - TradeTrackr

**Last Updated**: 2026-04-11
**Project**: TradeTrackr (Flutter Trading Journal App)
**Freezed Version**: 3.x (latest stable)
**Freezed Annotation Version**: 3.x (latest stable)

---

## Table of Contents
1. [Critical Requirement: abstract Keyword](#critical-requirement-abstract-keyword)
2. [Setup](#setup)
3. [Code Generation Workflow](#code-generation-workflow)
4. [Common Patterns](#common-patterns)
5. [Union Types](#union-types)
6. [Immutable Classes](#immutable-classes)
7. [CopyWith Pattern](#copywith-pattern)
8. [Migration from Freezed 2.x](#migration-from-freezed-2x)
9. [Best Practices](#best-practices)
10. [Common Issues & Solutions](#common-issues--solutions)
11. [Advanced Features](#advanced-features)

---

## Critical Requirement: abstract Keyword

**CRITICAL**: Freezed 3.x **requires** the `abstract` keyword before class definitions. This is a breaking change from Freezed 2.x.

### The Error You'll Get Without `abstract`

```dart
// WRONG - Missing 'abstract' keyword
@freezed
class TradeFormState with _$TradeFormState {
  const factory TradeFormState.initial() = TradeFormInitial;
}

// Error: The class 'TradeFormState' can't be designated as a '@freezed' class
// because it doesn't have the 'abstract' keyword.
```

### The Fix

```dart
// CORRECT - Includes 'abstract' keyword
@freezed
abstract class TradeFormState with _$TradeFormState {
  const factory TradeFormState.initial() = TradeFormInitial;
}
```

### Real Example from TradeTrackr

```dart
// lib/data/models/trade_position_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trade_position_dto.freezed.dart';
part 'trade_position_dto.g.dart';

@freezed
abstract class ClosedPositionDto with _$ClosedPositionDto {
  const ClosedPositionDto._();

  const factory ClosedPositionDto({
    required String id,
    required String userId,
    required String symbol,
    required DateTime openTime,
    required DateTime closeTime,
    required double volume,
    required String side,
    required double openPrice,
    required double closePrice,
    double? stopLoss,
    double? takeProfit,
    @Default(0.0) double swap,
    @Default(0.0) double commission,
    required double profit,
    required String reason,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isSynced,
  }) = _ClosedPositionDto;

  factory ClosedPositionDto.fromJson(Map<String, dynamic> json) =>
      _$ClosedPositionDtoFromJson(json);
}
```

---

## Setup

### Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  freezed_annotation: ^3.1.0

dev_dependencies:
  freezed: ^3.2.5
  build_runner: ^2.4.13
  json_serializable: ^6.8.0  # For toJson/fromJson with Supabase
```

### Import Statements

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_file.freezed.dart';  // Required
part 'my_file.g.dart';        // Required if using JsonSerializable
```

---

## Code Generation Workflow

### Step 1: Define Freezed Class

```dart
// lib/data/models/trade_analytics_dto.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'trade_analytics_dto.freezed.dart';
part 'trade_analytics_dto.g.dart';

@freezed
abstract class TradeAnalyticsDto with _$TradeAnalyticsDto {
  const factory TradeAnalyticsDto({
    required int totalTrades,
    required double winRate,
    required double totalProfitLoss,
    required double averageProfit,
    required double largestWin,
    required double largestLoss,
    required double profitFactor,
  }) = _TradeAnalyticsDto;

  factory TradeAnalyticsDto.fromJson(Map<String, dynamic> json) =>
      _$TradeAnalyticsDtoFromJson(json);
}
```

### Step 2: Run Code Generation

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (recommended during development)
dart run build_runner watch --delete-conflicting-outputs

# Clean build (if issues occur)
dart run build_runner build --delete-conflicting-outputs
```

### Step 3: Generated File

The generator creates `trade_analytics_dto.freezed.dart` and `trade_analytics_dto.g.dart`:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_analytics_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// ... generated implementation ...
```

### Step 4: Use in Code

```dart
void main() {
  // Create instances
  final analytics = TradeAnalyticsDto(
    totalTrades: 50,
    winRate: 62.5,
    totalProfitLoss: 1250.0,
    averageProfit: 25.0,
    largestWin: 500.0,
    largestLoss: -200.0,
    profitFactor: 2.1,
  );

  // Pattern matching with union types
  state.when(
    initial: () => print('Initial'),
    loading: () => print('Loading...'),
    data: (analytics) => print('Win rate: ${analytics.winRate}%'),
    error: (message) => print('Error: $message'),
  );
}
```

---

## Common Patterns

### Pattern 1: State Classes for Riverpod

```dart
@freezed
abstract class TradeFormState with _$TradeFormState {
  const factory TradeFormState.initial({
    String? symbol,
    @Default(TradeSide.buy) TradeSide side,
    @Default(0.0) double volume,
    @Default(0.0) double openPrice,
    double? stopLoss,
    double? takeProfit,
    DateTime? openTime,
    @Default({}) Map<String, String> validationErrors,
  }) = TradeFormInitial;

  const factory TradeFormState.loading() = TradeFormLoading;

  const factory TradeFormState.success(ClosedPosition position) =
      TradeFormSuccess;

  const factory TradeFormState.error(String message) = TradeFormError;
}

// Usage in provider
@riverpod
class TradeFormNotifier extends _$TradeFormNotifier {
  @override
  TradeFormState build() {
    return TradeFormState.initial();
  }

  Future<void> submit() async {
    state = const TradeFormState.loading();

    try {
      final result = await _submitTrade();
      state = TradeFormState.success(result);
    } catch (e) {
      state = TradeFormState.error(e.toString());
    }
  }
}

// Usage in UI
class AddTradePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tradeFormNotifierProvider);

    return state.when(
      initial: (form) => _buildForm(form),
      loading: () => const Center(child: CircularProgressIndicator()),
      success: (position) => _buildSuccess(position),
      error: (message) => _buildError(message),
    );
  }
}
```

### Pattern 2: Immutable Entities with Computed Properties

```dart
@freezed
abstract class ClosedPositionEntity with _$ClosedPositionEntity {
  const ClosedPositionEntity._(); // Private constructor for custom methods

  const factory ClosedPositionEntity({
    required String id,
    required String userId,
    required String symbol,
    required DateTime openTime,
    required DateTime closeTime,
    required double volume,
    required TradeSide side,
    required double openPrice,
    required double closePrice,
    double? stopLoss,
    double? takeProfit,
    @Default(0.0) double swap,
    @Default(0.0) double commission,
    required double profit,
    required CloseReason reason,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isSynced,
  }) = _ClosedPositionEntity;

  // Computed properties
  bool get isWin => profit > 0;

  Duration get holdingDuration => closeTime.difference(openTime);

  double get netProfit => profit - swap - commission;

  double get pips => switch (side) {
    TradeSide.buy => closePrice - openPrice,
    TradeSide.sell => openPrice - closePrice,
  };

  double? get riskRewardRatio {
    if (stopLoss == null || takeProfit == null) return null;
    final risk = (openPrice - stopLoss!).abs();
    final reward = (takeProfit! - openPrice).abs();
    return risk == 0 ? null : reward / risk;
  }

  String get formattedProfit => profit >= 0
    ? '+${profit.toStringAsFixed(2)}'
    : profit.toStringAsFixed(2);
}

// Usage
final position = ClosedPositionEntity(
  id: 'abc-123',
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

print(position.isWin);            // true
print(position.netProfit);        // 50.0
print(position.holdingDuration);  // 4:00:00.000000
print(position.pips);             // 0.005
print(position.formattedProfit);  // +50.00
```

### Pattern 3: Result Type (Either Alternative)

```dart
@freezed
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T data) = ResultSuccess;
  const factory Result.failure(String message) = ResultFailure;
}

// Usage
Future<Result<ClosedPositionEntity>> addPosition(
  ClosedPositionEntity entity,
) async {
  try {
    final id = await _database.insert(entity);
    return Result.success(entity.copyWith(id: id));
  } catch (e) {
    return Result.failure(e.toString());
  }
}

// Handle result
final result = await addPosition(position);
result.when(
  success: (data) => print('Trade added: ${data.symbol}'),
  failure: (message) => print('Error: $message'),
);
```

### Pattern 4: DTO Models with JSON Serialization (Drift + Supabase)

This pattern is specific to TradeTrackr's dual data source architecture. The same Freezed model needs to serialize to both Drift (SQLite maps) and Supabase (JSON).

```dart
@freezed
abstract class ClosedPositionDto with _$ClosedPositionDto {
  const ClosedPositionDto._();

  const factory ClosedPositionDto({
    required String id,
    required String userId,
    required String symbol,
    required DateTime openTime,
    required DateTime closeTime,
    required double volume,
    required String side,
    required double openPrice,
    required double closePrice,
    double? stopLoss,
    double? takeProfit,
    @Default(0.0) double swap,
    @Default(0.0) double commission,
    required double profit,
    required String reason,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isSynced,
  }) = _ClosedPositionDto;

  // Supabase JSON serialization
  factory ClosedPositionDto.fromJson(Map<String, dynamic> json) =>
      _$ClosedPositionDtoFromJson(json);

  // Convert to domain entity
  ClosedPositionEntity toEntity() {
    return ClosedPositionEntity(
      id: id,
      userId: userId,
      symbol: symbol,
      openTime: openTime,
      closeTime: closeTime,
      volume: volume,
      side: side == 'BUY' ? TradeSide.buy : TradeSide.sell,
      openPrice: openPrice,
      closePrice: closePrice,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      swap: swap,
      commission: commission,
      profit: profit,
      reason: CloseReason.values.firstWhere(
        (r) => r.name.toUpperCase() == reason,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  // Convert from domain entity
  factory ClosedPositionDto.fromEntity(ClosedPositionEntity entity) {
    return ClosedPositionDto(
      id: entity.id,
      userId: entity.userId,
      symbol: entity.symbol,
      openTime: entity.openTime,
      closeTime: entity.closeTime,
      volume: entity.volume,
      side: entity.side.name.toUpperCase(),
      openPrice: entity.openPrice,
      closePrice: entity.closePrice,
      stopLoss: entity.stopLoss,
      takeProfit: entity.takeProfit,
      swap: entity.swap,
      commission: entity.commission,
      profit: entity.profit,
      reason: entity.reason.name.toUpperCase(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
    );
  }

  // Convert to Drift companion for database insert
  ClosedPositionsCompanion toCompanion() {
    return ClosedPositionsCompanion.insert(
      id: id,
      userId: userId,
      symbol: symbol,
      openTime: openTime,
      closeTime: closeTime,
      volume: volume,
      side: side,
      openPrice: openPrice,
      closePrice: closePrice,
      stopLoss: Value(stopLoss),
      takeProfit: Value(takeProfit),
      swap: Value(swap),
      commission: Value(commission),
      profit: profit,
      reason: reason,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: Value(isSynced),
    );
  }
}
```

### Pattern 5: Analytics and Recommendation Models

```dart
@freezed
abstract class TradeAnalytics with _$TradeAnalytics {
  const TradeAnalytics._();

  const factory TradeAnalytics({
    required int totalTrades,
    required int openPositions,
    required double winRate,
    required double totalProfitLoss,
    required double averageProfit,
    required double largestWin,
    required double largestLoss,
    required double profitFactor,
    double? averageRiskRewardRatio,
    Duration? averageHoldingDuration,
    required double accountBalance,
    required double totalDeposits,
    required double totalWithdrawals,
    // Symbol breakdown
    @Default({}) Map<String, SymbolPerformance> symbolPerformance,
  }) = _TradeAnalytics;

  factory TradeAnalytics.empty() => const TradeAnalytics(
    totalTrades: 0,
    openPositions: 0,
    winRate: 0,
    totalProfitLoss: 0,
    averageProfit: 0,
    largestWin: 0,
    largestLoss: 0,
    profitFactor: 0,
    accountBalance: 0,
    totalDeposits: 0,
    totalWithdrawals: 0,
  );
}

@freezed
abstract class Recommendation with _$Recommendation {
  const factory Recommendation({
    required String title,
    required String description,
    required Severity severity,
  }) = _Recommendation;
}

enum Severity { info, warning, critical }

@freezed
abstract class SymbolPerformance with _$SymbolPerformance {
  const factory SymbolPerformance({
    required String symbol,
    required int tradeCount,
    required double totalProfit,
    required double winRate,
    required double averageProfit,
  }) = _SymbolPerformance;
}
```

---

## Union Types

### What Are Union Types?

Union types allow a class to represent different states with different data. Each state is called a "variant".

### Example: UI State

```dart
@freezed
abstract class UiState<T> with _$UiState<T> {
  const factory UiState.initial() = UiStateInitial;
  const factory UiState.loading() = UiStateLoading;
  const factory UiState.data(T data) = UiStateData;
  const factory UiState.error(String message) = UiStateError;
}

// Usage
UiState<List<ClosedPosition>> state = UiState.initial();

// Pattern matching
state.when(
  initial: () => print('Initial state'),
  loading: () => print('Loading...'),
  data: (positions) => print('Loaded ${positions.length} trades'),
  error: (message) => print('Error: $message'),
);

// Type-safe access
if (state is UiStateData<List<ClosedPosition>>) {
  final positions = (state as UiStateData<List<ClosedPosition>>).data;
  print('First trade: ${positions.first.symbol}');
}
```

### Example: Import State with Progress

```dart
@freezed
abstract class ImportState with _$ImportState {
  const factory ImportState.idle() = ImportIdle;
  const factory ImportState.loading({
    @Default(0) int processed,
    @Default(0) int total,
  }) = ImportLoading;
  const factory ImportState.success({
    required int imported,
    required int skipped,
    required int errors,
  }) = ImportSuccess;
  const factory ImportState.error(String message) = ImportError;
}

// Usage in provider
@riverpod
class ImportNotifier extends _$ImportNotifier {
  @override
  ImportState build() => const ImportState.idle();

  Future<void> importFromCsv(String filePath) async {
    state = const ImportState.loading(processed: 0, total: 0);

    final result = await _importService.import(filePath, onProgress: (p, t) {
      state = ImportState.loading(processed: p, total: t);
    });

    result.fold(
      (failure) => state = ImportState.error(failure.message),
      (importResult) => state = ImportState.success(
        imported: importResult.imported,
        skipped: importResult.skipped,
        errors: importResult.errors,
      ),
    );
  }
}

// Usage in UI
class ImportPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importNotifierProvider);

    return state.when(
      idle: () => const Text('Select a CSV file to import'),
      loading: (processed, total) => Column(
        children: [
          LinearProgressIndicator(value: total > 0 ? processed / total : 0),
          Text('Processing $processed / $total rows'),
        ],
      ),
      success: (imported, skipped, errors) => Text(
        'Imported: $imported, Skipped: $skipped, Errors: $errors',
      ),
      error: (message) => Text('Import failed: $message'),
    );
  }
}
```

### Example: Sync Status State

```dart
@freezed
abstract class SyncStatusState with _$SyncStatusState {
  const factory SyncStatusState.synced() = SyncStatusSynced;
  const factory SyncStatusState.syncing({
    @Default(0) int pushed,
    @Default(0) int total,
  }) = SyncStatusSyncing;
  const factory SyncStatusState.pending({
    required int pendingCount,
  }) = SyncStatusPending;
  const factory SyncStatusState.offline() = SyncStatusOffline;
  const factory SyncStatusState.error(String message) = SyncStatusError;
}
```

---

## Immutable Classes

### What Are Immutable Classes?

Immutable classes cannot be modified after creation. Freezed makes this easy by generating `copyWith` methods.

### Example: Open Position Entity

```dart
@freezed
abstract class OpenPositionEntity with _$OpenPositionEntity {
  const OpenPositionEntity._();

  const factory OpenPositionEntity({
    required String id,
    required String userId,
    required String symbol,
    required DateTime openTime,
    required double volume,
    required TradeSide side,
    required double openPrice,
    double? currentPrice,
    double? stopLoss,
    double? takeProfit,
    @Default(0.0) double swap,
    @Default(0.0) double commission,
    required double profit,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isSynced,
  }) = _OpenPositionEntity;

  // Computed properties
  double get floatingProfit {
    if (currentPrice == null) return 0.0;
    return side.calculateProfit(openPrice, currentPrice!, volume);
  }

  double? get distanceToTp {
    if (takeProfit == null) return null;
    return (takeProfit! - (currentPrice ?? openPrice)).abs();
  }

  double? get distanceToSl {
    if (stopLoss == null) return null;
    return ((currentPrice ?? openPrice) - stopLoss!).abs();
  }

  // Convert to closed position when closing
  ClosedPositionEntity toClosedPosition({
    required double closePrice,
    required DateTime closeTime,
    required CloseReason reason,
  }) {
    final profit = side.calculateProfit(openPrice, closePrice, volume);
    return ClosedPositionEntity(
      id: id,
      userId: userId,
      symbol: symbol,
      openTime: openTime,
      closeTime: closeTime,
      volume: volume,
      side: side,
      openPrice: openPrice,
      closePrice: closePrice,
      stopLoss: stopLoss,
      takeProfit: takeProfit,
      swap: swap,
      commission: commission,
      profit: profit,
      reason: reason,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
```

---

## CopyWith Pattern

### Basic CopyWith

```dart
final position = ClosedPositionEntity(
  id: 'abc-123',
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

// Copy with changes
final updated = position.copyWith(
  profit: 55.0,
  commission: 2.5,
);

// Original unchanged
print(position.profit);     // 50.0
print(position.commission); // 0.0

// New instance with changes
print(updated.profit);      // 55.0
print(updated.commission);  // 2.5
```

### Nested CopyWith

```dart
@freezed
abstract class TradeFilter with _$TradeFilter {
  const factory TradeFilter({
    DateTime? startDate,
    DateTime? endDate,
    @Default([]) List<String> symbols,
    TradeSide? side,
    @Default([]) List<CloseReason> reasons,
  }) = _TradeFilter;
}

final filter = TradeFilter(
  startDate: DateTime(2026, 4, 1),
  symbols: ['EURUSD', 'GBPUSD'],
);

final updated = filter.copyWith(
  symbols: [...filter.symbols, 'USDJPY'],
);

print(filter.symbols);     // [EURUSD, GBPUSD]
print(updated.symbols);    // [EURUSD, GBPUSD, USDJPY]
```

### Conditional CopyWith

```dart
final position = openPosition.copyWith(
  currentPrice: latestPrice,
  profit: openPosition.side.calculateProfit(
    openPosition.openPrice,
    latestPrice,
    openPosition.volume,
  ),
);
```

---

## Migration from Freezed 2.x

### Key Changes

1. **abstract keyword is now required**
   ```dart
   // OLD (2.x)
   @freezed
   class TradeFormState with _$TradeFormState {
     const factory TradeFormState.initial() = TradeFormInitial;
   }

   // NEW (3.x)
   @freezed
   abstract class TradeFormState with _$TradeFormState {
     const factory TradeFormState.initial() = TradeFormInitial;
   }
   ```

2. **Builder pattern changes**
   ```dart
   // OLD (2.x)
   @FreezedUnionValue('') // No longer needed
   const factory TradeFormState.initial() = TradeFormInitial;

   // NEW (3.x)
   const factory TradeFormState.initial() = TradeFormInitial;
   ```

3. **JsonSerializable integration**
   ```dart
   // OLD (2.x)
   @freezed
   abstract class TradeDto with _$TradeDto {
     factory TradeDto.fromJson(Map<String, dynamic> json) =>
         _$TradeDtoFromJson(json);
   }

   // NEW (3.x)
   @freezed
   abstract class TradeDto with _$TradeDto {
     const factory TradeDto({ /* fields */ }) = _TradeDto;

     factory TradeDto.fromJson(Map<String, dynamic> json) =>
         _$TradeDtoFromJson(json);
   }
   ```

### Migration Checklist

- [ ] Add `abstract` keyword to all Freezed classes
- [ ] Remove `@FreezedUnionValue` annotations (if any)
- [ ] Update constructor syntax (if using custom constructors)
- [ ] Regenerate code with `dart run build_runner build --delete-conflicting-outputs`
- [ ] Test all union type variants
- [ ] Verify `copyWith` methods work correctly

---

## Best Practices

### 1. Always Use const Factory Constructors

```dart
// GOOD
const factory TradeFormState.initial() = TradeFormInitial;
const factory TradeFormState.loading() = TradeFormLoading;

// BAD
factory TradeFormState.initial() = TradeFormInitial;
factory TradeFormState.loading() = TradeFormLoading;
```

### 2. Use @Default for Optional Parameters

```dart
// GOOD
const factory ClosedPositionDto({
  required String id,
  @Default(0.0) double swap,
  @Default(0.0) double commission,
  @Default(false) bool isSynced,
}) = _ClosedPositionDto;

// BAD
const factory ClosedPositionDto({
  required String id,
  double swap = 0.0,        // Use @Default instead
  double commission = 0.0,
  bool isSynced = false,
}) = _ClosedPositionDto;
```

### 3. Use Private Constructors for Custom Methods

```dart
@freezed
abstract class ClosedPositionEntity with _$ClosedPositionEntity {
  const ClosedPositionEntity._(); // Private constructor

  const factory ClosedPositionEntity({
    required String id,
    required double profit,
    // ...
  }) = _ClosedPositionEntity;

  // Custom method
  bool get isWin => profit > 0;
  String get formattedProfit => profit >= 0 ? '+${profit.toStringAsFixed(2)}' : profit.toStringAsFixed(2);
}
```

### 4. Use Union Types for State Management

```dart
// GOOD - Union types for UI state
@freezed
abstract class TradeFormState with _$TradeFormState {
  const factory TradeFormState.initial({ /* form fields */ }) = TradeFormInitial;
  const factory TradeFormState.loading() = TradeFormLoading;
  const factory TradeFormState.success(ClosedPositionEntity position) = TradeFormSuccess;
  const factory TradeFormState.error(String message) = TradeFormError;
}

// BAD - Single class with nullable properties
class TradeFormState {
  final bool isLoading;
  final ClosedPositionEntity? position;
  final String? error;
}
```

### 5. Document Union Type Variants

```dart
/// Represents the state of the CSV import operation.
///
/// Variants:
/// - [ImportIdle]: No import in progress
/// - [ImportLoading]: Import is running with progress tracking
/// - [ImportSuccess]: Import completed with summary
/// - [ImportError]: Import failed with error message
@freezed
abstract class ImportState with _$ImportState {
  const factory ImportState.idle() = ImportIdle;
  const factory ImportState.loading({
    @Default(0) int processed,
    @Default(0) int total,
  }) = ImportLoading;
  const factory ImportState.success({
    required int imported,
    required int skipped,
    required int errors,
  }) = ImportSuccess;
  const factory ImportState.error(String message) = ImportError;
}
```

---

## Common Issues & Solutions

### Issue 1: "The class can't be designated as a '@freezed' class"

**Cause**: Missing `abstract` keyword

**Solution**:
```dart
// Add 'abstract' before 'class'
@freezed
abstract class MyState with _$MyState { }
```

### Issue 2: "Type 'X' has no method 'copyWith'"

**Cause**: Code not generated or not imported

**Solution**:
```bash
# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Verify import
import 'package:tradetrackr/data/models/trade_position_dto.dart';
```

### Issue 3: "Invalid constant value"

**Cause**: Using non-const values in const constructor

**Solution**:
```dart
// BAD
const factory TradeFormState({
  required DateTime timestamp, // DateTime is not const
}) = _TradeFormState;

// GOOD
const factory TradeFormState({
  DateTime? timestamp, // Make nullable
}) = _TradeFormState;

// Or remove const
factory TradeFormState({
  required DateTime timestamp,
}) = _TradeFormState;
```

### Issue 4: "Default values not supported for positional parameters"

**Cause**: Using @Default with positional parameters

**Solution**:
```dart
// BAD
const factory TradeFormState(
  [@Default(0) int count,]
) = _TradeFormState;

// GOOD
const factory TradeFormState({
  @Default(0) int count,
}) = _TradeFormState;
```

---

## Advanced Features

### FromJson/ToJson with JsonSerializable (Supabase)

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_serializable/json_serializable.dart';

part 'trade_position_dto.freezed.dart';
part 'trade_position_dto.g.dart';

@freezed
abstract class ClosedPositionDto with _$ClosedPositionDto {
  const ClosedPositionDto._();

  const factory ClosedPositionDto({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String symbol,
    @JsonKey(name: 'open_time') required DateTime openTime,
    @JsonKey(name: 'close_time') required DateTime closeTime,
    required double volume,
    required String side,
    @JsonKey(name: 'open_price') required double openPrice,
    @JsonKey(name: 'close_price') required double closePrice,
    @JsonKey(name: 'stop_loss') double? stopLoss,
    @JsonKey(name: 'take_profit') double? takeProfit,
    @Default(0.0) double swap,
    @Default(0.0) double commission,
    required double profit,
    required String reason,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(name: 'is_synced') @Default(false) bool isSynced,
  }) = _ClosedPositionDto;

  factory ClosedPositionDto.fromJson(Map<String, dynamic> json) =>
      _$ClosedPositionDtoFromJson(json);

  // For Supabase upsert - uses snake_case column names
  Map<String, dynamic> toSupabase() => _$ClosedPositionDtoToJson(this);
}
```

### Union Types with Generics

```dart
@freezed
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T data) = ResultSuccess<T>;
  const factory Result.failure(Failure failure) = ResultFailure<T>;
}

// Usage with trade entities
Future<Result<ClosedPositionEntity>> addTrade(ClosedPositionEntity entity) async {
  try {
    final id = await _database.insert(entity);
    return Result.success(entity.copyWith(id: id));
  } catch (e) {
    return Result.failure(DatabaseFailure(e.toString()));
  }
}

// Handle
final result = await addTrade(position);
result.when(
  success: (data) => print('Trade added: ${data.symbol}'),
  failure: (failure) => print('Error: ${failure.message}'),
);
```

### Finance Record Entity with Freezed

```dart
@freezed
abstract class FinanceRecordEntity with _$FinanceRecordEntity {
  const FinanceRecordEntity._();

  const factory FinanceRecordEntity({
    required String id,
    required String userId,
    required FinanceType type,
    required DateTime time,
    required double amount,
    required String status,
    required String paymentGateway,
    required String details,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isSynced,
  }) = _FinanceRecordEntity;

  bool get isDeposit => type == FinanceType.deposit;
  bool get isWithdrawal => type == FinanceType.withdrawal;

  double get signedAmount => isDeposit ? amount : -amount;
}

enum FinanceType { deposit, withdrawal }
```

---

## Related Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Clean Architecture with Freezed
- [RIVERPOD_GUIDE.md](RIVERPOD_GUIDE.md) - Riverpod 3.x patterns with Freezed
- [CODING_STANDARDS.md](CODING_STANDARDS.md) - File naming and conventions
- [SOLID.md](SOLID.md) - SOLID principles
- [CLAUDE.md](CLAUDE.md) - Project instructions and quick reference
- [PRD.md](PRD.md) - Product requirements document

---

**Last Updated**: 2026-04-11
**Freezed Version**: 3.x (latest stable)
**Critical Requirement**: `abstract` keyword required
