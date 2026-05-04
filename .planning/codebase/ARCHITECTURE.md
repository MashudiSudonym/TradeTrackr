<!-- refreshed: 2026-05-04 -->
# Architecture

**Analysis Date:** 2026-05-04

## System Overview

```text
┌──────────────────────────────────────────────────────────────────────────┐
│                         Presentation Layer                                │
│  lib/presentation/                                                       │
│  ┌────────────────┬──────────────────┬──────────────────────────────┐   │
│  │    Pages (18)   │  Widgets (27+)   │   Providers (9 + DI)        │   │
│  │ `pages/*.dart`  │ `widgets/*.dart`  │ `providers/*.dart`          │   │
│  │                 │  Charts (7)       │  State (2 Freezed unions)   │   │
│  │                 │  Responsive (5)   │                             │   │
│  └───────┬────────┴────────┬──────────┴──────────────┬───────────────┘   │
│          │                 │                          │                   │
│          │  `lib/app/`     │                          │                   │
│          │  Router + Theme │                          │                   │
│          │  `router.dart`  │                          │                   │
└──────────┼─────────────────┼──────────────────────────┼───────────────────┘
           │ watches          │ uses                      │ injects
           ▼                  ▼                           ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                         Domain Layer                                      │
│  lib/domain/  (pure Dart — zero external deps)                           │
│  ┌──────────────┬─────────────────┬─────────────────┐                   │
│  │ Entities (7)  │ Repositories (6) │ Use Cases (11)  │                   │
│  │ `entities/`   │ `repositories/`  │ `usecases/`     │                   │
│  │               │ (interfaces)      │                 │                   │
│  └───────────────┴──────────────────┴─────────────────┘                   │
│  ┌──────────────┬──────────────────┐                                     │
│  │ Enums (4)     │ Core (Result<T>,  │                                     │
│  │ `enums/`      │  UseCase base)    │                                     │
│  └───────────────┴──────────────────┘                                     │
└──────────────────────────┬───────────────────────────────────────────────┘
                           │ implemented by
                           ▼
┌──────────────────────────────────────────────────────────────────────────┐
│                         Data Layer                                        │
│  lib/data/                                                                │
│  ┌───────────────────────┬──────────────────┬────────────────────────┐  │
│  │ Data Sources           │ DTOs (Freezed)    │ Repo Implementations   │  │
│  │ `datasources/`         │ `models/`         │ `repositories/`        │  │
│  │  ├─ Drift (local)      │  ├─ ClosedPosition│  ├─ *_impl.dart (6)    │  │
│  │  ├─ Supabase (remote)  │  ├─ OpenPosition  │                        │  │
│  │  ├─ Auth (Supabase)    │  ├─ FinanceRecord │                        │  │
│  │  └─ User (Supabase)    │  └─ User          │                        │  │
│  └───────────────────────┴──────────────────┴────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────────┘
           │                              │
           ▼                              ▼
┌─────────────────────────┐  ┌──────────────────────────────┐
│  Drift/SQLite (local)    │  │  Supabase (remote backend)    │
│  `datasources/drift/`    │  │  Auth + Postgres + RLS        │
│  4 tables: ClosedPos,    │  │  Migrations: 001–006          │
│  OpenPos, Finance,       │  │  `supabase/migrations/`       │
│  Profiles                │  │                                │
└─────────────────────────┘  └──────────────────────────────┘
```

## Component Responsibilities

| Component | Responsibility | File |
|-----------|----------------|------|
| **main.dart** | Bootstrap: env loading, Supabase init, Workmanager init, global error handling, ProviderScope | `lib/main.dart` |
| **TradeTrackrApp** | Root widget: MaterialApp.router, theme switching, app lifecycle observation for sync | `lib/app/app.dart` |
| **GoRouter** | Declarative routing with auth redirect, onboarding redirect, StatefulShellRoute for tabs | `lib/app/router.dart` |
| **MainShell** | Adaptive navigation: mobile bottom nav, tablet rail, desktop drawer | `lib/app/main_shell.dart` |
| **Result\<T\>** | Freezed union type — `Result.success(T)` or `Result.failure(String)` — replaces exceptions across all layers | `lib/domain/core/result.dart` |
| **UseCase\<T,P\>** | Abstract base for all use cases; returns `Future<Result<T>>` | `lib/domain/core/usecase.dart` |
| **DI Providers** | Single wiring file: Supabase → Data Sources → Repositories (no use case wiring here — providers call repos directly) | `lib/presentation/providers/di_providers.dart` |
| **SyncEngine** | Offline-first sync: push unsynced records, pull remote changes, status streaming | `lib/core/sync/sync_engine.dart` |
| **SyncController** | Riverpod keepAlive provider: manages Workmanager periodic task, connectivity listener, app-resume sync | `lib/presentation/providers/sync_provider.dart` |
| **AppDatabase** | Drift database: 4 tables, query methods, merge/upsert for sync | `lib/data/datasources/drift/database.dart` |

## Pattern Overview

**Overall:** Clean Architecture with strict inward dependency rule

**Key Characteristics:**
- **Offline-first**: Drift (SQLite) is the primary data source; Supabase is secondary sync target
- **Repository Segregation (ISP)**: 6 focused repository interfaces split by operation type, not entity
- **Result\<T\> error handling**: Never throw from repos/use cases; return typed union results
- **Code generation**: Freezed (DTOs + Result), Drift (database code), Riverpod generator (providers)
- **Adaptive UI**: Mobile-first responsive design with 3 breakpoints (mobile <600, tablet 600–900, desktop ≥900)

## Layers

### Domain Layer
- **Purpose:** Pure business logic with zero external dependencies
- **Location:** `lib/domain/`
- **Contains:** Entities (plain Dart classes), repository interfaces (abstract), use cases, enums, `Result<T>` and `UseCase` base
- **Depends on:** Nothing external — no Flutter, no Drift, no Supabase imports
- **Used by:** Presentation layer (via provider injection) and Data layer (implements interfaces)

### Data Layer
- **Purpose:** Implements domain repository interfaces using concrete data sources
- **Location:** `lib/data/`
- **Contains:** Repository implementations (`*_impl.dart`), data source interfaces + implementations, Freezed DTOs, Drift database definition
- **Depends on:** Domain layer (implements interfaces), Drift, Supabase Flutter
- **Used by:** Presentation layer (via DI providers only — never imported directly by pages/widgets)

### Presentation Layer
- **Purpose:** UI rendering, user interaction, state management
- **Location:** `lib/presentation/`
- **Contains:** Pages (full screens), widgets (reusable components), Riverpod providers, Freezed state unions, mock data
- **Depends on:** Domain layer (entities, repository interfaces, use cases via DI)
- **Used by:** Application shell (`lib/app/`)

### Core Layer
- **Purpose:** Shared cross-cutting infrastructure
- **Location:** `lib/core/`
- **Contains:** Constants, error types, extensions, logger, connectivity checker, sync engine, utilities
- **Depends on:** Drift (sync engine), Supabase (sync engine), connectivity_plus, logger
- **Used by:** All layers

### Application Shell
- **Purpose:** App configuration, routing, theming
- **Location:** `lib/app/`
- **Contains:** MaterialApp setup, GoRouter config, adaptive shell, theme tokens
- **Depends on:** Presentation layer (pages, providers), GoRouter, Riverpod
- **Used by:** `main.dart`

## Data Flow

### Primary Request Path (Read Trade List)

1. User navigates to Trades tab → `TradeListPage` (`lib/presentation/pages/trade_list_page.dart`)
2. Page watches `tradeListProvider` (`lib/presentation/providers/trade_provider.dart:14`)
3. Provider's `build()` calls `ref.watch(tradeQueryRepositoryProvider)` → gets `TradeQueryRepositoryImpl`
4. Repo calls `_localDataSource.queryClosedPositions()` (`lib/data/repositories/trade_query_repository_impl.dart:30`)
5. Local data source queries Drift database (`lib/data/datasources/drift/database.dart:150`)
6. Raw maps → `ClosedPositionDto.fromJson()` → `dto.toEntity()` → returns `Result.success(entities)`
7. Provider unwraps with `result.getOrElse([])`

### Write Path (Add Trade)

1. User submits form → `AddTradePage` (`lib/presentation/pages/add_trade_page.dart`)
2. Calls `ref.read(addClosedPositionProvider)(position)` (`lib/presentation/providers/trade_provider.dart:110`)
3. Provider calls `ref.read(tradeCommandRepositoryProvider)` → `TradeCommandRepositoryImpl`
4. Repo inserts into Drift (local-first) with `isSynced = false`
5. Provider invalidates `tradeListProvider` → UI rebuilds
6. Background: `SyncEngine.pushUnsyncedRecords()` picks up unsynced records when online

### Sync Flow

1. **App Resume:** `TradeTrackrAppState.didChangeAppLifecycleState()` → `syncOnResume()` (`lib/app/app.dart:33`)
2. **Connectivity Restore:** `SyncController._listenToConnectivity()` → `pushSync()` (`lib/presentation/providers/sync_provider.dart:78`)
3. **Periodic:** Workmanager task every 15 min → `callbackDispatcher()` (`lib/core/sync/sync_callback.dart`) → push + pull
4. **Post-Login:** `Auth.login()` → `performInitialSync()` → pull only (`lib/presentation/providers/auth_provider.dart:33`)

### Auth Redirect Flow

1. `goRouterProvider` redirect function checks `authStateProvider` and `hasCompletedOnboardingProvider` (`lib/app/router.dart:33`)
2. `RouterRefreshStream` bridges auth + onboarding state changes to GoRouter's `refreshListenable` (`lib/app/router_refresh_stream.dart`)

**State Management:**
- Riverpod with codegen (`@riverpod` annotations) — no manual `StateNotifierProvider`
- `ref.watch` for reactive UI, `ref.read` for callbacks, `ref.listen` for side effects
- KeepAlive providers: `authProvider`, `syncControllerProvider`, `syncEngineProvider`, `appDatabaseProvider`, `themeProvider`
- Auto-dispose providers: per-page data providers (trade lists, analytics, etc.)

## Key Abstractions

**Repository Segregation (ISP):**
- Purpose: Split repository interfaces by operation type so use cases depend only on what they need
- Interfaces: `lib/domain/repositories/`
  - `trade_query_repository.dart` — read operations (getTrades, getAnalytics)
  - `trade_command_repository.dart` — write operations (add, update, delete, closePosition)
  - `trade_import_repository.dart` — bulk CSV import
  - `trade_export_repository.dart` — CSV export
  - `auth_repository.dart` — authentication (signIn, signUp, signOut, authStateChanges, resetPassword)
  - `user_profile_repository.dart` — profile CRUD
- Implementations: `lib/data/repositories/` — same names with `_impl` suffix
- Pattern: Each use case constructor-injects only the interface it needs

**Data Source Abstraction:**
- Purpose: Separate local (Drift) from remote (Supabase) data access
- `TradeLocalDataSource` — abstract interface, implemented by `TradeLocalDataSourceImpl` wrapping Drift
- `TradeRemoteDataSource` — abstract interface, implemented by `TradeRemoteDataSourceImpl` wrapping Supabase client
- `AuthRemoteDataSource` / `UserRemoteDataSource` — Supabase Auth + user table access
- Files: `lib/data/datasources/`

**DTO ↔ Entity Mapping:**
- Purpose: Translate between data layer (maps/JSON) and domain layer (type-safe entities)
- Freezed DTOs in `lib/data/models/` have `toEntity()` and `fromEntity()` factory methods
- Domain entities (`lib/domain/entities/`) are plain Dart classes — NOT Freezed — no external deps
- Example: `ClosedPositionDto.toEntity()` converts `String side` to `TradeSide` enum

## Entry Points

**Application Entry Point:**
- Location: `lib/main.dart`
- Triggers: App launch
- Responsibilities: Load `.env`, init Supabase, init Workmanager, set up global error handling, wrap app in `ProviderScope`

**Router Entry Point:**
- Location: `lib/app/router.dart`
- Triggers: GoRouter provider instantiation
- Responsibilities: Define all routes, auth/onboarding redirect logic, `StatefulShellRoute` for 4 tabs

**Sync Entry Points:**
- Location: `lib/core/sync/sync_callback.dart` (background), `lib/presentation/providers/sync_provider.dart` (foreground)
- Triggers: Workmanager periodic task, connectivity change, app resume, post-login
- Responsibilities: Push unsynced records, pull remote changes, manage sync status

## Architectural Constraints

- **Threading:** Single-threaded Dart event loop. Sync engine runs async operations on main isolate. Workmanager provides separate execution context for background sync tasks.
- **Global state:** `Supabase.instance.client` singleton accessed globally via `ref.watch(supabaseClientProvider)`. `AppDatabase` singleton via `appDatabaseProvider`. Both keepAlive.
- **Circular imports:** None detected. Clean Architecture's inward dependency rule prevents cycles. The only cross-layer import is `di_providers.dart` which bridges presentation ↔ data (by design).
- **Dependency injection:** All DI wiring centralized in `lib/presentation/providers/di_providers.dart`. Single file chains: Supabase client → data sources → repositories. Use cases are NOT wired in DI — providers call repositories directly.
- **Code generation required:** After editing Freezed classes, Drift tables, or `@riverpod` annotations, must run `dart run build_runner build --delete-conflicting-outputs`. Generated files (`.freezed.dart`, `.g.dart`) are gitignored.

## Anti-Patterns

### Providers Bypass Use Cases

**What happens:** `trade_provider.dart` calls repository interfaces directly instead of going through use cases (e.g., `AddTradeUseCase`). The DI providers don't wire use cases.
**Why it's wrong:** Use cases contain business validation (e.g., `AddTradeUseCase` validates closeTime > openTime, volume > 0). Bypassing them means validation is skipped.
**Do this instead:** Wire use cases in `di_providers.dart` and have providers call use case `call()` method. Or remove use cases if they're not being used (current de facto state).

### Analytics Computed in Repository Implementation

**What happens:** `TradeQueryRepositoryImpl._computeAnalytics()` at `lib/data/repositories/trade_query_repository_impl.dart:127` contains business logic (win rate, profit factor, consecutive losses).
**Why it's wrong:** Business logic belongs in the domain layer (use case or entity), not in data layer implementation.
**Do this instead:** Move analytics computation to a domain use case `GetTradeAnalyticsUseCase` or a domain service.

### Direct Supabase Access in Providers

**What happens:** `trade_provider.dart:32` and `sync_engine.dart:49` access `Supabase.instance.client.auth.currentUser` directly instead of going through `authProvider`.
**Why it's wrong:** Couples presentation/data layers to a concrete Supabase API, making testing harder.
**Do this instead:** Accept `userId` as a parameter from the caller (which gets it from `authProvider`).

## Error Handling

**Strategy:** `Result<T>` Freezed union type — never throw from repositories or use cases.

**Patterns:**
- Repository methods wrap all operations in try-catch, returning `Result.success(data)` or `Result.failure('message: $e')`
- Providers check `result.isSuccess` or use `result.getOrElse(default)` to unwrap
- UI code throws `Exception(result.error)` from providers to surface in SnackBars (anti-pattern — should propagate Result to UI)
- Global error handlers in `main.dart` (`FlutterError.onError`, `PlatformDispatcher.instance.onError`) log to `appLogger`

## Cross-Cutting Concerns

**Logging:** `logger` package via `lib/core/logger/app_logger.dart`. Global instance `appLogger` used throughout. Sync engine logs all operations.

**Validation:** Business validation in use cases (e.g., `AddTradeUseCase` at `lib/domain/usecases/add_trade.dart`). Form validation in page widgets using Flutter `FormField` validators.

**Authentication:** Supabase Auth via `AuthRepository` interface. `AuthProvider` (keepAlive) watches auth state stream. GoRouter redirect handles protected routes. RLS policies on Supabase (migration 005).

**Responsive Design:** `ContextExtensions` at `lib/core/extensions/context_extensions.dart` provides breakpoint helpers (`isMobile`, `isTablet`, `isDesktop`). Responsive widget utilities in `lib/presentation/widgets/responsive/`. Adaptive navigation in `MainShell`.

**Connectivity:** `ConnectivityChecker` at `lib/core/network/connectivity_checker.dart` wraps `connectivity_plus`. Stream-based change detection used by `SyncController`.

---

*Architecture analysis: 2026-05-04*
