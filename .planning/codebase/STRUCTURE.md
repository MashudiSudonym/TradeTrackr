# Codebase Structure

**Analysis Date:** 2026-05-04

## Directory Layout

```
TradeTrackr/
├── lib/                          # Application source code
│   ├── main.dart                 # Entry point (env, Supabase, Workmanager init)
│   ├── app/                      # Application shell (router, theme, shell)
│   │   ├── app.dart              # MaterialApp.router + lifecycle observation
│   │   ├── app.g.dart            # Generated Riverpod provider
│   │   ├── router.dart           # GoRouter config with auth/onboarding redirect
│   │   ├── router_refresh_stream.dart  # Bridges auth state to GoRouter
│   │   ├── main_shell.dart       # Adaptive navigation shell (bottom nav / rail / drawer)
│   │   └── theme/                # Design system tokens
│   │       ├── app_colors.dart   # Color palette (Crimson Heart, Charcoal Ink, etc.)
│   │       ├── app_component_themes.dart  # Widget theme data
│   │       ├── app_theme.dart    # Light/dark ThemeData factories
│   │       ├── app_typography.dart  # Manrope + Inter font config
│   │       └── theme.dart        # Barrel export
│   │
│   ├── core/                     # Cross-cutting infrastructure
│   │   ├── constants/            # App-wide constants
│   │   │   ├── app_constants.dart
│   │   │   ├── responsive_constants.dart
│   │   │   └── supabase_constants.dart  # Loads .env for Supabase URL/key
│   │   ├── errors/               # Failure/exception types
│   │   │   └── failures.dart
│   │   ├── extensions/           # Dart extension methods
│   │   │   └── context_extensions.dart  # Responsive breakpoint helpers
│   │   ├── logger/               # Logging
│   │   │   └── app_logger.dart
│   │   ├── network/              # Connectivity
│   │   │   └── connectivity_checker.dart
│   │   ├── sync/                 # Offline-first sync engine
│   │   │   ├── sync_engine.dart  # Push/pull logic
│   │   │   └── sync_callback.dart  # Workmanager callback dispatcher
│   │   └── utils/                # Utility functions
│   │       ├── date_utils.dart
│   │       ├── string_utils.dart
│   │       └── utils.dart        # Barrel export
│   │
│   ├── domain/                   # Domain layer (pure Dart, zero external deps)
│   │   ├── core/                 # Domain abstractions
│   │   │   ├── result.dart       # Result<T> Freezed union (success/failure)
│   │   │   ├── result.freezed.dart  # Generated
│   │   │   └── usecase.dart      # UseCase<T, P> abstract base + NoParams
│   │   ├── entities/             # Business entities (plain Dart classes, NOT Freezed)
│   │   │   ├── closed_position.dart
│   │   │   ├── open_position.dart
│   │   │   ├── finance_record.dart
│   │   │   ├── recommendation.dart
│   │   │   ├── trade_analytics.dart
│   │   │   ├── trade_filter.dart
│   │   │   └── user.dart
│   │   ├── enums/                # Domain enums
│   │   │   ├── trade_side.dart   # BUY, SELL
│   │   │   ├── close_reason.dart # TP, SL, USER, MANUAL
│   │   │   ├── finance_type.dart # DEPOSIT, WITHDRAWAL
│   │   │   └── severity.dart     # Recommendation severity
│   │   ├── repositories/         # Repository interfaces (abstract)
│   │   │   ├── trade_query_repository.dart
│   │   │   ├── trade_command_repository.dart
│   │   │   ├── trade_import_repository.dart
│   │   │   ├── trade_export_repository.dart
│   │   │   ├── auth_repository.dart
│   │   │   ├── user_profile_repository.dart
│   │   │   └── repositories.dart  # Barrel export
│   │   └── usecases/             # Single-responsibility use cases
│   │       ├── add_trade.dart
│   │       ├── update_trade.dart
│   │       ├── delete_trade.dart
│   │       ├── import_trades.dart
│   │       ├── export_trades.dart
│   │       ├── get_trade_analytics.dart
│   │       ├── get_recommendations.dart
│   │       ├── sign_in.dart
│   │       ├── sign_up.dart
│   │       ├── sign_out.dart
│   │       ├── update_profile.dart
│   │       └── usecases.dart      # Barrel export
│   │
│   ├── data/                     # Data layer (implements domain interfaces)
│   │   ├── datasources/          # Data source interfaces + implementations
│   │   │   ├── drift/            # Drift (SQLite) database
│   │   │   │   ├── database.dart     # 4 tables + AppDatabase class
│   │   │   │   └── database.g.dart   # Generated Drift code
│   │   │   ├── trade_local_data_source.dart       # Interface
│   │   │   ├── trade_local_data_source_impl.dart  # Drift implementation
│   │   │   ├── trade_remote_data_source.dart      # Interface
│   │   │   ├── trade_remote_data_source_impl.dart # Supabase implementation
│   │   │   ├── auth_remote_data_source.dart       # Interface
│   │   │   ├── auth_remote_data_source_impl.dart  # Supabase Auth
│   │   │   ├── user_remote_data_source.dart       # Interface
│   │   │   └── user_remote_data_source_impl.dart  # Supabase profiles
│   │   ├── models/               # Freezed DTOs (data transfer objects)
│   │   │   ├── trade_position_dto.dart    # ClosedPositionDto + OpenPositionDto
│   │   │   ├── finance_record_dto.dart
│   │   │   ├── import_result_dto.dart
│   │   │   ├── user_dto.dart
│   │   │   └── *.freezed.dart / *.g.dart  # Generated files
│   │   └── repositories/         # Repository implementations (_impl suffix)
│   │       ├── trade_query_repository_impl.dart
│   │       ├── trade_command_repository_impl.dart
│   │       ├── trade_import_repository_impl.dart
│   │       ├── trade_export_repository_impl.dart
│   │       ├── auth_repository_impl.dart
│   │       └── user_profile_repository_impl.dart
│   │
│   ├── presentation/             # Presentation layer (UI + state)
│   │   ├── pages/                # Full screen pages (18 files)
│   │   │   ├── pages.dart        # Barrel export
│   │   │   ├── login_page.dart
│   │   │   ├── register_page.dart
│   │   │   ├── forgot_password_page.dart
│   │   │   ├── reset_password_page.dart
│   │   │   ├── onboarding_wrapper_page.dart
│   │   │   ├── dashboard_page.dart
│   │   │   ├── trade_list_page.dart
│   │   │   ├── trade_detail_page.dart
│   │   │   ├── add_trade_page.dart
│   │   │   ├── add_finance_page.dart
│   │   │   ├── finance_page.dart
│   │   │   ├── import_export_page.dart
│   │   │   ├── recommendations_page.dart
│   │   │   ├── profile_page.dart
│   │   │   ├── profile_edit_page.dart
│   │   │   ├── change_password_page.dart
│   │   │   └── settings_page.dart
│   │   ├── widgets/              # Reusable UI components (27+ files)
│   │   │   ├── widgets.dart      # Barrel export
│   │   │   ├── charts/           # Chart widgets (7 files)
│   │   │   │   ├── chart_container.dart
│   │   │   │   ├── equity_curve_chart.dart
│   │   │   │   ├── pl_distribution_chart.dart
│   │   │   │   ├── profit_by_day_chart.dart
│   │   │   │   ├── profit_by_session_chart.dart
│   │   │   │   ├── win_loss_by_reason_chart.dart
│   │   │   │   └── win_loss_by_symbol_chart.dart
│   │   │   ├── responsive/       # Responsive layout utilities (5 files)
│   │   │   │   ├── responsive.dart        # Barrel export
│   │   │   │   ├── responsive_builder.dart
│   │   │   │   ├── responsive_center.dart
│   │   │   │   ├── responsive_grid.dart
│   │   │   │   └── responsive_padding.dart
│   │   │   ├── trade_card.dart
│   │   │   ├── open_position_card.dart
│   │   │   ├── close_position_sheet.dart
│   │   │   ├── metric_card.dart
│   │   │   ├── recommendation_card.dart
│   │   │   ├── filter_bar.dart
│   │   │   ├── analytics_filter_bar.dart
│   │   │   ├── date_range_picker.dart
│   │   │   ├── multi_select_chip.dart
│   │   │   ├── pill_toggle.dart
│   │   │   ├── side_chip.dart
│   │   │   ├── status_badge.dart
│   │   │   ├── section_label.dart
│   │   │   ├── form_field_label.dart
│   │   │   ├── pricing_row.dart
│   │   │   ├── primary_button.dart
│   │   │   ├── app_text_form_field.dart
│   │   │   ├── trade_timeline.dart
│   │   │   ├── recent_trades_list.dart
│   │   │   ├── pagination_bar.dart
│   │   │   ├── import_progress_indicator.dart
│   │   │   ├── shimmer_placeholder.dart
│   │   │   ├── theme_toggle.dart
│   │   │   ├── navigation_drawer.dart
│   │   │   ├── navigation_rail.dart
│   │   │   └── onboarding_illustrations.dart
│   │   ├── providers/            # Riverpod providers (9 + DI)
│   │   │   ├── di_providers.dart       # Central DI wiring (126 lines)
│   │   │   ├── auth_provider.dart      # Auth state + login/register/logout
│   │   │   ├── trade_provider.dart     # Trade CRUD + list providers
│   │   │   ├── analytics_provider.dart # Analytics data
│   │   │   ├── recommendation_provider.dart  # Recommendations
│   │   │   ├── import_export_provider.dart    # CSV import/export
│   │   │   ├── profile_provider.dart   # User profile
│   │   │   ├── sync_provider.dart      # Sync lifecycle controller
│   │   │   ├── onboarding_provider.dart  # Onboarding state
│   │   │   ├── theme_provider.dart     # Theme mode
│   │   │   ├── providers.dart          # Barrel export
│   │   │   └── *.g.dart                # Generated Riverpod code
│   │   ├── state/                # Freezed state unions (not providers)
│   │   │   ├── import_state.dart       # ImportState: idle/loading/success/error
│   │   │   ├── import_state.freezed.dart
│   │   │   ├── sync_status_state.dart
│   │   │   └── sync_status_state.freezed.dart
│   │   └── mock/                 # Mock/seed data for development
│   │       ├── mock_data.dart
│   │       └── chart_mock_data.dart
│   │
│   └── graphify-out/             # Knowledge graph output (generated)
│
├── supabase/                     # Supabase project configuration
│   └── migrations/               # SQL migrations (001–006)
│       ├── 001_create_profiles.sql
│       ├── 002_create_closed_positions.sql
│       ├── 003_create_open_positions.sql
│       ├── 004_create_finance_records.sql
│       ├── 005_create_rls_policies.sql
│       └── 006_create_updated_at_trigger.sql
│
├── assets/                       # Static assets
│   └── csv/                      # CSV template files
│
├── android/                      # Android platform shell
├── ios/                          # iOS platform shell
├── linux/                        # Linux platform shell
├── macos/                        # macOS platform shell
├── web/                          # Web platform shell
├── windows/                      # Windows platform shell
│
├── .planning/                    # Planning documents (GSD workflow)
│   └── codebase/                 # Codebase analysis docs
│
├── graphify-out/                 # Knowledge graph analysis
│
├── pubspec.yaml                  # Dart package manifest
├── pubspec.lock                  # Locked dependency versions
├── analysis_options.yaml         # Dart analyzer config
├── mise.toml                     # mise runtime config
├── .env                          # Environment secrets (gitignored)
├── .env.example                  # Environment template
├── .mcp.json                     # MCP server config (Supabase)
│
├── AGENTS.md                     # Agent instructions (high-signal reference)
├── CLAUDE.md                     # Full project spec
├── ARCHITECTURE.md               # Architecture reference doc
├── PRD.md                        # Product requirements
├── DESIGN.md                     # Design system specification
├── SOLID.md                      # SOLID principles guide
├── CODING_STANDARDS.md           # Coding conventions
├── FREEZED_GUIDE.md              # Freezed 3.x patterns
├── RIVERPOD_GUIDE.md             # Riverpod 3.x patterns
├── RESULT_PATTERN.md             # Result<T> usage guide
├── CSV_FORMAT_REFERENCE.md       # CSV column specs
└── README.md                     # Project readme
```

