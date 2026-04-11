# Riverpod 3.x Guide - TradeTrackr

**Last Updated**: 2026-04-11
**Project**: TradeTrackr (Flutter Trading Journal App)
**Riverpod Version**: 3.x (latest stable)
**Annotation Package**: riverpod_annotation (latest stable)
**Code Generator**: riverpod_generator (latest stable)

---

## Table of Contents
1. [Setup](#setup)
2. [@riverpod Annotation Pattern](#riverpod-annotation-pattern)
3. [Code Generation Workflow](#code-generation-workflow)
4. [Provider Types](#provider-types)
5. [Provider Organization](#provider-organization)
6. [Best Practices](#best-practices)
7. [Common Patterns](#common-patterns)
8. [GoRouter Integration with Riverpod](#gointegration-with-riverpod)
9. [Testing with Riverpod](#testing-with-riverpod)
10. [Riverpod Modifiers](#riverpod-modifiers)
11. [Common Issues & Solutions](#common-issues--solutions)

---

## Setup

### Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  flutter_riverpod: ^3.3.1
  riverpod_annotation: ^4.0.2

dev_dependencies:
  build_runner: ^2.4.13
  riverpod_generator: ^4.0.3
```

### Main.dart Configuration

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

## @riverpod Annotation Pattern

Riverpod 3.x uses code generation with the `@riverpod` annotation. This is the **primary pattern** used in TradeTrackr.

### Critical Rule: Initialize in build(), NOT Constructor

**CRITICAL**: Never initialize state or read providers in the constructor. Always use the `build()` method.

```dart
// WRONG - Initialization in constructor
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  TradeListNotifier() {
    // This runs BEFORE providers are available!
    _loadTrades();
  }

  @override
  Future<List<ClosedPosition>> build() => Future.value([]);

  Future<void> _loadTrades() async {
    // This will fail because providers aren't ready
    final useCase = ref.read(getTradeAnalyticsUseCaseProvider);
  }
}
```

```dart
// CORRECT - Initialization in build()
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  @override
  Future<List<ClosedPosition>> build() async {
    // Providers are available here
    final getTradesUseCase = ref.read(getTradeAnalyticsUseCaseProvider);
    return await getTradesUseCase.execute(const TradeFilter());
  }

  Future<void> refresh() async {
    // Invalidate to trigger rebuild
    ref.invalidateSelf();
  }
}
```

### Basic AsyncNotifier Pattern

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_provider.g.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  Future<DataType> build() async {
    // Initialize here - providers are available
    final useCase = ref.read(myUseCaseProvider);
    return await useCase.execute();
  }

  Future<void> performAction() async {
    // Set loading state
    state = const AsyncValue.loading();

    // Execute and handle result
    state = await AsyncValue.guard(() async {
      final result = await someAsyncOperation();
      return result;
    });
  }

  Future<void> refresh() async {
    // Invalidate to trigger rebuild
    ref.invalidateSelf();
  }
}
```

### Basic Notifier Pattern (Synchronous)

```dart
@riverpod
class FilterNotifier extends _$FilterNotifier {
  @override
  TradeFilter build() {
    return const TradeFilter();
  }

  void setSymbol(List<String> symbols) {
    state = state.copyWith(symbols: symbols);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void setSide(TradeSide? side) {
    state = state.copyWith(side: side);
  }

  void reset() {
    state = const TradeFilter();
  }
}
```

---

## Code Generation Workflow

### Step 1: Create Provider with Annotation

```dart
// lib/presentation/providers/trade_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'trade_provider.g.dart'; // Required

@riverpod // Annotation
class TradeFormNotifier extends _$TradeFormNotifier {
  @override
  TradeFormState build() {
    return const TradeFormState.initial();
  }
}
```

### Step 2: Run Code Generation

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (recommended during development)
dart run build_runner watch --delete-conflicting-outputs
```

### Step 3: Use in UI

```dart
class DashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider
    final state = ref.watch(tradeListProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorWidget(message: error.toString()),
      data: (positions) => TradeList(positions: positions),
    );
  }
}
```

---

## Provider Types

### 1. AsyncNotifier (Async Data)

For asynchronous state with loading/error/data states:

```dart
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  @override
  Future<List<ClosedPosition>> build() async {
    final queryRepo = ref.read(tradeQueryRepositoryProvider);
    final result = await queryRepo.getClosedPositions();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (positions) => positions,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}
```

### 2. Notifier (Sync Data)

For simple synchronous state:

```dart
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    // Read stored preference, default to system
    return ThemeMode.system;
  }

  void setTheme(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
```

### 3. Provider (Computed Values)

For derived/computed values:

```dart
@riverpod
double winRate(WinRateRef ref) {
  final positionsAsync = ref.watch(tradeListProvider);

  return positionsAsync.when(
    loading: () => 0.0,
    error: (_, __) => 0.0,
    data: (positions) {
      if (positions.isEmpty) return 0.0;
      final wins = positions.where((p) => p.isWin).length;
      return (wins / positions.length * 100);
    },
  );
}

@riverpod
double totalProfitLoss(TotalProfitLossRef ref) {
  final positionsAsync = ref.watch(tradeListProvider);

  return positionsAsync.when(
    loading: () => 0.0,
    error: (_, __) => 0.0,
    data: (positions) {
      return positions.fold(0.0, (sum, p) => sum + p.netProfit);
    },
  );
}
```

### 4. FutureProvider (One-shot Async)

For one-time asynchronous operations:

```dart
@riverpod
Future<User> currentUser(CurrentUserRef ref) async {
  final authRepo = ref.read(authRepositoryProvider);
  final authState = authRepo.authStateChanges;

  // Wait for first auth event
  final user = await authState.first;
  if (user == null) throw Exception('Not authenticated');

  final profileRepo = ref.read(userProfileRepositoryProvider);
  final result = await profileRepo.getProfile();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (user) => user,
  );
}
```

---

## Provider Organization

### Directory Structure

```
lib/presentation/providers/
├── auth_provider.dart               # Auth state, sign in/out
├── trade_provider.dart              # Trade CRUD state, form
├── analytics_provider.dart          # Dashboard analytics, metrics
├── recommendation_provider.dart     # Recommendation engine
├── import_export_provider.dart      # CSV import/export progress
├── profile_provider.dart            # User profile CRUD
└── theme_provider.dart              # Light/dark mode toggle
```

### Central Export File

```dart
// lib/presentation/providers/providers.dart

// Auth
export 'auth_provider.dart';

// Trade management
export 'trade_provider.dart';

// Analytics
export 'analytics_provider.dart';

// Recommendations
export 'recommendation_provider.dart';

// Import/Export
export 'import_export_provider.dart';

// User profile
export 'profile_provider.dart';

// Theme
export 'theme_provider.dart';
```

### Repository Providers (Dual Data Source)

```dart
// lib/presentation/providers/di_providers.dart

// Data sources
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

// Repositories
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
TradeExportRepository tradeExportRepository(TradeExportRepositoryRef ref) {
  return TradeExportRepositoryImpl(ref.read(tradeLocalDataSourceProvider));
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.read(supabaseClientProvider));
}

@riverpod
UserProfileRepository userProfileRepository(UserProfileRepositoryRef ref) {
  return UserProfileRepositoryImpl(ref.read(supabaseClientProvider));
}
```

### UseCase Providers

```dart
// lib/presentation/providers/usecase_providers.dart

@riverpod
AddTradeUseCase addTradeUseCase(AddTradeUseCaseRef ref) {
  return AddTradeUseCase(ref.read(tradeCommandRepositoryProvider));
}

@riverpod
UpdateTradeUseCase updateTradeUseCase(UpdateTradeUseCaseRef ref) {
  return UpdateTradeUseCase(ref.read(tradeCommandRepositoryProvider));
}

@riverpod
DeleteTradeUseCase deleteTradeUseCase(DeleteTradeUseCaseRef ref) {
  return DeleteTradeUseCase(ref.read(tradeCommandRepositoryProvider));
}

@riverpod
GetTradeAnalyticsUseCase getTradeAnalyticsUseCase(GetTradeAnalyticsUseCaseRef ref) {
  return GetTradeAnalyticsUseCase(ref.read(tradeQueryRepositoryProvider));
}

@riverpod
ImportTradesUseCase importTradesUseCase(ImportTradesUseCaseRef ref) {
  return ImportTradesUseCase(ref.read(tradeImportRepositoryProvider));
}

@riverpod
ExportTradesUseCase exportTradesUseCase(ExportTradesUseCaseRef ref) {
  return ExportTradesUseCase(ref.read(tradeExportRepositoryProvider));
}

@riverpod
GetRecommendationsUseCase getRecommendationsUseCase(GetRecommendationsUseCaseRef ref) {
  return GetRecommendationsUseCase(ref.read(tradeQueryRepositoryProvider));
}

@riverpod
SignInUseCase signInUseCase(SignInUseCaseRef ref) {
  return SignInUseCase(ref.read(authRepositoryProvider));
}

@riverpod
SignUpUseCase signUpUseCase(SignUpUseCaseRef ref) {
  return SignUpUseCase(ref.read(authRepositoryProvider));
}

@riverpod
SignOutUseCase signOutUseCase(SignOutUseCaseRef ref) {
  return SignOutUseCase(ref.read(authRepositoryProvider));
}
```

---

## Best Practices

### 1. Always Use @riverpod Annotation

```dart
// GOOD - With annotation
@riverpod
class TradeFormNotifier extends _$TradeFormNotifier {
  @override
  TradeFormState build() => const TradeFormState.initial();
}

// BAD - Manual definition (deprecated in Riverpod 3.x)
final tradeFormProvider = StateNotifierProvider<TradeFormNotifier, TradeFormState>((ref) {
  return TradeFormNotifier();
});
```

### 2. Initialize in build() Method

```dart
// GOOD
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  @override
  Future<List<ClosedPosition>> build() async {
    final useCase = ref.read(getTradeAnalyticsUseCaseProvider);
    return await useCase.execute(const TradeFilter());
  }
}

// BAD
@riverpod
class TradeListNotifier extends _$TradeListNotifier {
  TradeListNotifier() {
    // Don't initialize here!
  }

  @override
  Future<List<ClosedPosition>> build() async => [];
}
```

### 3. Use AsyncValue.guard for Error Handling

```dart
// GOOD
Future<void> submitTrade() async {
  state = const AsyncValue.loading();
  state = await AsyncValue.guard(() async {
    return await _performSubmission();
  });
}

// BAD
Future<void> submitTrade() async {
  state = const AsyncValue.loading();
  try {
    final result = await _performSubmission();
    state = AsyncValue.data(result);
  } catch (e, st) {
    state = AsyncValue.error(e, st);
  }
}
```

### 4. Use ref.read for Callbacks

```dart
// GOOD
void onSubmit() {
  ref.read(tradeFormNotifierProvider.notifier).submit();
}

// BAD
void onSubmit() {
  // Don't use ref.watch in callbacks!
  final notifier = ref.watch(tradeFormNotifierProvider.notifier);
  notifier.submit();
}
```

### 5. Use ref.listen for Side Effects

```dart
// GOOD
@override
Widget build(BuildContext context) {
  ref.listen<TradeFormState>(
    tradeFormNotifierProvider,
    (previous, next) {
      next.maybeWhen(
        success: (position) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${position.symbol} trade saved')),
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
  return _buildUI(state);
}
```

### 6. Use select for Derived State

```dart
// GOOD - Only rebuild when winRate changes
final winRate = ref.watch(
  tradeListProvider.select((value) {
    final positions = value.valueOrNull ?? [];
    if (positions.isEmpty) return 0.0;
    return positions.where((p) => p.isWin).length / positions.length * 100;
  }),
);

// BAD - Rebuilds on any change
final state = ref.watch(tradeListProvider);
final positions = state.valueOrNull ?? [];
final winRate = positions.isEmpty ? 0.0 : positions.where((p) => p.isWin).length / positions.length * 100;
```

---

## Common Patterns

### Pattern 1: Trade Form with Validation

```dart
@riverpod
class TradeFormNotifier extends _$TradeFormNotifier {
  @override
  TradeFormState build() {
    return const TradeFormState.initial();
  }

  void setSymbol(String value) {
    final errors = Map<String, String>.from(
      (state as TradeFormInitial).validationErrors,
    );
    if (value.isEmpty) {
      errors['symbol'] = 'Symbol is required';
    } else {
      errors.remove('symbol');
    }
    state = (state as TradeFormInitial).copyWith(
      symbol: value,
      validationErrors: errors,
    );
  }

  void setSide(TradeSide value) {
    state = (state as TradeFormInitial).copyWith(side: value);
  }

  void setVolume(double value) {
    state = (state as TradeFormInitial).copyWith(volume: value);
  }

  Future<void> submit() async {
    final formState = state as TradeFormInitial;
    final errors = _validateAll(formState);
    if (errors.isNotEmpty) {
      state = formState.copyWith(validationErrors: errors);
      return;
    }

    state = const TradeFormState.loading();

    final useCase = ref.read(addTradeUseCaseProvider);
    final entity = _mapToEntity(formState);
    final result = await useCase.execute(entity);

    result.fold(
      (failure) => state = TradeFormState.error(failure.message),
      (success) => state = TradeFormState.success(success),
    );
  }

  Map<String, String> _validateAll(TradeFormInitial form) {
    final errors = <String, String>{};
    if (form.symbol == null || form.symbol!.isEmpty) {
      errors['symbol'] = 'Symbol is required';
    }
    if (form.volume <= 0) {
      errors['volume'] = 'Volume must be greater than 0';
    }
    if (form.openPrice <= 0) {
      errors['openPrice'] = 'Open price must be greater than 0';
    }
    if (form.openTime == null) {
      errors['openTime'] = 'Open time is required';
    }
    return errors;
  }
}
```

### Pattern 2: Analytics Dashboard Provider

```dart
@riverpod
class AnalyticsNotifier extends _$AnalyticsNotifier {
  @override
  Future<TradeAnalytics> build() async {
    final filter = ref.watch(tradeFilterProvider);
    final useCase = ref.read(getTradeAnalyticsUseCaseProvider);
    final result = await useCase.execute(filter);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (analytics) => analytics,
    );
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// Computed providers for individual metrics
@riverpod
String formattedWinRate(FormattedWinRateRef ref) {
  final analytics = ref.watch(analyticsNotifierProvider);
  final rate = analytics.valueOrNull?.winRate ?? 0.0;
  return '${rate.toStringAsFixed(1)}%';
}

@riverpod
String formattedTotalPnL(FormattedTotalPnLRef ref) {
  final analytics = ref.watch(analyticsNotifierProvider);
  final pnl = analytics.valueOrNull?.totalProfitLoss ?? 0.0;
  final prefix = pnl >= 0 ? '+' : '';
  return '$prefix${pnl.toStringAsFixed(2)}';
}

@riverpod
String profitFactorText(ProfitFactorTextRef ref) {
  final analytics = ref.watch(analyticsNotifierProvider);
  final factor = analytics.valueOrNull?.profitFactor ?? 0.0;
  if (factor == double.infinity) return 'INF';
  return factor.toStringAsFixed(2);
}
```

### Pattern 3: CSV Import Progress Provider

```dart
@riverpod
class ImportNotifier extends _$ImportNotifier {
  @override
  ImportState build() => const ImportState.idle();

  Future<void> importFromCsv(String filePath) async {
    state = const ImportState.loading(processed: 0, total: 0);

    final useCase = ref.read(importTradesUseCaseProvider);
    final result = await useCase.execute(filePath);

    result.fold(
      (failure) => state = ImportState.error(failure.message),
      (importResult) => state = ImportState.success(
        imported: importResult.imported,
        skipped: importResult.skipped,
        errors: importResult.errors,
      ),
    );
  }

  void reset() {
    state = const ImportState.idle();
  }
}
```

### Pattern 4: Sync Status Provider

```dart
@riverpod
class SyncStatusNotifier extends _$SyncStatusNotifier {
  StreamSubscription? _connectivitySub;

  @override
  SyncStatusState build() {
    // Watch connectivity changes
    final connectivity = ref.watch(connectivityProvider);

    ref.onDispose(() {
      _connectivitySub?.cancel();
    });

    if (!connectivity) {
      return const SyncStatusState.offline();
    }

    // Count unsynced records
    final localSource = ref.read(tradeLocalDataSourceProvider);
    final pendingCount = _countUnsyncedRecords(localSource);

    if (pendingCount > 0) {
      return SyncStatusState.pending(pendingCount: pendingCount);
    }

    return const SyncStatusState.synced();
  }

  Future<void> triggerSync() async {
    final syncEngine = ref.read(syncEngineProvider);
    await syncEngine.pushUnsyncedRecords();
    ref.invalidateSelf();
  }
}
```

### Pattern 5: Filtered Trade List (Dependent Providers)

```dart
// Filter state provider
@riverpod
class TradeFilterNotifier extends _$TradeFilterNotifier {
  @override
  TradeFilter build() => const TradeFilter();

  void setSymbols(List<String> symbols) {
    state = state.copyWith(symbols: symbols);
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(startDate: start, endDate: end);
  }

  void setSide(TradeSide? side) {
    state = state.copyWith(side: side);
  }

  void setReasons(List<CloseReason> reasons) {
    state = state.copyWith(reasons: reasons);
  }

  void reset() {
    state = const TradeFilter();
  }
}

// Filtered data provider - depends on filter
@riverpod
Future<List<ClosedPosition>> filteredTrades(FilteredTradesRef ref) async {
  final filter = ref.watch(tradeFilterNotifierProvider);
  final queryRepo = ref.read(tradeQueryRepositoryProvider);

  final result = await queryRepo.getClosedPositions(
    startDate: filter.startDate,
    endDate: filter.endDate,
    symbols: filter.symbols.isEmpty ? null : filter.symbols,
    side: filter.side,
    reasons: filter.reasons.isEmpty ? null : filter.reasons,
  );

  return result.fold(
    (failure) => throw Exception(failure.message),
    (positions) => positions,
  );
}
```

### Pattern 6: Auth State Provider with GoRouter Redirect

```dart
@riverpod
Stream<User?> authState(AuthStateRef ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return authRepo.authStateChanges;
}

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authStateAsync = ref.watch(authStateProvider);

  return GoRouter(
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
            builder: (context, state) =>
                const TradeListPage(type: PositionType.closed),
          ),
          GoRoute(
            path: '/trades/open',
            builder: (context, state) =>
                const TradeListPage(type: PositionType.open),
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
      final isLoggedIn = authStateAsync.valueOrNull != null;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';
      return null;
    },
  );
}
```

---

## GoRouter Integration with Riverpod

TradeTrackr uses GoRouter as a Riverpod provider for reactive auth-based routing.

### Router as a Provider

```dart
@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    routes: [/* ... */],
    redirect: (context, state) {
      final user = authState.valueOrNull;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (user == null && !isLoggingIn) return '/login';
      if (user != null && isLoggingIn) return '/';
      return null;
    },
  );
}
```

### Auth State Stream

```dart
@riverpod
Stream<User?> authState(AuthStateRef ref) {
  final supabase = Supabase.instance.client;
  return supabase.auth.onAuthStateChange.map((event) {
    return event.session?.user;
  });
}
```

### Navigation in Providers

```dart
// Use ref.read for navigation in providers
Future<void> submit() async {
  // ... submit logic
  state = TradeFormState.success(position);

  // Navigate back after success
  // Navigation should be handled in the UI via ref.listen
}

// In the UI:
ref.listen<TradeFormState>(
  tradeFormNotifierProvider,
  (previous, next) {
    next.maybeWhen(
      success: (_) => context.pop(),
      orElse: () {},
    );
  },
);
```

---

## Testing with Riverpod

### Unit Test for Provider

```dart
// test/presentation/providers/trade_provider_test.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        addTradeUseCaseProvider.overrideWithValue(mockAddUseCase),
        tradeCommandRepositoryProvider.overrideWithValue(mockCommandRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('should validate symbol field', () {
    // Arrange
    final notifier = container.read(tradeFormNotifierProvider.notifier);

    // Act
    notifier.setSymbol('');

    // Assert
    final state = container.read(tradeFormNotifierProvider);
    state.when(
      initial: (form) => expect(form.validationErrors['symbol'], isNotNull),
      loading: () => fail('Should be initial'),
      success: (_) => fail('Should be initial'),
      error: (_) => fail('Should be initial'),
    );
  });

  test('should submit trade successfully', () async {
    // Arrange
    final notifier = container.read(tradeFormNotifierProvider.notifier);

    when(mockAddUseCase.execute(any))
        .thenAnswer((_) async => Right(testPosition));

    // Set form values
    notifier.setSymbol('EURUSD');
    notifier.setVolume(0.1);
    notifier.setOpenPrice(1.0850);

    // Act
    await notifier.submit();

    // Assert
    final state = container.read(tradeFormNotifierProvider);
    expect(state, isA<TradeFormSuccess>());
    verify(mockAddUseCase.execute(any)).called(1);
  });
}
```

### Widget Test with Provider

```dart
// test/presentation/pages/dashboard_page_test.dart
void main() {
  testWidgets('should display analytics metrics', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analyticsNotifierProvider.overrideWith(() => MockAnalyticsNotifier()),
        ],
        child: const MaterialApp(home: DashboardPage()),
      ),
    );

    // Verify metric labels
    expect(find.text('Win Rate'), findsOneWidget);
    expect(find.text('Total P/L'), findsOneWidget);
    expect(find.text('Profit Factor'), findsOneWidget);
  });
}
```

---

## Riverpod Modifiers

### AutoDispose (Automatic Cleanup)

```dart
// Provider is automatically disposed when no longer watched
@riverpod
class TradeFormNotifier extends _$TradeFormNotifier {
  @override
  TradeFormState build() {
    return const TradeFormState.initial();
  }
}

