# Codebase Concerns

**Analysis Date:** 2026-05-04

## Tech Debt

### Mock Data Still Wired Into Production Providers

- Issue: Three presentation-layer providers still return hardcoded mock data instead of hitting the real data layer. The repository/use-case chain exists for all of them, but providers bypass it.
- Files:
  - `lib/presentation/providers/analytics_provider.dart` (line 16: `MockData.mockAnalytics`)
  - `lib/presentation/providers/recommendation_provider.dart` (line 15: `MockData.mockRecommendations`)
  - `lib/presentation/providers/import_export_provider.dart` (line 16-31: simulated import with `Future.delayed`)
- Impact: Dashboard analytics, recommendations page, and import/export page show fake data to all users. These features are non-functional in production.
- Fix approach: Wire each provider to the corresponding repository via DI providers (`lib/presentation/providers/di_providers.dart`). Analytics → `tradeQueryRepositoryProvider.getAnalytics()`, Recommendations → `get_recommendations` use case, Import/Export → `tradeImportRepositoryProvider` / `tradeExportRepositoryProvider`.
- Priority: **High**

### Export Repository Returns Only CSV Headers (No Data)

- Issue: `TradeExportRepositoryImpl` has three methods that each return a CSV with only the header row. The `// TODO: Query actual data from data source` comments indicate these were never connected to the local data source.
- Files: `lib/data/repositories/trade_export_repository_impl.dart` (lines 16, 45, 71)
- Impact: Export functionality produces empty CSVs. Users cannot export their trade history.
- Fix approach: Inject `TradeLocalDataSource` into `TradeExportRepositoryImpl` (currently takes no dependencies — see `di_providers.dart` line 111), query real data, and serialize to CSV rows.
- Priority: **High**

### CSV Import `importFromCsv` Is a No-Op

- Issue: The generic `importFromCsv` method in `TradeImportRepositoryImpl` has a `// TODO: Detect file type and route to appropriate import` comment and always returns `ImportResult(imported: 0)`. The type-specific methods (`importClosedPositionsFromCsv`, etc.) work, but the entry point doesn't route to them.
- Files: `lib/data/repositories/trade_import_repository_impl.dart` (line 38)
- Impact: If UI calls `importFromCsv` instead of the type-specific methods, import silently succeeds with zero records.
- Fix approach: Implement file-type detection (by header column names or filename convention) and delegate to the appropriate method.
- Priority: **Medium**

### Entity-to-Map Manual Serialization (Bypasses DTOs)

- Issue: `TradeCommandRepositoryImpl` and `TradeImportRepositoryImpl` manually build `Map<String, dynamic>` from entities instead of using the Freezed DTOs (`ClosedPositionDto`, `OpenPositionDto`, `FinanceRecordDto`) that exist in `lib/data/models/`. The query repository (`TradeQueryRepositoryImpl`) correctly uses DTOs. This creates two serialization paths.
- Files:
  - `lib/data/repositories/trade_command_repository_impl.dart` (lines 24-43, 57-76, 100-117, 131-148, 233-252, 266-278)
  - `lib/data/repositories/trade_import_repository_impl.dart` (lines 322-382)
  - `lib/data/datasources/trade_local_data_source_impl.dart` (lines 212-364, also manual)
- Impact: Serialization logic duplicated in 3+ files. Any field change requires updating multiple manual maps. Type-unsafe `as String`, `as double` casts will throw at runtime if data shape changes.
- Fix approach: Consistently use `ClosedPositionDto.toEntity()` / `ClosedPositionDto.fromJson()` across all repositories and the local data source. The DTOs already exist in `lib/data/models/`.
- Priority: **Medium**

### `closePosition` Not Atomic (Data Loss Risk)

- Issue: The `closePosition` method in `TradeCommandRepositoryImpl` performs a delete of the open position followed by an insert of the closed position as two separate operations. If the app crashes between the delete and insert, the position is lost entirely.
- Files: `lib/data/repositories/trade_command_repository_impl.dart` (lines 232-253)
- Impact: Data loss if app crashes, loses connectivity, or encounters an error during the close-position flow.
- Fix approach: Wrap both operations in a Drift `transaction()` block. The local data source already has `transaction()` support via `AppDatabase`.
- Priority: **High**

### Theme Preference Not Persisted

- Issue: Theme provider uses `@Riverpod(keepAlive: true)` but stores theme mode only in memory. On app restart, theme resets to system default. The TODO comment acknowledges this.
- Files: `lib/presentation/providers/theme_provider.dart` (line 8: `TODO: add shared_preferences persistence`)
- Impact: Users must re-select their preferred theme every time the app restarts.
- Fix approach: Use `shared_preferences` (already a dependency via `flutter_dotenv`) to persist and restore theme mode in `build()`.
- Priority: **Medium**