## Directory Purposes

**`lib/app/`:**
- Purpose: Application shell — routing, theming, adaptive navigation
- Contains: MaterialApp config, GoRouter definition, MainShell widget, theme tokens
- Key files: `router.dart` (all routes), `app.dart` (lifecycle + theme), `main_shell.dart` (adaptive nav)

**`lib/core/`:**
- Purpose: Shared cross-cutting infrastructure used by all layers
- Contains: Constants, error types, responsive extensions, logger, connectivity checker, sync engine, utility functions
- Key files: `sync/sync_engine.dart`, `extensions/context_extensions.dart`, `network/connectivity_checker.dart`

**`lib/domain/`:**
- Purpose: Pure business logic with zero external dependencies
- Contains: Entities, repository interfaces, use cases, enums, Result<T> and UseCase base classes
- Key files: `core/result.dart`, `core/usecase.dart`, `entities/closed_position.dart`

**`lib/data/`:**
- Purpose: Concrete implementations of domain interfaces
- Contains: Repository implementations, data source interfaces + impls, Drift database, Freezed DTOs
- Key files: `datasources/drift/database.dart`, `repositories/trade_query_repository_impl.dart`, `models/trade_position_dto.dart`

**`lib/presentation/`:**
- Purpose: UI rendering and state management
- Contains: Pages (18), widgets (27+), Riverpod providers (9 + DI), Freezed state unions, mock data
- Key files: `providers/di_providers.dart`, `providers/auth_provider.dart`, `providers/trade_provider.dart`