// Generated provider is auto-disposed by default
// Good for: form state, temporary data
```

### Family (Parameterized Providers)

```dart
// Provider with parameter
@riverpod
Future<ClosedPosition?> tradeById(TradeByIdRef ref, {required String id}) async {
  final queryRepo = ref.read(tradeQueryRepositoryProvider);
  final result = await queryRepo.getClosedPositionById(id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (position) => position,
  );
}

// Usage
final state = ref.watch(tradeByIdProvider(id: 'abc-123'));
```

### KeepAlive (Prevent Disposal)

```dart
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }
}

// Provider stays alive even when not watched
// Good for: theme, auth state, user session
```

---

## Common Issues & Solutions

### Issue 1: "Provider not found"

**Cause**: Provider not generated or not imported

**Solution**:
```bash
# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Verify import
import 'package:tradetrackr/presentation/providers/trade_provider.dart';
```

### Issue 2: "setState() called after dispose"

**Cause**: Modifying state after widget unmount

**Solution**:
```dart
Future<void> someAsyncOperation() async {
  if (!mounted) return; // Check mounted

  state = const AsyncValue.loading();
  // ...
}
```

### Issue 3: Provider not updating

**Cause**: Not using ref.watch or ref.listen

**Solution**:
```dart
// GOOD - Watch for changes
final state = ref.watch(tradeListProvider);

// BAD - Read once, no updates
final state = ref.read(tradeListProvider);
```

### Issue 4: Circular dependency

**Cause**: Two providers depend on each other

**Solution**: Split the providers or use `ref.read` instead of `ref.watch` for one direction.

---

## Related Documentation

- [ARCHITECTURE.md](ARCHITECTURE.md) - Clean Architecture with Riverpod
- [FREEZED_GUIDE.md](FREEZED_GUIDE.md) - Freezed for state classes
- [CODING_STANDARDS.md](CODING_STANDARDS.md) - File naming and conventions
- [SOLID.md](SOLID.md) - SOLID principles
- [CLAUDE.md](CLAUDE.md) - Project instructions and quick reference
- [PRD.md](PRD.md) - Product requirements document

---

**Last Updated**: 2026-04-11
**Riverpod Version**: 3.x (latest stable)
**Pattern**: @riverpod annotation with code generation
