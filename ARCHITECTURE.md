# TradeTrackr - Architecture & Programming Concepts

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Clean Architecture](#clean-architecture)
3. [State Management](#state-management)
4. [Data Layer](#data-layer)
5. [Domain Layer](#domain-layer)
6. [Presentation Layer](#presentation-layer)
7. [Design Patterns](#design-patterns)
8. [Dependency Injection](#dependency-injection)
9. [Error Handling](#error-handling)
10. [Navigation](#navigation)
11. [Code Generation](#code-generation)
12. [Testing Strategy](#testing-strategy)
13. [Technology Stack](#technology-stack)

---

## Architecture Overview

TradeTrackr follows **Clean Architecture** principles with a clear separation of concerns across three layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Pages      │  │  Providers   │  │  Controllers │      │
│  │  (Widgets)   │  │  (Riverpod)  │  │  (State)     │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓ depends on
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Entities   │  │  Use Cases   │  │ Repositories │      │
│  │  (Models)    │  │ (Business)   │  │ (Interfaces) │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                            ↓ depends on
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                            │
│  ┌──────────────┐  ┌──────────────┐                         │
│  │ Repositories │  │ Data Sources │                         │
│  │(Implement)   │  │   (Drift)    │                         │
│  └──────────────┘  └──────────────┘                         │
└─────────────────────────────────────────────────────────────┘
```

**Key Principle**: Each layer only depends on layers below it. Never reverse.

---

## Clean Architecture

Clean Architecture ensures that the business logic is independent of UI frameworks, databases, and external agencies. This makes the codebase:

- **Testable**: Business logic can be tested without UI
- **Maintainable**: Changes to UI don't affect business logic
- **Scalable**: Easy to add new features without breaking existing ones
- **Independent**: Can swap frameworks without major refactoring

### Dependency Rule

```
Presentation → Domain → Data
     ↓            ↓         ↓
   Flutter    Business   Database
             Logic
```

**Why this matters**:
- Presentation can be changed without affecting business logic
- Business logic doesn't know about Flutter or Drift
- Data sources can be swapped (e.g., SQLite → PostgreSQL) without changing business logic

---

## State Management

### Riverpod with Code Generation

TradeTrackr uses **Riverpod 3.0** for state management with code generation. Riverpod provides:

1. **Compile-time safety**: Provider dependencies are validated at compile-time
2. **Testability**: Easy to mock providers in tests
3. **Reactive**: Automatically rebuilds when dependencies change
4. **No context needed**: Can access state anywhere in the app

### Provider Types Used

#### 1. Repository Providers
```dart
@riverpod
UserRepository userRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserRepositoryImpl(db: db);
}
```
- Watches database provider
- Returns repository implementation
- Disposed when no longer needed

#### 2. Use Case Providers
```dart
@riverpod
UserOnboardingUseCase userOnboardingUseCase(Ref ref) =>
    UserOnboardingUseCase(userRepository: ref.watch(userRepositoryProvider));
```
- Instantiates use case with dependencies
- Minimal boilerplate with code generation

#### 3. Controller Providers (State Notifiers)
```dart
@riverpod
class RegisterController extends _$RegisterController {
  @override
  RegisterState build() => const RegisterState();

  void updateFirstName(String value) {
    state = state.copyWith(firstName: value);
  }

  Future<void> register() async {
    state = state.copyWith(registrationStatus: const AsyncLoading());
    // Business logic...
  }
}
```
- Manages complex state with mutations
- Handles async operations with AsyncValue

#### 4. Keep-Alive Providers
```dart
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
```
- Persists across rebuilds
- Used for expensive resources (database connections)
- Manual cleanup with `ref.onDispose()`

### State Management Pattern

**Freezed + Riverpod** pattern for immutable state:

```dart
@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default('') String firstName,
    @Default('') String lastName,
    @Default(AsyncValue.data(null)) AsyncValue<void> registrationStatus,
  }) = _RegisterState;

  const RegisterState._();

  bool get isFormValid =>
      firstName.isNotEmpty && lastName.isNotEmpty;
}
```

**Benefits**:
- Immutable state prevents bugs
- `copyWith()` for state updates
- Computed properties (`isFormValid`)
- Built-in JSON serialization

---

## Data Layer

The data layer handles all data persistence and retrieval, implementing the repository interfaces defined in the domain layer.

### Drift ORM (SQLite)

Drift provides a type-safe SQL query builder for SQLite with:

- **Compile-time SQL validation**: Catches SQL errors at compile time
- **Type safety**: Generated Dart code matches database schema
- **Reactive queries**: Automatically updates when data changes
- **Migration support**: Schema versioning and migrations

### Database Setup

```dart
@DriftDatabase(tables: [UserTable, PreferencesTable, Trades])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'trade_trackr_db',
      native: const DriftNativeOptions(),
    );
  }
}
```

**Key points**:
- Uses `drift_flutter` for cross-platform storage
- Single database file: `trade_trackr_db`
- Schema versioning for migrations
- Memory database in tests (`NativeDatabase.memory()`)

### Table Definitions

Each table is defined in a separate file following the pattern:

```dart
class UserTable extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get email => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Features**:
- Type-safe column definitions
- Nullable columns with `.nullable()`
- Default values with `.withDefault(const Constant(value))`
- Primary key specification

### Repository Implementation

Repositories implement domain interfaces and handle:

1. **Database queries** using Drift query builder
2. **Entity mapping** between Drift rows and domain entities
3. **Error handling** with Result pattern
4. **Logging** for debugging

```dart
class UserRepositoryImpl implements UserRepository {
  final AppDatabase _db;

  UserRepositoryImpl({required AppDatabase db}) : _db = db;

  @override
  Future<Result<UserEntity>> getUser() async {
    try {
      final userRow = await _db.select(_db.userTable).getSingleOrNull();

      if (userRow != null) {
        return Result.success(
          UserEntity(
            id: userRow.id,
            firstName: userRow.firstName,
            lastName: userRow.lastName,
            email: userRow.email,
            createdAt: userRow.createdAt,
            updatedAt: userRow.updatedAt,
          ),
        );
      } else {
        return Result.failed('User not found!');
      }
    } catch (e) {
      Constants.logger.e('Failed to get user: $e');
      return Result.failed('Failed to retrieve user data!');
    }
  }
}
```

**Query capabilities**:
- Filtering with `.where()`
- Sorting with `.orderBy()`
- Joins with multiple tables
- Upserts with `.insertOnConflictUpdate()`

---

## Domain Layer

The domain layer contains pure business logic independent of any framework.

### Entities

Entities are immutable data models representing core business concepts:

```dart
@freezed
abstract class UserEntity with _$UserEntity {
  factory UserEntity({
    required String id,
    required String firstName,
    required String lastName,
    String? email,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, Object?> json) =>
      _$UserEntityFromJson(json);
}
```

**Entity benefits**:
- **Immutability**: Cannot be modified after creation
- **Type safety**: Compile-time validation
- **JSON serialization**: Built-in from/to JSON
- **Equality**: Automatic `==` and `hashCode` generation
- **copyWith**: Easy to create modified copies

### Repository Interfaces

Abstract interfaces define the contract for data operations:

```dart
abstract interface class UserRepository {
  Future<Result<UserEntity>> getUser();
  Future<Result<void>> saveUser({required UserEntity userEntity});
}
```

**Benefits**:
- **Dependency inversion**: Domain doesn't depend on implementation
- **Testability**: Easy to mock in tests
- **Flexibility**: Can swap implementations without changing business logic

### Use Cases

Use cases encapsulate business logic for specific features:

```dart
class UserOnboardingUseCase
    implements UseCase<Result<void>, UserOnboardingParams> {
  final UserRepository _userRepository;
  final Uuid _uuid = Uuid();

  UserOnboardingUseCase({required UserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Result<void>> call(UserOnboardingParams params) async {
    return await _userRepository.saveUser(
      userEntity: UserEntity(
        id: _uuid.v4(),
        firstName: params.firstName,
        lastName: params.lastName,
        email: params.email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  }
}
```

**Use case benefits**:
- **Single responsibility**: Each use case does one thing
- **Business logic**: Contains complex business rules
- **Composable**: Can be combined in transactions
- **Testable**: Pure logic, easy to test

---

## Presentation Layer

The presentation layer handles UI and user interaction using Flutter widgets and Riverpod providers.

### Page Structure

Pages extend `ConsumerStatefulWidget`:

```dart
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  late final TextEditingController _firstNameController;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(registerControllerProvider);
    _firstNameController = TextEditingController(text: initialState.firstName);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerControllerProvider);
    final isLoading = state.registrationStatus.isLoading;

    return Scaffold(/* UI */);
  }
}
```

**Provider usage**:
- `ref.watch()`: Rebuild widget when provider state changes
- `ref.read()`: Read value without rebuilding (callbacks, one-time reads)
- `ref.listen()`: Listen to provider state changes (side effects)

### State Listening Pattern

```dart
ref.listen(registerControllerProvider.select((s) => s.registrationStatus),
    (previous, next) {
  if (next is AsyncData && next.value == null && previous is AsyncLoading) {
    ref.read(routerProvider).goNamed('main');
  } else if (next is AsyncError) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error.toString()))
    );
  }
});
```

**Benefits**:
- React to state changes imperatively
- Handle success/error states
- Navigate based on state
- Show error messages

### Controller Pattern

Controllers manage state and business logic for a specific feature:

```dart
@riverpod
class RegisterController extends _$RegisterController {
  @override
  RegisterState build() => const RegisterState();

  void updateFirstName(String value) {
    state = state.copyWith(firstName: value);
  }

  Future<void> register() async {
    state = state.copyWith(registrationStatus: const AsyncLoading());

    final result = await AsyncValue.guard(() async {
      final useCase = ref.read(userOnboardingUseCaseProvider);
      return await useCase(params);
    });

    state = state.copyWith(registrationStatus: result);
  }
}
```

**Controller responsibilities**:
- Manage state mutations
- Call use cases
- Handle async operations
- Coordinate between multiple providers

---

## Design Patterns

### 1. Repository Pattern

**Purpose**: Abstraction over data sources

**Implementation**:
```dart
// Domain: Interface
abstract interface class UserRepository {
  Future<Result<UserEntity>> getUser();
}

// Data: Implementation
class UserRepositoryImpl implements UserRepository {
  final AppDatabase _db;
  // Implementation using Drift
}
```

**Benefits**:
- Decouples business logic from data access
- Easy to swap data sources (SQLite → API)
- Centralized data access logic
- Testable with mocks

### 2. Use Case Pattern

**Purpose**: Encapsulate business logic

**Implementation**:
```dart
class UserOnboardingUseCase implements UseCase<Result<void>, Params> {
  final UserRepository _userRepository;

  @override
  Future<Result<void>> call(Params params) async {
    // Business logic here
  }
}
```

**Benefits**:
- Single responsibility per use case
- Clear boundaries between features
- Easy to test business logic
- Reusable logic

### 3. Result Pattern

**Purpose**: Type-safe error handling

**Implementation**:
```dart
sealed class Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failed(String message) = Failed<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailed => this is Failed<T>;
}

class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

class Failed<T> extends Result<T> {
  const Failed(this.message);
  final String message;
}
```

**Benefits**:
- No exceptions in normal flow
- Explicit error handling
- Type-safe error states
- Composable operations

**Usage**:
```dart
final result = await userRepository.getUser();
if (result.isSuccess) {
  final user = result.resultValue!;
  // Handle success
} else {
  final error = result.errorMessage!;
  // Handle error
}
```

### 4. Dependency Injection

**Purpose**: Provide dependencies to classes

**Implementation with Riverpod**:
```dart
@riverpod
UserRepository userRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return UserRepositoryImpl(db: db);
}

@riverpod
UserOnboardingUseCase userOnboardingUseCase(Ref ref) =>
    UserOnboardingUseCase(
      userRepository: ref.watch(userRepositoryProvider)
    );
```

**Benefits**:
- Automatic dependency resolution
- Compile-time safety
- Easy to test with mocks
- Manages lifecycle

### 5. Builder Pattern

**Purpose**: Create complex objects step by step

**Implementation with Freezed**:
```dart
final user = UserEntity(
  id: '1',
  firstName: 'John',
  lastName: 'Doe',
);

final updatedUser = user.copyWith(
  lastName: 'Smith',
);
```

**Benefits**:
- Immutable object creation
- Easy to create modified copies
- Type-safe field updates

### 6. Observer Pattern

**Purpose**: React to provider state changes

**Implementation**:
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
}

// Usage
final count = ref.watch(counterProvider); // Rebuilds when count changes
```

**Benefits**:
- Automatic UI updates
- Reactive programming
- Decouples state from UI

---

## Dependency Injection

TradeTrackr uses Riverpod's built-in dependency injection system.

### Provider Graph

```
appDatabaseProvider (keepAlive: true)
    ↓
userRepositoryProvider
    ↓
userOnboardingUseCaseProvider
    ↓
registerControllerProvider
```

### Dependency Resolution

**Automatic**: Riverpod automatically resolves dependencies:

```dart
@riverpod
UserOnboardingUseCase userOnboardingUseCase(Ref ref) =>
    UserOnboardingUseCase(
      userRepository: ref.watch(userRepositoryProvider) // Auto-injected
    );
```

**Manual**: Read providers when needed:

```dart
final useCase = ref.read(userOnboardingUseCaseProvider);
```

### Lifecycle Management

- **Auto-dispose**: Providers disposed when no longer used
- **Keep-alive**: Explicitly keep providers alive (`@Riverpod(keepAlive: true)`)
- **Cleanup**: `ref.onDispose()` for resource cleanup

```dart
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close); // Cleanup on dispose
  return db;
}
```

---

## Error Handling

### Result Pattern

TradeTrackr uses the Result pattern for type-safe error handling without exceptions.

**Why Result pattern instead of exceptions?**

1. **Explicit**: Forces handling of error cases
2. **Type-safe**: Compiler ensures error cases are handled
3. **No exceptions**: Normal flow without exception overhead
4. **Composable**: Easy to chain operations

**Usage in repositories**:

```dart
@override
Future<Result<UserEntity>> getUser() async {
  try {
    final userRow = await _db.select(_db.userTable).getSingleOrNull();

    if (userRow != null) {
      return Result.success(/* entity */);
    } else {
      return Result.failed('User not found!');
    }
  } catch (e) {
    Constants.logger.e('Failed to get user: $e');
    return Result.failed('Failed to retrieve user data!');
  }
}
```

**Handling results**:

```dart
final result = await userRepository.getUser();

result.when(
  success: (user) {
    // Handle success
    print('User: ${user.firstName}');
  },
  failed: (error) {
    // Handle error
    print('Error: $error');
  },
);
```

### AsyncValue Pattern

For async operations in UI, Riverpod provides `AsyncValue`:

```dart
@freezed
abstract class RegisterState with _$RegisterState {
  const factory RegisterState({
    @Default(AsyncValue.data(null)) AsyncValue<void> registrationStatus,
  }) = _RegisterState;
}
```

**States**:
- `AsyncValue.data()`: Success with data
- `AsyncValue.loading()`: In progress
- `AsyncValue.error()`: Failed with error

**Handling AsyncValue**:

```dart
state.registrationStatus.when(
  data: (_) => Text('Success!'),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

### Logging

Centralized logging with different levels:

```dart
Constants.logger.d('Debug message');     // Debug mode
Constants.logger.i('Info message');      // Info
Constants.logger.w('Warning message');   // Always shown
Constants.logger.e('Error message');     // Always shown
```

**Log levels**:
- **Tests**: Only warnings and errors
- **Debug**: All logs
- **Release**: Only warnings and errors

---

## Navigation

TradeTrackr uses **go_router** for declarative routing with Riverpod integration.

### Router Provider

```dart
@Riverpod(keepAlive: true)
Raw<GoRouter> router(Ref ref) {
  final preferencesAsync = ref.watch(preferencesProvider);

  return GoRouter(
    routes: [
      GoRoute(
        path: '/main',
        name: 'main',
        builder: (context, state) => const MainPage(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
    ],
    initialLocation: '/onboarding',
    redirect: (context, state) {
      final preferences = preferencesAsync.value;

      if (preferencesAsync.isLoading) return null;

      final isRegistered = preferences?.isRegistered ?? false;
      final loggingIn = state.matchedLocation == '/onboarding' ||
                       state.matchedLocation == '/register';

      if (isRegistered) {
        if (loggingIn) return '/main';
      } else {
        if (!loggingIn) return '/onboarding';
      }

      return null;
    },
  );
}
```

### Features

**Declarative routing**:
- Routes defined as data structure
- Type-safe navigation with named routes
- Automatic deep linking support

**Guard redirects**:
- Redirect based on app state (e.g., authentication)
- Prevents unauthorized access
- Seamless user experience

**Provider integration**:
- Watch providers in router
- Redirect based on provider state
- Reactive to state changes

**Navigation methods**:

```dart
// Navigate by name
ref.read(routerProvider).goNamed('main');

// Navigate with parameters
ref.read(routerProvider).goNamed('trade', params: {'id': '123'});

// Navigate by path
ref.read(routerProvider).go('/main');

// Go back
ref.read(routerProvider).pop();
```

---

## Code Generation

TradeTrackr heavily uses code generation to reduce boilerplate and ensure type safety.

### Build Runner

The project uses `build_runner` for code generation:

```bash
dart run build_runner build          # Generate code
dart run build_runner watch          # Continuous generation
dart run build_runner clean && dart run build_runner build -d  # Clean rebuild
```

### Generated Files

Generated files are named with `.g.dart` or `.freezed.dart` suffix and are **ignored by Git**.

#### 1. Freezed (Immutable Models)

**Input**:
```dart
@freezed
abstract class UserEntity with _$UserEntity {
  factory UserEntity({
    required String id,
    required String firstName,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, Object?> json) =>
      _$UserEntityFromJson(json);
}
```

**Generated** (`user_entity.freezed.dart`):
- Private implementation class `_$UserEntity`
- `copyWith()` method
- `toString()`, `==`, `hashCode`
- Union types support

#### 2. JSON Serialization

**Generated** (`user_entity.g.dart`):
- `fromJson()` constructor
- `toJson()` method
- Type-safe JSON conversion

#### 3. Riverpod Providers

**Input**:
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;

  void increment() => state++;
}
```

**Generated** (`counter.g.dart`):
- Provider definition
- Provider accessor functions
- Type-safe provider dependencies

#### 4. Drift Database

**Generated** (`app_database.g.dart`):
- Database class implementation
- DAO methods
- Type-safe queries
- Migration logic

### When to Regenerate

Run `dart run build_runner build` after:

- Modifying Freezed models
- Adding/modifying Riverpod providers
- Changing Drift tables
- Adding `@JsonSerializable` annotations

---

## Testing Strategy

TradeTrackr uses **flutter_test** with **mockito** for comprehensive testing.

### Test Structure

Tests mirror the source structure:

```
test/
├── domain/
│   ├── entity/           # Entity unit tests
│   ├── repository/       # Repository interface tests
│   └── use_case/         # Use case unit tests
├── data/
│   └── repository/       # Repository implementation tests
└── presentation/
    ├── provider/         # Provider tests
    └── page/             # Page widget tests
```

### Repository Testing

Uses in-memory database for fast, isolated tests:

```dart
void main() {
  late AppDatabase db;
  late UserRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = UserRepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  group('UserRepository', () {
    test('getUser should return success when user exists', () async {
      // Arrange
      await db.into(db.userTable).insert(/* test data */);

      // Act
      final result = await repository.getUser();

      // Assert
      expect(result.isSuccess, true);
      expect(result.resultValue!.firstName, 'John');
    });
  });
}
```

### Use Case Testing

Tests business logic with mocked repositories:

```dart
void main() {
  group('UserOnboardingUseCase', () {
    test('should create user with UUID', () async {
      // Arrange
      final mockRepo = MockUserRepository();
      final useCase = UserOnboardingUseCase(userRepository: mockRepo);

      // Act
      await useCase(UserOnboardingParams(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
      ));

      // Assert
      verify(mockRepo.saveUser(userEntity: captureAny))
          .called(1);
    });
  });
}
```

### Provider Testing

Tests provider state and behavior:

```dart
void main() {
  test('registerController should update state', () async {
    // Arrange
    final container = ProviderContainer();
    final controller = container.read(registerControllerProvider.notifier);

    // Act
    controller.updateFirstName('John');

    // Assert
    expect(
      container.read(registerControllerProvider).firstName,
      'John',
    );

    container.dispose();
  });
}
```

### Testing Commands

```bash
flutter test                              # Run all tests
flutter test test/user_repository_test.dart  # Single test file
flutter test --coverage                   # With coverage report
flutter test -v                            # Verbose output
```

---

## Technology Stack

### Core

- **Flutter 3.35.5**: Cross-platform UI framework
- **Dart 3.9.2**: Programming language
- **mise/fvm**: Version management (required exact Flutter version)

### State Management

- **Riverpod 3.0.0**: Reactive state management
- **Riverpod Annotation 3.0.0**: Code generation
- **Riverpod Generator 3.0.0**: Provider code generation
- **Riverpod Lint 3.0.0**: Riverpod-specific linting

### Data Models

- **Freezed 3.2.3**: Immutable data models
- **Freezed Annotation 3.1.0**: Code generation annotations
- **JSON Annotation 4.9.0**: JSON serialization annotations
- **JSON Serializable 6.11.1**: JSON code generation

### Database

- **Drift 2.29.0**: Type-safe SQLite ORM
- **Drift Flutter 0.2.7**: Flutter integration
- **Drift Dev 2.29.0**: Drift development tools

### Navigation

- **Go Router 16.2.1**: Declarative routing

### UI

- **Shadcn UI 0.31.8**: Modern UI component library
- **Material Design**: Flutter's built-in UI

### Utilities

- **UUID 4.1.0**: Unique identifier generation
- **Intl 0.20.2**: Internationalization and date formatting
- **Path 1.9.0**: Path manipulation
- **Path Provider 2.1.3**: File system access
- **Permission Handler 11.3.1**: Platform permissions
- **Logger 2.6.1**: Logging utility

### Development Tools

- **Build Runner 2.7.1**: Code generation runner
- **Custom Lint 0.8.0**: Custom linting rules
- **Flutter Lints 5.0.0**: Flutter-specific linting
- **Flutter Gen Runner 5.12.0**: Asset generation

### Testing

- **Flutter Test**: Built-in testing framework
- **Mockito 5.1.0**: Mocking framework

---

## Key Programming Concepts

### 1. Separation of Concerns

Each layer has a single responsibility:
- **Presentation**: UI and user interaction
- **Domain**: Business logic and rules
- **Data**: Persistence and retrieval

### 2. Dependency Inversion

High-level modules (Domain) don't depend on low-level modules (Data). Both depend on abstractions (Repository interfaces).

### 3. Immutability

Entities and state are immutable, preventing bugs from unexpected mutations.

### 4. Type Safety

Dart's strong type system and code generation ensure type safety at compile-time.

### 5. Reactive Programming

Riverpod's reactive system automatically updates UI when state changes.

### 6. Code Generation

Reduces boilerplate and ensures consistency through generated code.

### 7. Clean Code

Following SOLID principles and clean code practices:
- **S**ingle Responsibility
- **O**pen/Closed
- **L**iskov Substitution
- **I**nterface Segregation
- **D**ependency Inversion

### 8. Test-Driven Development

Write tests first, ensure code is testable, and maintain high test coverage.

---

## Summary

TradeTrackr implements a modern, scalable architecture following Clean Architecture principles:

- **Clean Architecture**: Three-layer separation (Presentation → Domain → Data)
- **Riverpod**: Type-safe reactive state management with code generation
- **Drift**: Type-safe SQLite ORM with compile-time SQL validation
- **Freezed**: Immutable data models with JSON serialization
- **Repository Pattern**: Abstraction over data sources
- **Use Case Pattern**: Business logic encapsulation
- **Result Pattern**: Type-safe error handling
- **Dependency Injection**: Automatic dependency resolution
- **Go Router**: Declarative navigation with provider integration
- **Code Generation**: Reduced boilerplate through build_runner
- **Testing**: Comprehensive testing strategy with in-memory databases and mocks

This architecture ensures:
- ✅ **Maintainability**: Clear structure, easy to understand
- ✅ **Testability**: Isolated components, easy to mock
- ✅ **Scalability**: Easy to add new features
- ✅ **Type Safety**: Compile-time validation
- ✅ **Performance**: Efficient rendering and data access
- ✅ **Developer Experience**: Modern tools and patterns

---

## References

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) - Robert C. Martin
- [Riverpod Documentation](https://riverpod.dev/) - Official Riverpod docs
- [Drift Documentation](https://drift.simonbinder.eu/) - Official Drift docs
- [Freezed Documentation](https://pub.dev/packages/freezed) - Official Freezed docs
- [Go Router Documentation](https://gorouter.dev/) - Official Go Router docs
- [Clean Architecture Flutter Guide](https://resocoder.com/flutter-clean-architecture-tdd/) - Reso Coder

---

**Last Updated**: January 24, 2026