### `_computeAnalytics` Returns Incomplete Data

- Issue: The analytics computation in `TradeQueryRepositoryImpl` returns zeroed fields for `accountBalance`, `totalDeposits`, `totalWithdrawals`, and `openPositions` because it only queries closed positions. These values require cross-referencing finance records and open positions.
- Files: `lib/data/repositories/trade_query_repository_impl.dart` (lines 183-196)
- Impact: Dashboard shows $0.00 balance, $0.00 deposits/withdrawals, 0 open positions — all incorrect.
- Fix approach: Extend the repository to also query `getAllFinanceRecordsByUser` and `getAllOpenPositionsByUser`, then aggregate into `TradeAnalytics`.
- Priority: **Medium**

## Known Bugs

### Trade Detail Edit and Delete Are No-Ops

- Symptoms: Tapping "Edit Trade" or the delete button on the trade detail page does nothing. No navigation, no dialog.
- Files: `lib/presentation/pages/trade_detail_page.dart` (lines 456, 482: `// TODO: Navigate to edit page` and `// TODO: Show delete confirmation`)
- Trigger: Navigate to any trade detail page and tap the Edit or Delete buttons.
- Workaround: None — users must use the trade list page for delete operations.
- Priority: **High**

### `getClosedPositionById` Ignores `userId` Parameter

- Symptoms: The `getClosedPositionById` method in `TradeQueryRepositoryImpl` accepts `userId` but passes it to `_localDataSource.getClosedPositionById(id)` which only filters by `id`, not by user. A malicious or buggy client could read another user's position if they know the ID.
- Files: `lib/data/repositories/trade_query_repository_impl.dart` (line 55), `lib/data/datasources/trade_local_data_source_impl.dart` (line 25)
- Trigger: Any call to `getClosedPositionById` with a valid ID.
- Workaround: RLS policies on Supabase prevent cross-user reads for synced data, but local SQLite has no user-level access control.
- Priority: **Medium**

## Security Considerations

### Supabase Singleton Accessed in 6 Places (Bypassing DI)

