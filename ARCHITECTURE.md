# Clean Architecture Guide - TradeTrackr

**Last Updated**: 2026-04-22
**Project**: TradeTrackr (Flutter Trading Journal App)
**Architecture**: Clean Architecture with SOLID principles and offline-first sync

---

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Layer Structure](#layer-structure)
3. [Dependency Flow](#dependency-flow)
4. [Repository Segregation Pattern](#repository-segregation-pattern)
5. [Sync Engine Architecture](#sync-engine-architecture)
6. [Domain Layer](#domain-layer)
7. [Data Layer](#data-layer)
8. [Presentation Layer](#presentation-layer)
9. [Dependency Injection Setup](#dependency-injection-setup)
10. [Testing Strategy](#testing-strategy)
11. [Best Practices](#best-practices)

---

## Architecture Overview

TradeTrackr follows **Uncle Bob's Clean Architecture** with clear separation of concerns. The architecture is designed to achieve:

- **Independence of Frameworks**: Business rules don't depend on Flutter, Drift, or Supabase
- **Testability**: Business rules can be tested without UI, database, or external services
- **Independence of UI**: The UI can change easily without changing the rest of the system
- **Independence of Database**: Business rules are not bound to SQLite or Supabase
- **Independence of External Agencies**: Business rules don't know anything about the outside world

### Visual Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                        Presentation Layer                         │
│  (Pages, Widgets, Providers, Riverpod State, GoRouter)           │
│                      ↓ depends on ↓                               │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │                      Domain Layer                          │  │
│  │  (Entities, Use Cases, Repository Interfaces, Enums)       │  │
│  │                  ↑ implemented by ↑                         │  │
│  └────────────────────────────────────────────────────────────┘  │
│                      ↓                                            │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │                       Data Layer                           │  │
│  │  (Repository Implementations, Data Sources, DTOs, Sync)    │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Key Principles

1. **Dependency Rule**: Dependencies point inward, never outward
2. **Single Responsibility**: Each module has one reason to change
3. **Interface Segregation**: Small, focused repository interfaces
4. **Dependency Inversion**: Depend on abstractions, not concretions
5. **Offline-First**: Local database (Drift) is primary; Supabase is secondary

---

## Layer Structure

### Directory Structure

```
lib/
├── app/                        # Application shell
│   ├── app.dart                # MaterialApp with GoRouter
│   ├── router.dart             # GoRouter configuration
│   └── theme/                  # Light and dark theme definitions
│
├── core/                       # Application infrastructure
│   ├── constants/              # App-wide constants
│   ├── errors/                 # Failure exception classes (thrown from data sources)
│   ├── extensions/             # Dart extension methods
│   ├── logger/                 # Logger configuration
│   ├── network/                # Connectivity checker
│   ├── sync/                   # Offline-first sync engine
│   └── utils/                  # Utility functions (date parsing, CSV)
│
├── domain/                     # Business logic (no external dependencies)
│   ├── core/                    # Pure domain abstractions (zero external deps)
│   │   ├── result.dart          # Result<T> union type for error handling
│   │   └── usecase.dart         # UseCase<T, P> base class
│   │
│   ├── entities/               # Core business entities
│   │   ├── user.dart
│   │   └── trade_position.dart
│   ├── repositories/           # Repository interfaces (contracts)
│   │   ├── trade_query_repository.dart
│   │   ├── trade_command_repository.dart
│   │   ├── trade_import_repository.dart
│   │   ├── trade_export_repository.dart
│   │   ├── auth_repository.dart
│   │   └── user_profile_repository.dart
│   ├── usecases/               # Business logic operations
│   │   ├── get_trade_analytics.dart
│   │   ├── add_trade.dart
│   │   ├── update_trade.dart
│   │   ├── delete_trade.dart
│   │   ├── import_trades.dart
│   │   ├── export_trades.dart
│   │   ├── get_recommendations.dart
│   │   ├── sign_in.dart
│   │   ├── sign_up.dart
│   │   ├── sign_out.dart
│   │   └── update_profile.dart
│   └── enums/                  # Domain enums
│       ├── trade_side.dart
│       └── close_reason.dart
│
├── data/                       # Data layer (implements domain interfaces)
│   ├── datasources/            # Data sources (local + remote)
│   │   ├── trade_local_data_source.dart    # Drift (SQLite)
│   │   ├── trade_remote_data_source.dart   # Supabase
│   │   ├── auth_remote_data_source.dart    # Supabase Auth
│   │   └── user_remote_data_source.dart    # Supabase
│   ├── models/                 # Data transfer objects (Freezed)
│   │   ├── trade_position_dto.dart
│   │   ├── trade_analytics_dto.dart
│   │   ├── recommendation_dto.dart
│   │   └── user_dto.dart
│   └── repositories/           # Repository implementations
│       ├── trade_query_repository_impl.dart
│       ├── trade_command_repository_impl.dart
│       ├── trade_import_repository_impl.dart
│       ├── trade_export_repository_impl.dart
│       ├── auth_repository_impl.dart
│       └── user_profile_repository_impl.dart
│
├── presentation/               # UI and state management
│   ├── pages/                  # Full screens
│   │   ├── login_page.dart
│   │   ├── register_page.dart
│   │   ├── dashboard_page.dart
│   │   ├── trade_list_page.dart
│   │   ├── trade_detail_page.dart
│   │   ├── add_trade_page.dart
│   │   ├── import_export_page.dart
│   │   ├── recommendations_page.dart
│   │   ├── profile_page.dart
│   │   └── settings_page.dart
│   ├── widgets/                # Reusable UI components
│   │   ├── trade_card.dart
│   │   ├── analytics_chart.dart
│   │   ├── recommendation_card.dart
│   │   └── filter_bar.dart
│   └── providers/              # Riverpod providers
│       ├── auth_provider.dart
│       ├── trade_provider.dart
│       ├── analytics_provider.dart
│       ├── recommendation_provider.dart
│       ├── import_export_provider.dart
│       ├── profile_provider.dart
│       └── theme_provider.dart
│
└── main.dart                   # Entry point
```

---

## Dependency Flow

### Rule: Dependencies Point Inward

```
Presentation ──depends on──> Domain ──implemented by──> Data
```

### Example: Trade Position Feature

```dart
// ========================================
// 1. DOMAIN LAYER (No external dependencies)
// ========================================

// Entity (Business concept)
// lib/domain/entities/trade_position.dart
class ClosedPosition {
  final String id;
  final String userId;
  final String symbol;
  final DateTime openTime;
  final DateTime closeTime;
  final double volume;
  final TradeSide side;
  final double openPrice;
  final double closePrice;
  final double? stopLoss;
  final double? takeProfit;
  final double swap;
  final double commission;
  final double profit;
  final CloseReason reason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const ClosedPosition({
    required this.id,
    required this.userId,
    required this.symbol,
    required this.openTime,
    required this.closeTime,
    required this.volume,
    required this.side,
    required this.openPrice,
    required this.closePrice,
    this.stopLoss,
    this.takeProfit,
    this.swap = 0.0,
    this.commission = 0.0,
    required this.profit,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  // Business logic
  bool get isWin => profit > 0;
  Duration get holdingDuration => closeTime.difference(openTime);
  double get netProfit => profit - swap - commission;
}

// Repository Interface (Contract)
// lib/domain/repositories/trade_command_repository.dart
abstract class TradeCommandRepository {
  Future<Result<ClosedPosition>> addClosedPosition(ClosedPosition position);
  Future<Result<ClosedPosition>> updateClosedPosition(ClosedPosition position);
  Future<Result<void>> deleteClosedPosition(String id);
  Future<Result<OpenPosition>> addOpenPosition(OpenPosition position);
  Future<Result<ClosedPosition>> closePosition({
    required String openPositionId,
    required double closePrice,
    required DateTime closeTime,
    required CloseReason reason,
  });
}

// Use Case (Business operation)
// lib/domain/usecases/add_trade.dart
class AddTradeUseCase extends UseCase<ClosedPosition, AddTradeParams> {
  final TradeCommandRepository _repository;

  AddTradeUseCase(this._repository);

  @override
  Future<Result<ClosedPosition>> call(AddTradeParams params) async {
    final position = params.position;
    
    // Business validation
    if (position.closeTime.isBefore(position.openTime)) {
      return const Result.failure('Close time must be after open time');
    }
    if (position.volume <= 0) {
      return const Result.failure('Volume must be greater than 0');
    }
    return await _repository.addClosedPosition(position);
  }
}

/// Parameters for add trade use case.
class AddTradeParams {
  final ClosedPosition position;
  const AddTradeParams({required this.position});
}

// ========================================
// 2. DATA LAYER (Implements domain interfaces)
// ========================================

// DTO (Data transfer object with Freezed)
// lib/data/models/trade_position_dto.dart
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

  // Convert to domain entity
  ClosedPosition toEntity() {
    return ClosedPosition(
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
      reason: CloseReason.values.firstWhere((r) => r.name.toUpperCase() == reason),
      createdAt: createdAt,
      updatedAt: updatedAt,
      isSynced: isSynced,
    );
  }

  // Convert from domain entity
  factory ClosedPositionDto.fromEntity(ClosedPosition entity) {
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
}

// Repository Implementation (Following DIP)
// lib/data/repositories/trade_command_repository_impl.dart
class TradeCommandRepositoryImpl implements TradeCommandRepository {
  final TradeLocalDataSource _localDataSource;
  final TradeRemoteDataSource? _remoteDataSource;

  TradeCommandRepositoryImpl(
    this._localDataSource, [
    this._remoteDataSource,
  ]);

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
  Future<Result<ClosedPosition>> closePosition({
    required String openPositionId,
    required double closePrice,
    required DateTime closeTime,
    required CloseReason reason,
  }) async {
    try {
      // 1. Fetch open position from Drift
      final openDto = await _localDataSource.getOpenPositionById(openPositionId);
      if (openDto == null) {
        return const Result.failure('Open position not found');
      }

      // 2. Calculate profit based on side
      final open = openDto.toEntity();
      final profit = open.side.calculateProfit(open.openPrice, closePrice, open.volume);

      // 3. Create closed position
      final closed = ClosedPosition(
        id: open.id,
        userId: open.userId,
        symbol: open.symbol,
        openTime: open.openTime,
        closeTime: closeTime,
        volume: open.volume,
        side: open.side,
        openPrice: open.openPrice,
        closePrice: closePrice,
        stopLoss: open.stopLoss,
        takeProfit: open.takeProfit,
        swap: open.swap,
        commission: open.commission,
        profit: profit,
        reason: reason,
        createdAt: open.createdAt,
        updatedAt: DateTime.now(),
        isSynced: false,
      );

      // 4. Write to local database
      final closedDto = ClosedPositionDto.fromEntity(closed);
      await _localDataSource.insertClosedPosition(closedDto);
      await _localDataSource.deleteOpenPosition(openPositionId);

      return Result.success(closed);
    } catch (e) {
      return Result.failure('Failed to close position: $e');
    }
  }
}

// ========================================
// 3. PRESENTATION LAYER (Depends on domain)
// ========================================

// Provider (State management)
// lib/presentation/providers/trade_provider.dart
@riverpod
class TradeFormNotifier extends _$TradeFormNotifier {
  @override
  TradeFormState build() {
    return TradeFormState.initial();
  }

  Future<void> submit() async {
    state = const TradeFormState.loading();

    final useCase = ref.read(addTradeUseCaseProvider);
    final entity = _mapStateToEntity(state);

    final result = await useCase.execute(entity);

    result.fold(
      (failure) => state = TradeFormState.error(failure.message),
      (success) => state = TradeFormState.success(success),
    );
  }
}
```

---

## Repository Segregation Pattern

**Principle**: Interface Segregation Principle (ISP) - Clients should not depend on interfaces they don't use.

### Traditional Approach (Not Used)

```dart
// BAD - Fat interface with all operations
abstract class TradeRepository {
  // Read
  Future<List<ClosedPosition>> getClosedPositions();
  Future<OpenPosition?> getOpenPositionById(String id);
  // Write
  Future<void> addClosedPosition(ClosedPosition position);
  Future<void> updateClosedPosition(ClosedPosition position);
  Future<void> deleteClosedPosition(String id);
  // Import
  Future<ImportResult> importFromCsv(String csvContent);
  // Export
  Future<String> exportToCsv(List<ClosedPosition> positions);
  // Analytics
  Future<TradeAnalytics> getAnalytics();
  // Auth
  Future<User?> signIn(String email, String password);
  Future<User?> signUp(String email, String password);
}

// Problem: A simple form page must depend on analytics, import, export, and auth methods
```

### Segregated Approach (Used in TradeTrackr)

```dart
// GOOD - Small, focused interfaces organized by operation type

// lib/domain/repositories/trade_query_repository.dart
abstract class TradeQueryRepository {
  Future<Result<List<ClosedPosition>>> getClosedPositions({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
    TradeSide? side,
    List<CloseReason>? reasons,
  });
  Future<Result<ClosedPosition?>> getClosedPositionById(String id);
  Future<Result<List<OpenPosition>>> getOpenPositions();
  Future<Result<OpenPosition?>> getOpenPositionById(String id);
  Future<Result<TradeAnalytics>> getAnalytics(TradeFilter filter);
}

// lib/domain/repositories/trade_command_repository.dart
abstract class TradeCommandRepository {
  Future<Result<ClosedPosition>> addClosedPosition(ClosedPosition position);
  Future<Result<ClosedPosition>> updateClosedPosition(ClosedPosition position);
  Future<Result<void>> deleteClosedPosition(String id);
  Future<Result<OpenPosition>> addOpenPosition(OpenPosition position);
  Future<Result<OpenPosition>> updateOpenPosition(OpenPosition position);
  Future<Result<void>> deleteOpenPosition(String id);
  Future<Result<ClosedPosition>> closePosition({
    required String openPositionId,
    required double closePrice,
    required DateTime closeTime,
    required CloseReason reason,
  });
}

// lib/domain/repositories/trade_import_repository.dart
abstract class TradeImportRepository {
  Future<Result<ImportResult>> importFromCsv(String filePath);
}

// lib/domain/repositories/trade_export_repository.dart
abstract class TradeExportRepository {
  Future<Result<String>> exportClosedPositionsToCsv({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
  });
  Future<Result<String>> exportOpenPositionsToCsv();
  Future<Result<String>> exportFinanceRecordsToCsv();
}

// lib/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Result<User>> signIn(String email, String password);
  Future<Result<User>> signUp(String email, String password);
  Future<Result<void>> signOut();
  Future<Result<void>> resetPassword(String email);
  Stream<User?> get authStateChanges;
}

// lib/domain/repositories/user_profile_repository.dart
abstract class UserProfileRepository {
  Future<Result<User>> getProfile();
  Future<Result<User>> updateProfile({String? displayName});
  Future<Result<void>> changePassword(
    String currentPassword,
    String newPassword,
  );
  Future<Result<void>> deleteAccount();
}
```

### Benefits

1. **Single Responsibility**: Each interface has one reason to change
2. **Flexible Dependencies**: Providers only depend on methods they use
3. **Easier Testing**: Smaller interfaces are easier to mock
4. **Clear Intent**: Interface name describes its purpose

### Usage in Providers

```dart
// A provider that only needs to read trades
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  @override
  Future<List<ClosedPosition>> build() async {
    // Only depends on query repository
    final queryRepo = ref.read(tradeQueryRepositoryProvider);
    final result = await queryRepo.getClosedPositions();
    return result.when(
      failure: (error) => throw Exception(error),
      success: (positions) => positions,
    );
  }
}

// A provider that only needs to write trades
@riverpod
class TradeFormNotifier extends _$TradeFormNotifier {
  @override
  TradeFormState build() {
    return TradeFormState.initial();
  }

  Future<void> submit() async {
    // Only depends on command repository
    final commandRepo = ref.read(tradeCommandRepositoryProvider);
    final result = await commandRepo.addClosedPosition(entity);
    // Handle result...
  }
}
```

---

## Sync Engine Architecture

TradeTrackr is **offline-first**. The sync engine bridges the local Drift database with Supabase.

### Architecture Diagram

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│ Presentation│──────>│   Domain    │<──────│    Data     │
│ (Riverpod)  │       │ (Use Cases) │       │ (Drift +    │
│             │       │             │       │  Supabase)  │
└─────────────┘       └─────────────┘       └──────┬──────┘
                                                     │
                                              ┌──────▼──────┐
                                              │ Sync Engine  │
                                              │ (background) │
                                              └──────┬──────┘
                                                     │
                                              ┌──────▼──────┐
                                              │  Supabase   │
                                              │ (PostgreSQL)│
                                              └─────────────┘
```

### Sync Strategy

| Aspect | Strategy |
|--------|----------|
| Local Store | Drift (SQLite) is the primary data source |
| Remote Store | Supabase PostgreSQL is the secondary/truth source when online |
| Writes | All writes go to Drift first, then sync to Supabase when connectivity is available |
| Reads | Always read from Drift for instant response |
| Conflict Resolution | Last-write-wins based on `updated_at` timestamp |
| Sync Queue | Unsynced records (`is_synced = false`) are pushed to Supabase on connectivity restore |
| Initial Sync | On first login, pull all user's trade data from Supabase into Drift |

### Sync Engine Implementation

```dart
// lib/core/sync/sync_engine.dart
class SyncEngine {
  final TradeLocalDataSource _localSource;
  final TradeRemoteDataSource _remoteSource;
  final ConnectivityChecker _connectivity;
  final Logger _logger;

  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;
  final _syncStatusController = StreamController<SyncStatus>.broadcast();

  /// Push all unsynced records to Supabase
  Future<void> pushUnsyncedRecords() async {
    if (!await _connectivity.isOnline) {
      _logger.i('Offline - skipping push');
      return;
    }

    _syncStatusController.add(SyncStatus.pushing);

    try {
      // Push closed positions
      final unsyncedClosed = await _localSource.getUnsyncedClosedPositions();
      for (final dto in unsyncedClosed) {
        await _remoteSource.upsertClosedPosition(dto);
        await _localSource.markAsSynced(dto.id, 'closed_positions');
      }

      // Push open positions
      final unsyncedOpen = await _localSource.getUnsyncedOpenPositions();
      for (final dto in unsyncedOpen) {
        await _remoteSource.upsertOpenPosition(dto);
        await _localSource.markAsSynced(dto.id, 'open_positions');
      }

      // Push finance records
      final unsyncedFinance = await _localSource.getUnsyncedFinanceRecords();
      for (final dto in unsyncedFinance) {
        await _remoteSource.upsertFinanceRecord(dto);
        await _localSource.markAsSynced(dto.id, 'finance_records');
      }

      _syncStatusController.add(SyncStatus.synced);
    } catch (e) {
      _logger.e('Push failed: $e');
      _syncStatusController.add(SyncStatus.error(e.toString()));
    }
  }

  /// Pull all user data from Supabase into Drift
  Future<void> pullRemoteChanges(String userId) async {
    if (!await _connectivity.isOnline) return;

    _syncStatusController.add(SyncStatus.pulling);

    try {
      final remoteClosed = await _remoteSource.getClosedPositions(userId);
      final remoteOpen = await _remoteSource.getOpenPositions(userId);
      final remoteFinance = await _remoteSource.getFinanceRecords(userId);

      await _localSource.mergeClosedPositions(remoteClosed);
      await _localSource.mergeOpenPositions(remoteOpen);
      await _localSource.mergeFinanceRecords(remoteFinance);

      _syncStatusController.add(SyncStatus.synced);
    } catch (e) {
      _logger.e('Pull failed: $e');
      _syncStatusController.add(SyncStatus.error(e.toString()));
    }
  }
}

enum SyncStatus {
  synced,
  pushing,
  pulling,
  pending,
  offline,
  error,
}
```

### Connectivity Monitoring

```dart
// lib/core/network/connectivity_checker.dart
class ConnectivityChecker {
  final Connectivity _connectivity;

  Stream<bool> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged.map(
        (results) => results.isNotEmpty,
      );

  Future<bool> get isOnline async {
    final results = await _connectivity.checkConnectivity();
    return results.isNotEmpty;
  }
}
```

### Sync Flow

1. **App Launch**: Check connectivity → if online, push unsynced → pull remote changes
2. **Write Operation**: Write to Drift with `is_synced = false` → attempt push if online
3. **Connectivity Restore**: Push all `is_synced = false` records to Supabase
4. **First Login**: Full pull from Supabase to seed local Drift database
5. **Conflict**: Compare `updated_at` timestamps → last-write-wins

---

## Domain Layer

### Purpose: Encapsulate business logic without external dependencies

#### Entities

```dart
// lib/domain/entities/trade_position.dart

/// Represents a closed trade position with all entry/exit details.
class ClosedPosition {
  final String id;
  final String userId;
  final String symbol;       // e.g., NDX100, EURUSD, BTCUSD
  final DateTime openTime;
  final DateTime closeTime;
  final double volume;       // Position size / lot size
  final TradeSide side;      // BUY or SELL
  final double openPrice;
  final double closePrice;
  final double? stopLoss;
  final double? takeProfit;
  final double swap;
  final double commission;
  final double profit;       // Auto-calculated, user may override
  final CloseReason reason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const ClosedPosition({ /* ... */ });

  bool get isWin => profit > 0;
  Duration get holdingDuration => closeTime.difference(openTime);
  double get netProfit => profit - swap - commission;

  double get pips {
    return switch (side) {
      TradeSide.buy => closePrice - openPrice,
      TradeSide.sell => openPrice - closePrice,
    };
  }

  double? get riskRewardRatio {
    if (stopLoss == null || takeProfit == null) return null;
    final risk = (openPrice - stopLoss!).abs();
    final reward = (takeProfit! - openPrice).abs();
    return risk == 0 ? null : reward / risk;
  }

  ClosedPosition copyWith({ /* ... */ });
}

/// Represents an open (active) trade position.
class OpenPosition {
  final String id;
  final String userId;
  final String symbol;
  final DateTime openTime;
  final double volume;
  final TradeSide side;
  final double openPrice;
  final double? currentPrice;
  final double? stopLoss;
  final double? takeProfit;
  final double swap;
  final double commission;
  final double profit;       // Floating P/L based on current price
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  const OpenPosition({ /* ... */ });

  double get floatingProfit {
    if (currentPrice == null) return 0.0;
    return side.calculateProfit(openPrice, currentPrice!, volume);
  }
}
```

#### Enums

```dart
// lib/domain/enums/trade_side.dart
enum TradeSide {
  buy(name: 'BUY'),
  sell(name: 'SELL');

  final String name;

  const TradeSide({required this.name});

  /// Calculate profit for this trade side.
  double calculateProfit(double openPrice, double exitPrice, double volume) {
    return switch (this) {
      TradeSide.buy => (exitPrice - openPrice) * volume,
      TradeSide.sell => (openPrice - exitPrice) * volume,
    };
  }
}

// lib/domain/enums/close_reason.dart
enum CloseReason {
  tp(name: 'TP'),       // Take Profit hit
  sl(name: 'SL'),       // Stop Loss hit
  user(name: 'User'),   // User manually closed
  manual(name: 'Manual');

  final String name;
  const CloseReason({required this.name});
}
```

#### Use Cases

```dart
// lib/domain/usecases/add_trade.dart
class AddTradeUseCase {
  final TradeCommandRepository _repository;

  AddTradeUseCase(this._repository);

  Future<Either<Failure, ClosedPosition>> execute(ClosedPosition position) async {
    if (position.closeTime.isBefore(position.openTime)) {
      return const Left(ValidationFailure('Close time must be after open time'));
    }
    if (position.volume <= 0) {
      return const Left(ValidationFailure('Volume must be greater than 0'));
    }
    return await _repository.addClosedPosition(position);
  }
}

// lib/domain/usecases/get_trade_analytics.dart
class GetTradeAnalyticsUseCase extends UseCase<TradeAnalytics, GetAnalyticsParams> {
  final TradeQueryRepository _repository;

  GetTradeAnalyticsUseCase(this._repository);

  @override
  Future<Result<TradeAnalytics>> call(GetAnalyticsParams params) async {
    return await _repository.getAnalytics(params.filter);
  }
}

// lib/domain/usecases/import_trades.dart
class ImportTradesUseCase extends UseCase<ImportResult, ImportTradesParams> {
  final TradeImportRepository _repository;

  ImportTradesUseCase(this._repository);

  @override
  Future<Result<ImportResult>> call(ImportTradesParams params) async {
    if (params.filePath.isEmpty) {
      return const Result.failure('File path cannot be empty');
    }
    return await _repository.importFromCsv(params.filePath);
  }
}

// lib/domain/usecases/get_recommendations.dart
class GetRecommendationsUseCase extends UseCase<List<Recommendation>, GetRecommendationsParams> {
  final TradeQueryRepository _repository;

  GetRecommendationsUseCase(this._repository);

  @override
  Future<Result<List<Recommendation>>> call(GetRecommendationsParams params) async {
    final analyticsResult = await _repository.getAnalytics(params.filter);
    
    return analyticsResult.when(
      failure: (error) => Result.failure(error),
      success: (analytics) {
        final recommendations = _generateRecommendations(analytics);
        return Result.success(recommendations);
      },
    );
  }

  List<Recommendation> _generateRecommendations(TradeAnalytics analytics) {
    final recommendations = <Recommendation>[];

    // Best performing symbol (minimum 5 trades)
    if (analytics.bestSymbol != null) {
      recommendations.add(Recommendation(
        title: 'Best Performing Symbol',
        description: '${analytics.bestSymbol!.symbol} has the highest total net profit',
        severity: Severity.info,
      ));
    }

    // Consecutive loss alert
    if (analytics.consecutiveLosses >= 3) {
      recommendations.add(Recommendation(
        title: 'Consecutive Losses',
        description: 'You are on a streak of ${analytics.consecutiveLosses} consecutive losses',
        severity: Severity.critical,
      ));
    }

    return recommendations;
  }
}
```

---

## Data Layer

### Purpose: Implement domain interfaces and manage data sources

### Drift Database Setup

```dart
// lib/data/datasources/trade_local_data_source.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'trade_local_data_source.g.dart';

class ClosedPositions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get symbol => text()();
  DateTimeColumn get openTime => dateTime()();
  DateTimeColumn get closeTime => dateTime()();
  RealColumn get volume => real()();
  TextColumn get side => text()();  // 'BUY' or 'SELL'
  RealColumn get openPrice => real()();
  RealColumn get closePrice => real()();
  RealColumn get stopLoss => real().nullable()();
  RealColumn get takeProfit => real().nullable()();
  RealColumn get swap => real().withDefault(const Constant(0.0))();
  RealColumn get commission => real().withDefault(const Constant(0.0))();
  RealColumn get profit => real()();
  TextColumn get reason => text()(); // 'TP', 'SL', 'User', 'Manual'
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class OpenPositions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get symbol => text()();
  DateTimeColumn get openTime => dateTime()();
  RealColumn get volume => real()();
  TextColumn get side => text()();
  RealColumn get openPrice => real()();
  RealColumn get currentPrice => real().nullable()();
  RealColumn get stopLoss => real().nullable()();
  RealColumn get takeProfit => real().nullable()();
  RealColumn get swap => real().withDefault(const Constant(0.0))();
  RealColumn get commission => real().withDefault(const Constant(0.0))();
  RealColumn get profit => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class FinanceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()();  // 'Deposit' or 'Withdrawal'
  DateTimeColumn get time => dateTime()();
  RealColumn get amount => real()();
  TextColumn get status => text()();
  TextColumn get paymentGateway => text()();
  TextColumn get details => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [ClosedPositions, OpenPositions, FinanceRecords])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  // Query methods for data source
  Future<List<ClosedPositionData>> getAllClosedPositions(String userId) {
    return (select(closedPositions)
          ..where((t) => t.userId.equals(userId)))
        .get();
  }

  Future<void> insertClosedPosition(ClosedPositionsCompanion companion) {
    return into(closedPositions).insert(companion);
  }

  Future<List<ClosedPositionData>> getUnsyncedClosedPositions(String userId) {
    return (select(closedPositions)
          ..where((t) => t.userId.equals(userId) & t.isSynced.equals(false)))
        .get();
  }
}
```

### Supabase Remote Data Source

```dart
// lib/data/datasources/trade_remote_data_source.dart
class TradeRemoteDataSource {
  final SupabaseClient _client;

  Future<List<Map<String, dynamic>>> getClosedPositions(String userId) async {
    final response = await _client
        .from('closed_positions')
        .select()
        .eq('user_id', userId)
        .order('close_time', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> upsertClosedPosition(Map<String, dynamic> data) async {
    await _client.from('closed_positions').upsert(data, onConflict: 'id');
  }

  Future<void> upsertOpenPosition(Map<String, dynamic> data) async {
    await _client.from('open_positions').upsert(data, onConflict: 'id');
  }
}
```

### Repository Implementation (Following DIP)

```dart
// lib/data/repositories/trade_query_repository_impl.dart
class TradeQueryRepositoryImpl implements TradeQueryRepository {
  final TradeLocalDataSource _localDataSource;

  TradeQueryRepositoryImpl(this._localDataSource);

  @override
  Future<Result<List<ClosedPosition>>> getClosedPositions({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
    TradeSide? side,
    List<CloseReason>? reasons,
  }) async {
    try {
      final positions = await _localDataSource.queryClosedPositions(
        startDate: startDate,
        endDate: endDate,
        symbols: symbols,
        side: side,
        reasons: reasons,
      );
      return Result.success(positions.map((dto) => dto.toEntity()).toList());
    } catch (e) {
      return Result.failure('Failed to get closed positions: $e');
    }
  }

  @override
  Future<Result<TradeAnalytics>> getAnalytics(TradeFilter filter) async {
    try {
      final positions = await _localDataSource.queryClosedPositions(
        startDate: filter.startDate,
        endDate: filter.endDate,
        symbols: filter.symbols,
        side: filter.side,
        reasons: filter.reasons,
      );

      final entities = positions.map((dto) => dto.toEntity()).toList();
      final analytics = _computeAnalytics(entities);
      return Result.success(analytics);
    } catch (e) {
      return Result.failure('Failed to get analytics: $e');
    }
  }

  TradeAnalytics _computeAnalytics(List<ClosedPosition> positions) {
    if (positions.isEmpty) return TradeAnalytics.empty();

    final wins = positions.where((p) => p.isWin).toList();
    final losses = positions.where((p) => !p.isWin).toList();
    final totalProfit = positions.fold(0.0, (sum, p) => sum + p.netProfit);
    final grossProfit = wins.fold(0.0, (sum, p) => sum + p.netProfit);
    final grossLoss = losses.fold(0.0, (sum, p) => sum + p.netProfit.abs());

    return TradeAnalytics(
      totalTrades: positions.length,
      winRate: (wins.length / positions.length * 100),
      totalProfitLoss: totalProfit,
      averageProfit: totalProfit / positions.length,
      largestWin: wins.map((p) => p.netProfit).fold(0.0, max),
      largestLoss: losses.map((p) => p.netProfit).fold(0.0, min),
      profitFactor: grossLoss == 0 ? double.infinity : grossProfit / grossLoss,
    );
  }
}
```

---

## Presentation Layer

### Purpose: UI and state management

### Provider Organization

```
lib/presentation/providers/
├── auth_provider.dart               # Auth state, sign in/out
├── trade_provider.dart              # Trade CRUD state
├── analytics_provider.dart          # Dashboard analytics
├── recommendation_provider.dart     # Recommendation engine
├── import_export_provider.dart      # CSV import/export
├── profile_provider.dart            # User profile CRUD
└── theme_provider.dart              # Light/dark mode toggle
```

### Provider Pattern with Riverpod

```dart
// lib/presentation/providers/trade_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trade_provider.g.dart';

@riverpod
class TradeFormNotifier extends _$TradeFormNotifier {
  @override
  TradeFormState build() {
    return TradeFormState.initial();
  }

  void setSymbol(String value) {
    state = state.copyWith(symbol: value);
  }

  void setSide(TradeSide value) {
    state = state.copyWith(side: value);
  }

  void setVolume(double value) {
    state = state.copyWith(volume: value);
  }

  Future<void> submit() async {
    state = const TradeFormState.loading();

    final useCase = ref.read(addTradeUseCaseProvider);
    final entity = _mapStateToEntity(state);

    final result = await useCase.call(AddTradeParams(position: entity));

    result.when(
      failure: (error) => state = TradeFormState.error(error),
      success: (success) => state = TradeFormState.success(success),
    );
  }
}
```

### State Pattern with Freezed

```dart
// lib/presentation/providers/trade_provider.dart (state classes)
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
  const factory TradeFormState.success(ClosedPosition position) = TradeFormSuccess;
  const factory TradeFormState.error(String message) = TradeFormError;
}
```

### GoRouter Routing Configuration

```dart
// lib/app/router.dart
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/trades/closed',
          builder: (context, state) => const TradeListPage(type: PositionType.closed),
        ),
        GoRoute(
          path: '/trades/open',
          builder: (context, state) => const TradeListPage(type: PositionType.open),
        ),
        GoRoute(
          path: '/trades/add',
          builder: (context, state) => const AddTradePage(),
        ),
        GoRoute(
          path: '/trades/:id',
          builder: (context, state) => TradeDetailPage(
            tradeId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/import-export',
          builder: (context, state) => const ImportExportPage(),
        ),
        GoRoute(
          path: '/recommendations',
          builder: (context, state) => const RecommendationsPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfilePage(),
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    // Auth guard - redirect unauthenticated users to login
    final isLoggedIn = /* check auth state */;
    final isLoggingIn = state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!isLoggedIn && !isLoggingIn) return '/login';
    if (isLoggedIn && isLoggingIn) return '/';
    return null;
  },
);
```

### Screen Implementation

```dart
// lib/presentation/pages/add_trade_page.dart
class AddTradePage extends ConsumerStatefulWidget {
  const AddTradePage({super.key});

  @override
  ConsumerState<AddTradePage> createState() => _AddTradePageState();
}

class _AddTradePageState extends ConsumerState<AddTradePage> {
  @override
  Widget build(BuildContext context) {
    ref.listen<TradeFormState>(
      tradeFormNotifierProvider,
      (previous, next) {
        next.maybeWhen(
          success: (position) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Trade saved successfully')),
            );
            context.pop();
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
          orElse: () {},
        );
      },
    );

    final state = ref.watch(tradeFormNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Trade')),
      body: state.when(
        initial: (form) => _buildForm(form),
        loading: () => const Center(child: CircularProgressIndicator()),
        success: (_) => const Center(child: Text('Success')),
        error: (message) => _buildFormWithError(message),
      ),
    );
  }

  Widget _buildForm(TradeFormInitial form) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Symbol input
          // Side selector (BUY/SELL chips)
          // Volume input
          // Open price input
          // Stop loss input
          // Take profit input
          // Open time picker
          // Submit button
        ],
      ),
    );
  }
}
```

---

## Dependency Injection Setup

### Provider Chain

```dart
// lib/presentation/providers/ (dependency providers)

// 1. Data source providers
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}

@riverpod
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

@riverpod
TradeLocalDataSource tradeLocalDataSource(TradeLocalDataSourceRef ref) {
  return TradeLocalDataSourceImpl(ref.read(appDatabaseProvider));
}

@riverpod
TradeRemoteDataSource tradeRemoteDataSource(TradeRemoteDataSourceRef ref) {
  return TradeRemoteDataSourceImpl(ref.read(supabaseClientProvider));
}

// 2. Repository providers
@riverpod
TradeQueryRepository tradeQueryRepository(TradeQueryRepositoryRef ref) {
  return TradeQueryRepositoryImpl(ref.read(tradeLocalDataSourceProvider));
}

@riverpod
TradeCommandRepository tradeCommandRepository(TradeCommandRepositoryRef ref) {
  return TradeCommandRepositoryImpl(
    ref.read(tradeLocalDataSourceProvider),
    ref.read(tradeRemoteDataSourceProvider),
  );
}

@riverpod
TradeImportRepository tradeImportRepository(TradeImportRepositoryRef ref) {
  return TradeImportRepositoryImpl(ref.read(tradeLocalDataSourceProvider));
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.read(supabaseClientProvider));
}