**`supabase/migrations/`:**
- Purpose: SQL migrations applied to the Supabase Postgres database
- Contains: 6 migration files (profiles, closed/open positions, finance records, RLS policies, updated_at triggers)

## Key File Locations

**Entry Points:**
- `lib/main.dart`: Application bootstrap
- `lib/app/app.dart`: Root widget with lifecycle observation

**Routing:**
- `lib/app/router.dart`: All GoRouter routes and auth/onboarding redirect logic
- `lib/app/router_refresh_stream.dart`: Bridges Riverpod state changes to GoRouter refresh

**Configuration:**
- `pubspec.yaml`: Package manifest (SDK ^3.11.3, 30+ dependencies)
- `analysis_options.yaml`: Dart analyzer/lint rules
- `.env`: Environment variables (gitignored — contains `SUPABASE_URL`, `SUPABASE_ANON_KEY`)
- `.mcp.json`: MCP server config for Supabase project access
- `mise.toml`: Runtime version management

**Core Logic:**
- `lib/domain/core/result.dart`: Result<T> Freezed union — used everywhere
- `lib/domain/core/usecase.dart`: UseCase<T,P> abstract base
- `lib/data/datasources/drift/database.dart`: Drift database (4 tables, all queries)
- `lib/core/sync/sync_engine.dart`: Offline-first sync push/pull
- `lib/presentation/providers/di_providers.dart`: Central DI wiring (126 lines)

