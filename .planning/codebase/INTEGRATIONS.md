# External Integrations

**Analysis Date:** 2026-05-04

## APIs & External Services

**Backend-as-a-Service:**
- Supabase — Authentication, PostgreSQL database, Row Level Security
  - SDK: `supabase_flutter` ^2.8.5
  - Client: `SupabaseClient` (initialized in `lib/main.dart`)
  - Auth: GoTrue (`_client.auth` — email/password sign-in, sign-up, password reset)
  - Database: PostgreSQL via `SupabaseClient.from()` queries
  - Project ref: `bheohnfxjnwdkqvftbnc`
  - Constants: `lib/core/constants/supabase_constants.dart`

**Supabase Tables (remote):**
- `profiles` — User profile data (id, email, display_name, timestamps)
- `closed_positions` — Completed trades with entry/exit details
- `open_positions` — Active trade positions
- `finance_records` — Deposit/withdrawal transactions
  - All tables protected by RLS policies (`auth.uid() = user_id`)
  - Schema defined in `supabase/migrations/001–004`

## Data Storage

**Databases:**
- **Local: SQLite via Drift** (offline-first primary store)
  - ORM: `drift` ^2.22.1 + `drift_flutter` ^0.2.4
  - Database file: `tradetrackr` (platform-specific path via `driftDatabase()`)
  - Definition: `lib/data/datasources/drift/database.dart`
  - 4 tables: `ClosedPositions`, `OpenPositions`, `FinanceRecords`, `Profiles`
  - In-memory option for tests: `AppDatabase(NativeDatabase.memory())`
  - Schema version: 1 (migration strategy in `database.dart`)
  - Each table has `isSynced` boolean for offline-first tracking

- **Remote: PostgreSQL via Supabase**
  - Connection: Supabase client (no direct Postgres connection)
  - Client: `TradeRemoteDataSourceImpl` (`lib/data/datasources/trade_remote_data_source_impl.dart`)
  - Operations: `select()`, `upsert()`, `delete()` on Supabase tables
  - Migrations: `supabase/migrations/001–006` (applied via Supabase dashboard/MCP)

**File Storage:**
- Local filesystem for CSV import/export
  - File picker: `file_picker` ^9.2.3
  - Share: `share_plus` ^10.1.4
  - Paths: `path_provider` ^2.1.5

**Key-Value Storage:**
- `shared_preferences` ^2.3.5 — Onboarding completion flag, theme preference
  - Used in: `lib/presentation/providers/onboarding_provider.dart`, `lib/presentation/providers/theme_provider.dart`

**Caching:**
- None (Drift database serves as the persistent cache)

## Authentication & Identity

**Auth Provider:**
- Supabase Auth (GoTrue)
  - Implementation: `lib/data/datasources/auth_remote_data_source_impl.dart`
  - Methods: `signInWithPassword`, `signUp`, `signOut`, `resetPasswordForEmail`
  - Auth state stream: `_auth.onAuthStateChange` → mapped to domain `User` entity
  - User metadata: `display_name` stored in `userMetadata`
  - Password reset: email-based deep link to `/reset-password` route

**Auth Flow:**
- Auth state exposed via `authStateProvider` (`lib/presentation/providers/auth_provider.dart`)
- Router redirect logic in `lib/app/router.dart`:
  - Unauthenticated → `/login`
  - First-time user → `/onboarding`
  - Authenticated on auth page → `/` (dashboard)
- Deep link support: `/reset-password` for password reset emails

**Session Management:**
- Supabase manages session tokens automatically via `supabase_flutter`
- Current user accessed via `Supabase.instance.client.auth.currentUser`

## Sync Engine

**Offline-First Architecture:**
- `SyncEngine` (`lib/core/sync/sync_engine.dart`) — bridges Drift ↔ Supabase
- Status stream: `SyncStatus` enum (`synced`, `pushing`, `pulling`, `pending`, `offline`, `error`)
- Push: reads `isSynced = false` records from Drift → upserts to Supabase → marks synced
- Pull: reads all user records from Supabase → merges (upsert) into Drift
- `SyncController` (`lib/presentation/providers/sync_provider.dart`) manages lifecycle:
  - Initial sync after login (pull only)
  - Connectivity-triggered push (when coming online)
  - App-resume sync (push + pull on `AppLifecycleState.resumed`)
  - Periodic background sync via Workmanager (15-min intervals)

## Monitoring & Observability

**Error Tracking:**
- None (no Sentry, Crashlytics, or similar)

**Logs:**
- `logger` ^2.5.0 with `PrettyPrinter`
  - Instance: `appLogger` (`lib/core/logger/app_logger.dart`)
  - `DevelopmentFilter` suppresses all output in release/profile builds
  - Failure-aware logging: `logFailure()` extension maps `Failure` subtypes to log levels
  - Global error handling in `main.dart` — routes `FlutterError.onError` and `PlatformDispatcher.onError` to logger

**Connectivity Monitoring:**
- `connectivity_plus` ^6.1.4 — stream of online/offline state
  - `ConnectivityChecker` (`lib/core/network/connectivity_checker.dart`)
  - Drives sync engine push triggers

## CI/CD & Deployment

**Hosting:**
- Not configured (no CI/CD pipeline detected)
- No Dockerfile, no GitHub Actions, no Fastlane

**CI Pipeline:**
- None detected

## Environment Configuration

**Required env vars:**
- `SUPABASE_URL` — Supabase project URL
- `SUPABASE_ANON_KEY` — Supabase anon/public key (RLS-protected)

**Optional env vars:**
- `SUPABASE_SERVICE_ROLE_KEY` — Server-side only (never committed)

**Secrets location:**
- `.env` file at project root (gitignored)
- `.env.example` committed as template

## Webhooks & Callbacks

**Incoming:**
- Supabase Auth deep link: password reset email → `/reset-password` route
  - Handled by GoRouter in `lib/app/router.dart`

**Outgoing:**
- None

## Background Tasks

**Workmanager:**
- `workmanager` ^0.9.0 — Periodic background sync
  - Task: `periodicSync` (15-minute intervals, requires network)
  - Callback: `callbackDispatcher` in `lib/core/sync/sync_callback.dart`
  - Creates ephemeral `ProviderContainer` for sync execution

## Design System Integration

**Fonts:**
- `google_fonts` ^6.2.1 — Manrope (headlines, 600–800 weight) and Inter (body, 400–700 weight)
  - Loaded at runtime from Google Fonts API (requires internet on first launch)

---

*Integration audit: 2026-05-04*