// 3. Use case providers
@riverpod
AddTradeUseCase addTradeUseCase(AddTradeUseCaseRef ref) {
  return AddTradeUseCase(ref.read(tradeCommandRepositoryProvider));
}

@riverpod
GetTradeAnalyticsUseCase getTradeAnalyticsUseCase(GetTradeAnalyticsUseCaseRef ref) {
  return GetTradeAnalyticsUseCase(ref.read(tradeQueryRepositoryProvider));
}

@riverpod
ImportTradesUseCase importTradesUseCase(ImportTradesUseCaseRef ref) {
  return ImportTradesUseCase(ref.read(tradeImportRepositoryProvider));
}

// 4. Feature providers (in their respective files)
// trade_provider.dart, analytics_provider.dart, etc.
```

### Main.dart Setup

```dart
// lib/main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://bheohnfxjnwdkqvftbnc.supabase.co',
    anonKey: 'YOUR_ANON_KEY',
  );

  runApp(
    const ProviderScope(
      child: TradeTrackrApp(),
    ),
  );
}

class TradeTrackrApp extends ConsumerWidget {
  const TradeTrackrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'TradeTrackr',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
```

---

## Testing Strategy

### Unit Tests (Domain Layer)

```dart
// test/domain/usecases/add_trade_usecase_test.dart
void main() {
  late AddTradeUseCase useCase;
  late MockTradeCommandRepository mockRepository;

  setUp(() {
    mockRepository = MockTradeCommandRepository();
    useCase = AddTradeUseCase(mockRepository);
  });

  test('should return validation failure when close time is before open time',
      () async {
    // Arrange
    final position = ClosedPosition(
      id: 'test-id',
      userId: 'user-1',
      symbol: 'EURUSD',
      openTime: DateTime(2026, 4, 11, 10, 0),
      closeTime: DateTime(2026, 4, 11, 9, 0), // Before open time
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
    final result = await useCase.call(AddTradeParams(position: position));

    // Assert
    expect(result.isFailure, true);
    expect(result.error, 'Close time must be after open time');
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
        .thenAnswer((_) async => Result.success(position));

    // Act
    final result = await useCase.call(AddTradeParams(position: position));

    // Assert
    expect(result.isSuccess, true);
    result.when(
      failure: (error) => fail('Should return success'),
      success: (r) {
        expect(r.id, 'test-id');
        expect(r.symbol, 'EURUSD');
      },
    );
    verify(mockRepository.addClosedPosition(position)).called(1);
  });
}
```

### Widget Tests (Presentation Layer)

```dart
// test/presentation/pages/add_trade_page_test.dart
void main() {
  testWidgets('should display all trade form fields', (tester) async {
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

    // Tap submit button
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
void main() {
  late AppDatabase database;

  setUp(() {
    // Use in-memory database for tests
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('should insert and retrieve closed position', () async {
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
    expect(results.first.side, 'BUY');
  });
}
```

---

## Best Practices

### 1. Always Depend on Abstractions
```dart
// GOOD
class AddTradeUseCase {
  final TradeCommandRepository _repository;
  AddTradeUseCase(this._repository);
}

// BAD
class AddTradeUseCase {
  final TradeCommandRepositoryImpl _repository;
  AddTradeUseCase(this._repository);
}
```

### 2. Keep Use Cases Atomic
```dart
// GOOD - Single responsibility
class AddTradeUseCase { }
class UpdateTradeUseCase { }
class DeleteTradeUseCase { }
class GetTradeAnalyticsUseCase { }
class ImportTradesUseCase { }
class ExportTradesUseCase { }
class GetRecommendationsUseCase { }

// BAD - Too many responsibilities
class TradeManagementUseCase {
  void add() { }
  void update() { }
  void delete() { }
  void import() { }
  void export() { }
  void getAnalytics() { }
}
```

### 3. Use Barrel Exports
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

### 4. Initialize in build(), Not Constructor
```dart
// GOOD
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  @override
  Future<List<ClosedPosition>> build() async {
    final useCase = ref.read(getTradeAnalyticsUseCaseProvider);
    return await useCase.execute();
  }
}

// BAD
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  TradeListNotifier() {
    // Providers not available yet!
    loadTrades();
  }

  @override
  Future<List<ClosedPosition>> build() => Future.value([]);
}
```

### 5. Offline-First Mindset
```dart
// GOOD - Always write to Drift first
Future<Either<Failure, ClosedPosition>> addClosedPosition(
  ClosedPosition position,
) async {
  // 1. Write to local Drift database immediately
  await _localDataSource.insertClosedPosition(dto);

  // 2. Sync engine will handle Supabase push in background
  return Right(position);
}

// BAD - Waiting for remote before confirming
Future<Either<Failure, ClosedPosition>> addClosedPosition(
  ClosedPosition position,
) async {
  // This blocks on network availability!
  await _remoteDataSource.upsertClosedPosition(dto.toJson());
  await _localDataSource.insertClosedPosition(dto);
  return Right(position);
}
```

---

## Related Documentation

- [CODING_STANDARDS.md](CODING_STANDARDS.md) - File naming and conventions
- [RIVERPOD_GUIDE.md](RIVERPOD_GUIDE.md) - Riverpod 3.x patterns
- [FREEZED_GUIDE.md](FREEZED_GUIDE.md) - Freezed 3.x guide
- [SOLID.md](SOLID.md) - SOLID principles with examples
- [CLAUDE.md](CLAUDE.md) - Project instructions and quick reference
- [PRD.md](PRD.md) - Product requirements document

---

**Last Updated**: 2026-04-11
**Architecture Version**: 1.0 (Clean Architecture with offline-first sync)