**Domain Entities:**
- `lib/domain/entities/closed_position.dart`: Closed trade with computed properties (isWin, pips, riskRewardRatio)
- `lib/domain/entities/open_position.dart`: Active trade
- `lib/domain/entities/trade_analytics.dart`: Computed analytics (winRate, profitFactor, etc.)
- `lib/domain/entities/trade_filter.dart`: Filter parameters for queries

**Design System:**
- `lib/app/theme/app_colors.dart`: Color palette (Crimson Heart #be0038, Charcoal Ink #2d3435, etc.)
- `lib/app/theme/app_typography.dart`: Manrope (headlines) + Inter (body) fonts
- `lib/app/theme/app_theme.dart`: Light/dark ThemeData factories

**Testing:**
- No `test/` directory exists yet

## Naming Conventions

**Files:**
- Pages: `snake_case_page.dart` → `dashboard_page.dart`, `trade_list_page.dart`
- Widgets: `snake_case.dart` → `trade_card.dart`, `metric_card.dart`
- Providers: `snake_case_provider.dart` → `trade_provider.dart`, `auth_provider.dart`
- Entities: `snake_case.dart` → `closed_position.dart`, `trade_analytics.dart`
- Repository interfaces: `noun_repository.dart` → `trade_query_repository.dart`
- Repository implementations: `noun_repository_impl.dart` → `trade_query_repository_impl.dart`
- DTOs: `noun_dto.dart` → `trade_position_dto.dart`
- Use cases: `verb_noun.dart` → `add_trade.dart`, `get_trade_analytics.dart`
- Enums: `snake_case.dart` → `trade_side.dart`, `close_reason.dart`
- State unions: `noun_state.dart` → `import_state.dart`
- Barrel exports: plural noun → `repositories.dart`, `usecases.dart`, `widgets.dart`, `pages.dart`
- Generated files: `.freezed.dart` (Freezed), `.g.dart` (Drift/JSON/Riverpod)

**Directories:**
- Layers: singular noun → `domain/`, `data/`, `presentation/`, `core/`, `app/`
- Sub-directories: plural noun → `entities/`, `repositories/`, `usecases/`, `pages/`, `widgets/`, `providers/`

## Where to Add New Code

**New Feature (e.g., "Notes on Trades"):**
- Entity: `lib/domain/entities/trade_note.dart`
- Repository interface: `lib/domain/repositories/trade_note_repository.dart` (add to barrel `repositories.dart`)
- Use cases: `lib/domain/usecases/add_trade_note.dart`, `lib/domain/usecases/get_trade_notes.dart`
- DTO: `lib/data/models/trade_note_dto.dart`
- Data source methods: Add to `lib/data/datasources/trade_local_data_source.dart` + impl
- Repository impl: `lib/data/repositories/trade_note_repository_impl.dart`
- Drift table: Add to `lib/data/datasources/drift/database.dart`, rerun build_runner
- Provider: `lib/presentation/providers/trade_note_provider.dart`
- Page: `lib/presentation/pages/trade_notes_page.dart` (add to barrel `pages.dart`)
- Widget: `lib/presentation/widgets/trade_note_card.dart` (add to barrel `widgets.dart`)
- DI wiring: Add data source + repo providers to `lib/presentation/providers/di_providers.dart`
- Route: Add to `lib/app/router.dart`

**New Chart Widget:**
- Implementation: `lib/presentation/widgets/charts/new_chart.dart`
- Export: Add to `lib/presentation/widgets/charts/` (auto-exported by `widgets.dart` if chart)

**New Repository Interface:**
- Interface: `lib/domain/repositories/new_repository.dart`
- Implementation: `lib/data/repositories/new_repository_impl.dart`
- DI wiring: Add provider to `lib/presentation/providers/di_providers.dart`
- Barrel: Add export to `lib/domain/repositories/repositories.dart`

**New Drift Table:**
- Table definition: Add class to `lib/data/datasources/drift/database.dart`
- Add to `@DriftDatabase(tables: [...])` annotation
- Add query methods to `AppDatabase` class
- Run `dart run build_runner build --delete-conflicting-outputs`
- Create Supabase migration: `supabase/migrations/007_*.sql`

**New Page:**
- Implementation: `lib/presentation/pages/new_page.dart`
- Export: Add to `lib/presentation/pages/pages.dart`
- Route: Add to `lib/app/router.dart`

**New Provider:**
- Implementation: `lib/presentation/providers/new_provider.dart`
- Use `@riverpod` annotation, run build_runner
- Export: Add to `lib/presentation/providers/providers.dart`

**Utility Function:**
- Shared helpers: `lib/core/utils/new_utils.dart`
- Add to barrel: `lib/core/utils/utils.dart`

## Special Directories

**`lib/data/datasources/drift/`:**
- Purpose: Drift (SQLite) ORM database definition and generated code
- Generated: `database.g.dart` (yes — must rerun build_runner after table changes)
- Committed: `database.dart` (yes), `database.g.dart` (yes)

**`lib/presentation/state/`:**
- Purpose: Freezed state unions used by providers (not providers themselves)
- Generated: `.freezed.dart` files (yes — must rerun build_runner)
- Committed: Source files (yes), generated files (yes)

**`lib/presentation/mock/`:**
- Purpose: Hardcoded mock data for development and chart previews
- Generated: No
- Committed: Yes

**`lib/presentation/widgets/charts/`:**
- Purpose: Chart widgets using fl_chart library (equity curve, P/L distribution, etc.)
- Generated: No
- Committed: Yes

**`lib/presentation/widgets/responsive/`:**
- Purpose: Responsive layout utilities (ResponsiveBuilder, ResponsiveCenter, ResponsiveGrid)
- Generated: No
- Committed: Yes

**`supabase/migrations/`:**
- Purpose: SQL migrations applied to Supabase Postgres database
- Generated: No (hand-written SQL)
- Committed: Yes

**`graphify-out/`:**
- Purpose: Knowledge graph analysis output (94 communities, 1471 nodes)
- Generated: Yes (by `/graphify` command)
- Committed: Yes

**`.planning/codebase/`:**
- Purpose: GSD codebase analysis documents (this file)
- Generated: Yes (by `/gsd-map-codebase` command)
- Committed: Yes

**Generated file extensions (all must rerun build_runner):**
| Extension | Tool | Location pattern |
|-----------|------|-----------------|
| `.freezed.dart` | Freezed | Next to source file |
| `.g.dart` | Drift / JSON / Riverpod | Next to source file |

---

*Structure analysis: 2026-05-04*
