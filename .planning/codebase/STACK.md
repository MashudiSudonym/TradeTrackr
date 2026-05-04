# Technology Stack

**Analysis Date:** 2026-05-04

## Languages

**Primary:**
- Dart 3.11.5 (SDK `^3.11.3`) — All application logic, UI, domain, and data layers

**Secondary:**
- SQL — Supabase/PostgreSQL migrations in `supabase/migrations/`
- Kotlin/Java — Android platform shell (`android/`)
- Swift/Objective-C — iOS/macOS platform shell (`ios/`, `macos/`)
- C/C++ — Linux/Windows platform shell (`linux/`, `windows/`)

## Runtime

**Environment:**
- Flutter 3.41.9 (stable channel)
- Dart SDK 3.11.5
- DevTools 2.54.2

**Package Manager:**
- Pub (via Flutter SDK)
- Lockfile: `pubspec.lock` (present, committed)

**Toolchain Manager:**
- mise (`mise.toml` — `flutter = "latest"`)

## Frameworks

**Core:**
- Flutter 3.41.9 — Cross-platform UI framework (Android, iOS, Linux, macOS, Windows, Web)
- `flutter_riverpod` ^3.3.1 — State management (code-generated providers via `riverpod_annotation` ^4.0.2)
- `go_router` ^14.8.1 — Declarative routing with auth guards and nested shell navigation

**Database:**
- `drift` ^2.22.1 + `drift_flutter` ^0.2.4 — Type-safe SQLite ORM (offline-first local DB)
- `drift_dev` ^2.22.1 — Code generation for Drift tables and queries

**Code Generation:**
- `build_runner` ^2.4.13 — Orchestrates all codegen
- `freezed` ^3.2.5 + `freezed_annotation` ^3.1.0 — Immutable data classes and union types (`Result<T>`, DTOs, state)
- `riverpod_generator` ^4.0.3 — `@riverpod` annotation → provider codegen
- `json_serializable` ^6.8.0 + `json_annotation` ^4.9.0 — JSON serialization for DTOs

**Testing:**
- `flutter_test` (SDK) — Test runner
- `mockito` ^5.4.5 — Mock generation for unit tests

**Linting:**
- `flutter_lints` ^6.0.0 — Lint rules (configured in `analysis_options.yaml`)

## Key Dependencies

**Critical:**
- `supabase_flutter` ^2.8.5 — Backend-as-a-Service (auth, PostgreSQL database, RLS)
- `drift` ^2.22.1 — Primary data store (offline-first, SQLite via `drift_flutter`)
- `flutter_riverpod` ^3.3.1 — Dependency injection and reactive state management
- `freezed` ^3.2.5 — Core `Result<T>` type and all immutable DTOs/state classes
- `go_router` ^14.8.1 — Navigation with auth redirect and `StatefulShellRoute`

**Data Processing:**
- `csv` ^6.0.0 — CSV import/export for trade data
- `intl` ^0.20.2 — Date/number formatting (`DateFormat`, `DateUtils`)
- `uuid` ^4.5.1 — Unique ID generation for trade records

**Infrastructure:**
- `connectivity_plus` ^6.1.4 — Network status monitoring (drives sync engine)
- `workmanager` ^0.9.0 — Periodic background sync task (15-min intervals)
- `path_provider` ^2.1.5 + `path` ^1.9.1 — Filesystem paths for database and exports
- `shared_preferences` ^2.3.5 — Simple key-value storage (onboarding flag, theme preference)

**UI & Presentation:**
- `fl_chart` ^0.70.2 — Equity curve, bar charts, and data visualizations
- `google_fonts` ^6.2.1 — Manrope (headlines) and Inter (body) font families
- `file_picker` ^9.2.3 — File selection for CSV import
- `share_plus` ^10.1.4 — System share sheet for CSV export
- `flutter_dotenv` ^5.2.1 — `.env` file loading for Supabase credentials
- `logger` ^2.5.0 — Structured console logging (`PrettyPrinter`)
- `cupertino_icons` ^1.0.8 — iOS-style icons
- `fpdart` ^1.1.1 — Functional programming utilities (declared, lightweight usage)

## Configuration

**Environment:**
- `.env` file at project root (gitignored, secrets for Supabase)
- `.env.example` — Template with required var names
- Loaded via `flutter_dotenv` in `main.dart` → `SupabaseConstants.load()`

**Key env vars:**
- `SUPABASE_URL` — Project URL (`https://bheohnfxjnwdkqvftbnc.supabase.co`)
- `SUPABASE_ANON_KEY` — Public anon key (RLS-protected)

**Build:**
- `pubspec.yaml` — Dependency and asset manifest
- `analysis_options.yaml` — Lint rules, codegen exclusion patterns
- `mise.toml` — Tool version pinning

**Code Generation:**
- Three codegen tools produce generated files (excluded from analysis):
  - Freezed → `.freezed.dart`, `.g.dart` (DTOs, Result, state)
  - Drift → `.g.dart` (database table/query boilerplate)
  - Riverpod → `.g.dart` (provider implementations)
- Run: `dart run build_runner build --delete-conflicting-outputs`

**Assets:**
- `assets/csv/` — CSV template files bundled with app

## Platform Requirements

**Development:**
- Flutter SDK 3.41+ with Dart 3.11+
- `build_runner` for code generation after model/provider changes
- Supabase project with migrations applied

**Production:**
- Flutter supported platforms: Android, iOS, Linux, macOS, Windows, Web
- SQLite database via `drift_flutter` (platform-native storage)
- Supabase backend (PostgreSQL + GoTrue auth + RLS)
- Network connectivity for sync (graceful offline via local-first)

---

*Stack analysis: 2026-05-04*
