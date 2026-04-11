# SOLID Principles - TradeTrackr

**Last Updated**: 2026-04-11
**Project**: TradeTrackr (Flutter Trading Journal App)

---

## Table of Contents
1. [Single Responsibility Principle (SRP)](#single-responsibility-principle-srp)
2. [Open/Closed Principle (OCP)](#openclosed-principle-ocp)
3. [Liskov Substitution Principle (LSP)](#liskov-substitution-principle-lsp)
4. [Interface Segregation Principle (ISP)](#interface-segregation-principle-isp)
5. [Dependency Inversion Principle (DIP)](#dependency-inversion-principle-dip)
6. [SOLID Benefits](#solid-benefits)
7. [SOLID Implementation Metrics](#solid-implementation-metrics)
8. [Before/After Code Examples](#beforeafter-code-examples)

---

## Single Responsibility Principle (SRP)

> "There should never be more than one reason for a class to change."

Every class, function, and widget should have one, and only one, reason to change. A component should be responsible for a single part of the functionality.

### Key Rules

1. **Classes should be small** - A class' size is measured by its responsibility.

2. **Functions do one thing** - Functions should perform a single action.

   ```dart
   // BAD - Multiple responsibilities
   void processWinningTrades(List<ClosedPosition> trades) {
     final winners = trades.where((t) => t.isWin).toList();
     for (var trade in winners) {
       sendNotification(trade);
     }
   }

   // GOOD - Single responsibility per function
   void notifyWinningTrades(List<ClosedPosition> trades) {
     trades.where(isWinningTrade).forEach(sendTradeNotification);
   }

   bool isWinningTrade(ClosedPosition trade) {
     return trade.profit > 0;
   }
   ```

3. **Use cases should be atomic** - Each use case performs ONE business operation.
   - `AddTradeUseCase` - Adds a single trade position
   - `GetTradeAnalyticsUseCase` - Computes analytics from trade history
   - `ImportTradesUseCase` - Parses CSV and imports trades
   - `ExportTradesUseCase` - Exports trades to CSV
   - `GetRecommendationsUseCase` - Generates trading recommendations
   - `SignInUseCase` / `SignOutUseCase` - Auth operations only

### Real Example from TradeTrackr

```dart
// lib/domain/usecases/add_trade.dart
class AddTradeUseCase {
  final TradeCommandRepository _repository;

  AddTradeUseCase(this._repository);

  /// Executes a single operation: adding a closed trade position
  Future<Either<Failure, ClosedPosition>> execute(
    ClosedPosition position,
  ) async {
    // Business validation
    if (position.closeTime.isBefore(position.openTime)) {
      return const Left(ValidationFailure('Close time must be after open time'));
    }
    if (position.volume <= 0) {
      return const Left(ValidationFailure('Volume must be greater than 0'));
    }
    return await _repository.addClosedPosition(position);
  }
}

// Each use case has ONE responsibility:
// - AddTradeUseCase: Add only
// - UpdateTradeUseCase: Update only
// - DeleteTradeUseCase: Delete only
// - GetTradeAnalyticsUseCase: Compute analytics only
// - ImportTradesUseCase: Import from CSV only
// - ExportTradesUseCase: Export to CSV only
// - GetRecommendationsUseCase: Generate recommendations only
```

### Sync Engine - Single Responsibility

```dart
// lib/core/sync/sync_engine.dart
/// The sync engine has ONE responsibility: keeping local and remote in sync.
/// It does NOT contain business logic or UI concerns.
class SyncEngine {
  final TradeLocalDataSource _localSource;
  final TradeRemoteDataSource _remoteSource;
  final ConnectivityChecker _connectivity;

  /// Push unsynced records to Supabase
  Future<void> pushUnsyncedRecords() async { /* ... */ }

  /// Pull remote changes into Drift
  Future<void> pullRemoteChanges(String userId) async { /* ... */ }

  Stream<SyncStatus> get syncStatusStream => /* ... */;
}
```

---

## Open/Closed Principle (OCP)

> "Software entities should be open for extension, but closed for modification."

You should be able to add new functionality without changing existing code. This is achieved through abstraction and polymorphism.

### Key Rules

1. **Use abstraction for extensibility** - Define interfaces/abstract classes that can be extended.

2. **Avoid modifying existing code for new features** - Instead, extend through inheritance or composition.

3. **Replace conditionals with polymorphism** - Use strategy pattern instead of switch/if-else.

   ```dart
   // BAD - Must modify when adding new trade side or calculation
   double calculateProfit(String side, double openPrice, double exitPrice, double volume) {
     switch (side) {
       case 'BUY':
         return (exitPrice - openPrice) * volume;
       case 'SELL':
         return (openPrice - exitPrice) * volume;
       default:
         throw ArgumentError('Unknown side: $side');
     }
   }

   // GOOD - Open for extension, closed for modification
   enum TradeSide {
     buy(name: 'BUY'),
     sell(name: 'SELL');

     final String name;
     const TradeSide({required this.name});

     /// Each variant encapsulates its own profit calculation.
     /// Adding a new side would just require adding a new enum value.
     double calculateProfit(double openPrice, double exitPrice, double volume) {
       return switch (this) {
         TradeSide.buy => (exitPrice - openPrice) * volume,
         TradeSide.sell => (openPrice - exitPrice) * volume,
       };
     }
   }

   // Usage - no switch needed
   final profit = position.side.calculateProfit(
     position.openPrice,
     position.closePrice,
     position.volume,
   );
   ```

4. **Repository pattern for data sources** - Abstract data access so new sources can be added.

   ```dart
   // Domain layer - abstraction
   abstract class TradeQueryRepository {
     Future<Either<Failure, List<ClosedPosition>>> getClosedPositions();
   }

   // Data layer - implementations can be extended
   class TradeQueryRepositoryImpl implements TradeQueryRepository {
     final TradeLocalDataSource _localDataSource;

     TradeQueryRepositoryImpl(this._localDataSource);

     @override
     Future<Either<Failure, List<ClosedPosition>>> getClosedPositions() async {
       try {
         final dtos = await _localDataSource.getAllClosedPositions();
         return Right(dtos.map((dto) => dto.toEntity()).toList());
       } catch (e) {
         return Left(DatabaseFailure(e.toString()));
       }
     }
   }
   ```

5. **Dual data source abstraction** - TradeTrackr uses Drift for local and Supabase for remote.

   ```dart
   // The repository depends on abstraction, not Drift or Supabase directly
   // This means swapping Drift for Isar, or Supabase for Firebase,
   // only requires a new data source implementation - no domain changes.

   abstract class TradeLocalDataSource {
     Future<List<ClosedPositionDto>> getAllClosedPositions(String userId);
     Future<void> insertClosedPosition(ClosedPositionsCompanion companion);
     Future<void> markAsSynced(String id, String table);
   }

   // Drift implementation
   class TradeLocalDataSourceImpl implements TradeLocalDataSource {
     final AppDatabase _db;
     TradeLocalDataSourceImpl(this._db);

     @override
     Future<List<ClosedPositionDto>> getAllClosedPositions(String userId) async {
       final data = await _db.getAllClosedPositions(userId);
       return data.map(_mapToDto).toList();
     }
   }

   // Future: Could add Isar or Hive implementation without touching domain
   // class TradeIsarDataSourceImpl implements TradeLocalDataSource { ... }
   ```

---

## Liskov Substitution Principle (LSP)

> "Derived classes must be substitutable for their base classes."

If you have a parent class and a child class, then the base class and child class can be used interchangeably without getting incorrect results. Subtypes must behave the same as their base types.

### Key Rules

1. **Don't violate the "is-a" relationship** - Ensure inheritance makes semantic sense.

2. **Don't override methods in incompatible ways** - Subtypes should honor the contract of their parent.

   ```dart
   // BAD - Square cannot properly substitute Rectangle
   class Rectangle {
     double width = 0;
     double height = 0;

     void setWidth(double w) => width = w;
     void setHeight(double h) => height = h;
     double getArea() => width * height;
   }

   class Square extends Rectangle {
     @override
     void setWidth(double w) {
       width = w;
       height = w; // VIOLATION: Changes expected Rectangle behavior
     }

     @override
     void setHeight(double h) {
       width = h;
       height = h; // VIOLATION: Changes expected Rectangle behavior
     }
   }

   // GOOD - Use common abstraction instead
   abstract class Shape {
     double getArea();
   }

   class Rectangle extends Shape {
     final double width;
     final double height;

     Rectangle(this.width, this.height);

     @override
     double getArea() => width * height;
   }

   class Square extends Shape {
     final double side;

     Square(this.side);

     @override
     double getArea() => side * side;
   }

   // Both can be substituted for Shape without issues
   void printArea(Shape shape) {
     print(shape.getArea());
   }
   ```

3. **Repository substitution** - All repository implementations must be fully substitutable for their interfaces.

   ```dart
   // GOOD - Any implementation of TradeQueryRepository can be used interchangeably
   void displayTrades(TradeQueryRepository repository) {
     repository.getClosedPositions().then((result) {
       result.fold(
         (failure) => print('Error: ${failure.message}'),
         (positions) => print('Trades: ${positions.length}'),
       );
     });
   }

   // Both work identically from the caller's perspective:
   displayTrades(TradeQueryRepositoryImpl(localDataSource));
   displayTrades(MockTradeQueryRepository()); // For testing
   ```

4. **Data source substitution** - Local and remote data sources follow the same contract.

   ```dart
   // Any TradeLocalDataSource implementation can be substituted
   // Drift, Isar, in-memory mock - all honor the same contract
   ```

---

## Interface Segregation Principle (ISP)

> "Clients should not be forced to depend upon interfaces that they do not use."

Interfaces should be small and focused. Clients shouldn't be forced to implement methods they don't need.

### Key Rules

1. **Prefer small, focused interfaces** - Split large interfaces into smaller ones.

2. **Don't force irrelevant implementations** - Classes should only implement what they actually need.

   ```dart
   // BAD - Fat interface forces all methods
   abstract class TradeService {
     // CRUD
     Future<List<ClosedPosition>> getClosedPositions();
     Future<OpenPosition?> getOpenPositionById(String id);
     Future<void> addClosedPosition(ClosedPosition position);
     Future<void> updateClosedPosition(ClosedPosition position);
     Future<void> deleteClosedPosition(String id);
     // Import/Export
     Future<ImportResult> importFromCsv(String filePath);
     Future<String> exportToCsv(List<ClosedPosition> positions);
     // Analytics
     Future<TradeAnalytics> getAnalytics(TradeFilter filter);
     Future<List<Recommendation>> getRecommendations(TradeFilter filter);
     // Auth
     Future<User?> signIn(String email, String password);
     Future<void> signOut();
     // Profile
     Future<User> getProfile();
     Future<User> updateProfile({String? displayName});
   }

   // A simple trade list page must depend on analytics, import, export, auth, AND profile methods!
   ```

3. **Repository segregation by operation type** - TradeTrackr uses 6 focused interfaces.

   ```dart
   // GOOD - 6 segregated interfaces, each with a single purpose

   // 1. Read operations only
   // lib/domain/repositories/trade_query_repository.dart
   abstract class TradeQueryRepository {
     Future<Either<Failure, List<ClosedPosition>>> getClosedPositions({
       DateTime? startDate,
       DateTime? endDate,
       List<String>? symbols,
       TradeSide? side,
       List<CloseReason>? reasons,
     });
     Future<Either<Failure, ClosedPosition?>> getClosedPositionById(String id);
     Future<Either<Failure, List<OpenPosition>>> getOpenPositions();
     Future<Either<Failure, TradeAnalytics>> getAnalytics(TradeFilter filter);
   }

   // 2. Write operations only
   // lib/domain/repositories/trade_command_repository.dart
   abstract class TradeCommandRepository {
     Future<Either<Failure, ClosedPosition>> addClosedPosition(ClosedPosition position);
     Future<Either<Failure, ClosedPosition>> updateClosedPosition(ClosedPosition position);
     Future<Either<Failure, void>> deleteClosedPosition(String id);
     Future<Either<Failure, OpenPosition>> addOpenPosition(OpenPosition position);
     Future<Either<Failure, ClosedPosition>> closePosition({
       required String openPositionId,
       required double closePrice,
       required DateTime closeTime,
       required CloseReason reason,
     });
   }

   // 3. Bulk import only
   // lib/domain/repositories/trade_import_repository.dart
   abstract class TradeImportRepository {
     Future<Either<Failure, ImportResult>> importFromCsv(String filePath);
   }

   // 4. Export only
   // lib/domain/repositories/trade_export_repository.dart
   abstract class TradeExportRepository {
     Future<Either<Failure, String>> exportClosedPositionsToCsv({
       DateTime? startDate,
       DateTime? endDate,
       List<String>? symbols,
     });
     Future<Either<Failure, String>> exportOpenPositionsToCsv();
     Future<Either<Failure, String>> exportFinanceRecordsToCsv();
   }

   // 5. Authentication only
   // lib/domain/repositories/auth_repository.dart
   abstract class AuthRepository {
     Future<Either<Failure, User>> signIn(String email, String password);
     Future<Either<Failure, User>> signUp(String email, String password);
     Future<Either<Failure, void>> signOut();
     Future<Either<Failure, void>> resetPassword(String email);
     Stream<User?> get authStateChanges;
   }

   // 6. Profile management only
   // lib/domain/repositories/user_profile_repository.dart
   abstract class UserProfileRepository {
     Future<Either<Failure, User>> getProfile();
     Future<Either<Failure, User>> updateProfile({String? displayName});
     Future<Either<Failure, void>> changePassword(
       String currentPassword,
       String newPassword,
     );
     Future<Either<Failure, void>> deleteAccount();
   }
   ```

### Benefits in Providers

```dart
// A provider that only needs to read trades - no write, import, export, or auth
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  @override
  Future<List<ClosedPosition>> build() async {
    // Only depends on query repository
    final queryRepo = ref.read(tradeQueryRepositoryProvider);
    final result = await queryRepo.getClosedPositions();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (positions) => positions,
    );
  }
}

// A provider that only needs to write trades - no read, import, export, or auth
@riverpod
class TradeFormNotifier extends _$TradeFormNotifier {
  @override
  TradeFormState build() => const TradeFormState.initial();

  Future<void> submit() async {
    // Only depends on command repository
    final commandRepo = ref.read(tradeCommandRepositoryProvider);
    final result = await commandRepo.addClosedPosition(entity);
    // Handle result...
  }
}

// An import provider - no CRUD or analytics dependencies
@riverpod
class ImportNotifier extends _$ImportNotifier {
  @override
  ImportState build() => const ImportState.idle();

  Future<void> importFromCsv(String filePath) async {
    // Only depends on import repository
    final importRepo = ref.read(tradeImportRepositoryProvider);
    final result = await importRepo.importFromCsv(filePath);
    // Handle result...
  }
}
```

---

## Dependency Inversion Principle (DIP)

> "Depend on abstractions, not on concretions."

High-level modules should not depend on low-level modules. Both should depend on abstractions. This is the foundation of Clean Architecture.

### Key Rules

1. **Depend on abstractions** - Use interfaces/abstract classes instead of concrete implementations.

2. **Use Dependency Injection** - Inject dependencies through constructors or providers.

   ```dart
   // BAD - Direct dependency on concrete implementation
   class TradeListNotifier extends StateNotifier<TradeListState> {
     // Direct dependency - hard to test and inflexible
     final TradeQueryRepositoryImpl _repository = TradeQueryRepositoryImpl();

     TradeListNotifier() : super(TradeListInitial()) {
       loadTrades();
     }
   }

   // GOOD - Dependency on abstraction
   class TradeListNotifier extends StateNotifier<TradeListState> {
     final TradeQueryRepository _repository; // Abstract type

     TradeListNotifier(this._repository) : super(TradeListInitial()) {
       loadTrades();
     }
   }

   // Provider setup
   @riverpod
   TradeQueryRepository tradeQueryRepository(TradeQueryRepositoryRef ref) {
     return TradeQueryRepositoryImpl(ref.read(tradeLocalDataSourceProvider));
   }
   ```

3. **Clean Architecture layering** - This principle is why we use Clean Architecture:

   ```
   ┌──────────────────────────────────────────────────────────────┐
   │                     Presentation Layer                        │
   │  (Pages, Widgets, Providers)                                  │
   │                      ↓ depends on ↓                           │
   │                     Domain Layer                              │
   │  (Entities, Use Cases, Repository Interfaces) ← ABSTRACTIONS │
   │                      ↑ implemented by ↑                       │
   │                     Data Layer                                │
   │  (Repository Implementations, Data Sources) ← CONCRETE        │
   └──────────────────────────────────────────────────────────────┘
   ```

4. **Sync engine as an abstraction** - The sync engine is behind an interface for testability.

   ```dart
   // Domain/core - define abstraction
   abstract class SyncEngine {
     Future<void> pushUnsyncedRecords();
     Future<void> pullRemoteChanges(String userId);
     Stream<SyncStatus> get syncStatusStream;
   }

   // Data layer - concrete implementation
   class SyncEngineImpl implements SyncEngine {
     final TradeLocalDataSource _localSource;
     final TradeRemoteDataSource _remoteSource;
     final ConnectivityChecker _connectivity;

     SyncEngineImpl({
       required TradeLocalDataSource localSource,
       required TradeRemoteDataSource remoteSource,
       required ConnectivityChecker connectivity,
     })  : _localSource = localSource,
           _remoteSource = remoteSource,
           _connectivity = connectivity;

     @override
     Future<void> pushUnsyncedRecords() async {
       if (!await _connectivity.isOnline) return;
       // Push logic...
     }

     @override
     Future<void> pullRemoteChanges(String userId) async {
       if (!await _connectivity.isOnline) return;
       // Pull logic...
     }

     @override
     Stream<SyncStatus> get syncStatusStream => /* ... */;
   }

   // Provider setup
   @riverpod
   SyncEngine syncEngine(SyncEngineRef ref) {
     return SyncEngineImpl(
       localSource: ref.read(tradeLocalDataSourceProvider),
       remoteSource: ref.read(tradeRemoteDataSourceProvider),
       connectivity: ref.read(connectivityProvider),
     );
   }
   ```

5. **Supabase client behind interface** - For testability and flexibility.

   ```dart
   // BAD - Direct Supabase dependency in use case
   class GetTradeAnalyticsUseCase {
     final SupabaseClient _client; // Concrete dependency!

     Future<TradeAnalytics> execute() async {
       final data = await _client.from('closed_positions').select();
       // Parse and compute analytics...
     }
   }

   // GOOD - Supabase is hidden behind repository abstraction
   class GetTradeAnalyticsUseCase {
     final TradeQueryRepository _repository; // Abstract dependency

     GetTradeAnalyticsUseCase(this._repository);

     Future<Either<Failure, TradeAnalytics>> execute(TradeFilter filter) async {
       return await _repository.getAnalytics(filter);
     }
   }
   ```

6. **Constructor injection in use cases** - All use cases receive interfaces.

   ```dart
   // Every use case depends on an abstract repository interface
   class AddTradeUseCase {
     final TradeCommandRepository _repository;
     AddTradeUseCase(this._repository);
   }

   class ImportTradesUseCase {
     final TradeImportRepository _repository;
     ImportTradesUseCase(this._repository);
   }

   class GetRecommendationsUseCase {
     final TradeQueryRepository _repository;
     GetRecommendationsUseCase(this._repository);
   }

   // Provider injects the concrete implementation
   @riverpod
   AddTradeUseCase addTradeUseCase(AddTradeUseCaseRef ref) {
     return AddTradeUseCase(ref.read(tradeCommandRepositoryProvider));
   }
   ```

---

## SOLID Benefits

When all SOLID principles are applied together:

- **Maintainable**: Changes are isolated and don't cascade across layers
- **Testable**: Dependencies can be mocked easily at interface boundaries
- **Flexible**: New features can be added without modifying existing code
- **Scalable**: Codebase can grow without becoming unmanageable
- **Reusable**: Small, focused components are easier to reuse

---

## SOLID Implementation Metrics

| Principle | Target | Application in TradeTrackr |
|-----------|--------|---------------------------|
| **SRP** | 100% | Each use case has one responsibility. Repositories split by operation type. Sync engine is a single-purpose module. |
| **OCP** | 100% | New data sources (Isar, Hive) can be added without modifying repositories. New trade types or close reasons extend via enum. |
| **LSP** | 100% | All repository implementations are fully substitutable. Mock repositories pass the same contract tests. |
| **ISP** | 100% | 6 segregated repository interfaces. Providers depend only on the operations they need. |
| **DIP** | 100% | All dependencies inverted. Use cases depend on abstract interfaces. Supabase and Drift hidden behind abstractions. |

---

## Before/After Code Examples

### Before (SRP + ISP Violation)

```dart
// BAD - Monolithic repository with multiple responsibilities
abstract class TradeRepository {
  // Read
  Future<List<ClosedPosition>> getClosedPositions();
  Future<OpenPosition?> getOpenPositionById(String id);
  // Write
  Future<void> addClosedPosition(ClosedPosition position);
  Future<void> updateClosedPosition(ClosedPosition position);
  Future<void> deleteClosedPosition(String id);
  Future<void> closePosition(String id, double closePrice);
  // Import/Export
  Future<ImportResult> importFromCsv(String filePath);
  Future<String> exportToCsv(List<ClosedPosition> positions);
  // Analytics
  Future<TradeAnalytics> getAnalytics();
  Future<List<Recommendation>> getRecommendations();
  // Auth
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
}

// Problem: Trade list page imports this and has access to
// auth, import, export, and analytics methods it doesn't need.
```

### After (SRP + ISP Compliant)

```dart
// GOOD - 6 focused interfaces, each with single purpose

abstract class TradeQueryRepository {
  Future<Either<Failure, List<ClosedPosition>>> getClosedPositions({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
    TradeSide? side,
    List<CloseReason>? reasons,
  });
  Future<Either<Failure, ClosedPosition?>> getClosedPositionById(String id);
  Future<Either<Failure, List<OpenPosition>>> getOpenPositions();
  Future<Either<Failure, TradeAnalytics>> getAnalytics(TradeFilter filter);
}

abstract class TradeCommandRepository {
  Future<Either<Failure, ClosedPosition>> addClosedPosition(ClosedPosition position);
  Future<Either<Failure, ClosedPosition>> updateClosedPosition(ClosedPosition position);
  Future<Either<Failure, void>> deleteClosedPosition(String id);
  Future<Either<Failure, OpenPosition>> addOpenPosition(OpenPosition position);
  Future<Either<Failure, ClosedPosition>> closePosition({
    required String openPositionId,
    required double closePrice,
    required DateTime closeTime,
    required CloseReason reason,
  });
}

abstract class TradeImportRepository {
  Future<Either<Failure, ImportResult>> importFromCsv(String filePath);
}

abstract class TradeExportRepository {
  Future<Either<Failure, String>> exportClosedPositionsToCsv({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? symbols,
  });
  Future<Either<Failure, String>> exportOpenPositionsToCsv();
  Future<Either<Failure, String>> exportFinanceRecordsToCsv();
}

abstract class AuthRepository {
  Future<Either<Failure, User>> signIn(String email, String password);
  Future<Either<Failure, User>> signUp(String email, String password);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> resetPassword(String email);
  Stream<User?> get authStateChanges;
}

abstract class UserProfileRepository {
  Future<Either<Failure, User>> getProfile();
  Future<Either<Failure, User>> updateProfile({String? displayName});
  Future<Either<Failure, void>> changePassword(
    String currentPassword,
    String newPassword,
  );
  Future<Either<Failure, void>> deleteAccount();
}
```

### Before (DIP Violation)

```dart
// BAD - Use case directly depends on Drift (concrete)
class GetTradeAnalyticsUseCase {
  final AppDatabase _db; // Drift concrete class!

  Future<TradeAnalytics> execute() async {
    final data = await _db.getAllClosedPositions(userId);
    // Compute analytics directly from Drift data...
  }
}
```

### After (DIP Compliant)

```dart
// GOOD - Use case depends on abstraction
class GetTradeAnalyticsUseCase {
  final TradeQueryRepository _repository; // Abstract interface

  GetTradeAnalyticsUseCase(this._repository);

  Future<Either<Failure, TradeAnalytics>> execute(TradeFilter filter) async {
    return await _repository.getAnalytics(filter);
  }
}

// The repository implementation hides whether data comes from
// Drift, Supabase, or any other source
```

---

## References

- [ARCHITECTURE.md](ARCHITECTURE.md) - Complete Clean Architecture guide
- [CODING_STANDARDS.md](CODING_STANDARDS.md) - File naming and conventions
- [RIVERPOD_GUIDE.md](RIVERPOD_GUIDE.md) - Riverpod 3.x patterns
- [FREEZED_GUIDE.md](FREEZED_GUIDE.md) - Freezed 3.x guide
- [CLAUDE.md](CLAUDE.md) - Project instructions and quick reference
- [PRD.md](PRD.md) - Product requirements document

---

**Last Updated**: 2026-04-11