- Risk: Multiple files access `Supabase.instance.client` directly instead of going through the Riverpod `supabaseClientProvider`. This breaks the DI pattern and makes testing impossible (can't inject mocks).
- Files:
  - `lib/presentation/providers/trade_provider.dart` (lines 32, 91)
  - `lib/presentation/providers/auth_provider.dart` (line 93)
  - `lib/presentation/pages/reset_password_page.dart` (line 74)
  - `lib/core/sync/sync_engine.dart` (line 48)
- Current mitigation: RLS policies enforce user-level access. No cross-user data leaks.
- Recommendations: Replace all `Supabase.instance.client` with `ref.read(supabaseClientProvider)` in providers, and pass Supabase client via constructor injection in `SyncEngine`.
- Priority: **Medium**

### User CSV Files in Repository Root

- Risk: The project root contains user-specific CSV data files (e.g., `CLOSED_POSITIONS_100950368_1776907018055.csv`, `FINANCE_100950368_1776907018058.csv`). While these are test/sample files, the naming convention includes what appears to be a user or account ID.
- Files: Project root — `CLOSED_POSITIONS_100950368_1776907018055.csv`, `OPEN_POSITIONS_100950368_1776907018037.csv`, `FINANCE_100950368_1776907018058.csv`
- Current mitigation: `.gitignore` does not exclude these CSV files.
- Recommendations: Add `*.csv` to `.gitignore` (except template files), or move sample CSVs to `assets/csv/` which already exists.
- Priority: **Medium**

### Debug Mode Enabled in Production Supabase Init

- Risk: `main.dart` initializes Supabase with `debug: true` unconditionally. This enables verbose Supabase logging in release builds, potentially exposing auth tokens and query details in device logs.
- Files: `lib/main.dart` (line 23: `debug: true`)
- Current mitigation: Supabase debug logs only appear in debug console, not in UI.
- Recommendations: Gate behind `kDebugMode`: `debug: kDebugMode`.
- Priority: **Low**

### `closePosition` Manual Map Parsing Lacks Type Safety

- Risk: The `closePosition` method in `TradeCommandRepositoryImpl` manually casts `Map<String, dynamic>` values (e.g., `openDataMap['side'] == 'BUY'` string comparison, `as num` casts). If the database schema or Drift column types change, this silently breaks.
- Files: `lib/data/repositories/trade_command_repository_impl.dart` (lines 183-200)
- Current mitigation: The Drift database definition matches expected types.
- Recommendations: Use `ClosedPositionDto.fromJson()` / `OpenPositionDto.fromJson()` for type-safe conversion.
- Priority: **Low**

## Performance Bottlenecks

### Sync Engine Pushes Records One-At-A-Time

- Problem: `SyncEngine.pushUnsyncedRecords()` iterates unsynced records and calls `_remoteSource.upsertClosedPosition(data)` in a sequential loop. For a user with 100+ unsynced trades, this creates 100+ sequential HTTP requests.
- Files: `lib/core/sync/sync_engine.dart` (lines 72-90)
- Cause: No batch upsert endpoint used. Each record is pushed individually.
- Improvement path: Use Supabase's `upsert` with a list of records (batch), or at minimum use `Future.wait` with controlled concurrency (e.g., 10 at a time).
- Priority: **Medium**

### `getUnsyncedCount` Loads All Records Into Memory

- Problem: `SyncEngine.getUnsyncedCount()` fetches all unsynced records for all three tables just to count them. For large datasets, this materializes hundreds of `Map<String, dynamic>` objects.
- Files: `lib/core/sync/sync_engine.dart` (lines 138-147)
- Cause: No `COUNT()` query available on the data source interface.
- Improvement path: Add a `countUnsynced(String userId, String table)` method to `TradeLocalDataSource` that executes a SQL `COUNT(*)` instead of `SELECT *`.
- Priority: **Low**

### Analytics Computed Client-Side on Every Query

- Problem: `TradeQueryRepositoryImpl._computeAnalytics()` loads all filtered positions into memory and iterates them multiple times (fold for total, where for wins, where for losses, map/reduce for largest). For 10,000+ trades, this is slow.
- Files: `lib/data/repositories/trade_query_repository_impl.dart` (lines 127-201)
- Cause: No pre-aggregation. Analytics are computed from raw data on every call.
- Improvement path: Cache computed analytics with invalidation on trade changes, or use SQL aggregation (Drift supports custom selects with `customSelect`).
- Priority: **Low** (acceptable for current scale, will matter at 10K+ trades)

## Fragile Areas

### DI Provider File Is a God Node (47 Edges)

- Files: `lib/presentation/providers/di_providers.dart`
- Why fragile: The graphify analysis identified this file as the #3 most-connected node with 47 edges and high betweenness centrality (0.094). Every repository, data source, and use case is wired here. A single import or wiring error breaks the entire app.
- Safe modification: Add new providers following the existing pattern (data source → repository). Never remove a provider without checking all watchers.
- Test coverage: Zero — no tests exist for DI wiring.
- Priority: **Medium**

### `TradeLocalDataSourceImpl` Has Triple Map Conversion

- Files: `lib/data/datasources/trade_local_data_source_impl.dart`
- Why fragile: Data flows through three conversion layers: Drift row → `Map<String, dynamic>` → `Map<String, dynamic>` (via repository) → DTO → Entity. Each layer manually maps fields with string keys. Any field rename breaks the chain silently at runtime.
- Safe modification: Change column names in `database.dart` → update all `_mapToXxxCompanion` and `_mapXxxToMap` methods → update repository manual maps → update DTOs. Five+ places per column.
- Test coverage: Zero.
- Priority: **Medium**

### Graph Community Cohesion Indicates Low Modularity

- Files: Multiple — graphify analysis detected 94 communities, with top communities at cohesion 0.05-0.07
- Why fragile: Community 0 (LoginPage, Dashboard, misc widgets) at cohesion 0.05 means 74 nodes are loosely related. Communities 1 (Domain Use Cases) at 0.05 and Community 3 (Equity Curve Charts) at 0.07 suggest these groups should be split into focused modules.
- Safe modification: When working in these communities, check for unintended cross-dependencies. The graph suggests `di_providers.dart` and `context_extensions.dart` are cross-community bridges that should be treated carefully.
- Priority: **Low** (architectural concern, not blocking)

## Scaling Limits

### Drift Database on Main Thread

- Current capacity: Works for thousands of records.
- Limit: Drift operations run on the main isolate by default. Large batch imports (10,000+ rows) will cause UI jank.
- Scaling path: Use Drift's `NativeDatabase.createInBackground()` or `computeWithDatabase()` for heavy operations. The database constructor at `lib/data/datasources/drift/database.dart` (line 109) currently uses `driftDatabase(name: 'tradetrackr')` which runs on the main thread.
- Priority: **Low** (current scale is fine)

### No Pagination on Position Queries

- Current capacity: All positions loaded into memory at once.
- Limit: `getAllClosedPositionsByUser()` returns every row. With 10,000+ positions, this causes slow initial load and high memory usage.
- Scaling path: Add Drift pagination (`LIMIT`/`OFFSET`) to queries. The `queryClosedPositions` method also lacks pagination.
- Priority: **Low** (current scale is fine)

## Dependencies at Risk

### `workmanager` for Background Sync

- Risk: The app uses `workmanager` for periodic background sync (`lib/core/sync/sync_callback.dart`), but this package has known limitations on iOS (background tasks are heavily throttled). Background sync may not work reliably on iOS.
- Impact: iOS users may not get automatic data sync; must open the app to trigger sync.
- Migration plan: For iOS, consider using `BGTaskScheduler` via a native plugin, or rely solely on app-lifecycle-triggered sync (already implemented in `app.dart`).
- Priority: **Low**

### `google_fonts` as a Runtime Dependency

- Risk: All typography relies on `google_fonts` which downloads fonts at runtime from Google's CDN. If the CDN is unreachable, the app falls back to system fonts, breaking the design system.
- Impact: Offline-first app may have inconsistent typography on first launch or when fonts aren't cached.
- Migration plan: Bundle Manrope and Inter fonts as assets instead of fetching at runtime.
- Priority: **Low**

## Missing Critical Features

### No Test Suite

- Problem: No `test/` directory exists. Zero unit, integration, or widget tests. The `flutter test` command will succeed but find nothing.
- What's missing: Entity tests, DTO serialization tests, repository tests (with in-memory Drift DB), provider tests, widget tests for key pages.
- Blocks: Cannot safely refactor any of the fragile areas listed above. Cannot verify bug fixes.
- Priority: **High**

### No Conflict Resolution for Sync

- Problem: `SyncEngine.pullRemoteChanges()` calls `_localSource.mergeXxx()` which does `insertOnConflictUpdate`. This silently overwrites local changes with remote data. If a user edits a trade offline and another device edits the same trade, the last-write-wins without notification.
- What's missing: Conflict detection, user-facing conflict resolution UI, or at minimum a "last write wins" log entry.
- Blocks: Multi-device usage is unsafe.
- Priority: **Medium**

### No Error Reporting / Crash Analytics

- Problem: The app uses `Logger` for local logging only. No crash reporting service (Sentry, Firebase Crashlytics, etc.) is integrated. Global error handling at `lib/main.dart` routes errors to `appLogger` only.
- What's missing: Production error reporting, crash breadcrumbs, user-facing error feedback.
- Priority: **Low** (early-stage acceptable)

## Test Coverage Gaps

### Entire Codebase Is Untested

- What's not tested: Everything — entities, DTOs, repositories, providers, widgets, sync engine, CSV parsing.
- Files: No `test/` directory exists at all.
- Risk: Any refactoring, bug fix, or feature addition could silently break existing behavior.
- Priority: **High**

### Critical Untested Paths

- **CSV Import Parsing**: `trade_import_repository_impl.dart` has complex date/number parsing with regex. Edge cases (empty fields, malformed dates, different locales) are untested.
  - Files: `lib/data/repositories/trade_import_repository_impl.dart`
  - Risk: Production CSV imports may fail silently or corrupt data.
  - Priority: **High**

- **Sync Engine Push/Pull**: No tests for partial sync failures (network error mid-push), conflict resolution, or offline/online transitions.
  - Files: `lib/core/sync/sync_engine.dart`
  - Risk: Data loss or duplication during sync.
  - Priority: **High**

- **Entity ↔ DTO Round-Trip**: The DTOs at `lib/data/models/` should round-trip (entity → DTO → JSON → DTO → entity) without data loss. Currently unverified.
  - Files: `lib/data/models/trade_position_dto.dart`, `lib/data/models/finance_record_dto.dart`, `lib/data/models/user_dto.dart`
  - Risk: Silent data corruption during serialization.
  - Priority: **High**

- **Analytics Computation**: `_computeAnalytics` at `lib/data/repositories/trade_query_repository_impl.dart` has mathematical operations (win rate, profit factor, consecutive losses) that need edge-case tests (empty list, all wins, all losses).
  - Files: `lib/data/repositories/trade_query_repository_impl.dart` (lines 127-201)
  - Risk: Incorrect analytics displayed to users.
  - Priority: **Medium**

---

*Concerns audit: 2026-05-04*
