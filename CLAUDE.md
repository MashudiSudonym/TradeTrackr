# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TradeTrackr is a cross-platform trading journal app built with Flutter. It lets traders record, analyze, and improve their trading performance through manual entry or CSV import, with an analytics dashboard and recommendation engine. The app is offline-first (Drift/SQLite) with Supabase as the remote backend.

Target user: a disciplined individual trader who records every position and wants to measure and improve performance over time.

**Project state:** Pre-scaffold — no `lib/` directory yet. Flutter project has not been created.

## Tech Stack

All packages use latest stable versions.

| Layer | Package | Purpose |
|-------|---------|---------|
| UI Framework | **Flutter** (SDK 3.x) | Cross-platform UI |
| State Management | **flutter_riverpod** | Reactive state management |
| Routing | **go_router** | Declarative routing with deep links |
| Local DB | **drift** + **drift_flutter** | Offline-first SQLite ORM |
| Remote Backend | **supabase_flutter** | Auth, remote database, API |
| Data Classes | **freezed** + **freezed_annotation** | Immutable data classes, union types |
| Charts | **fl_chart** | Dashboard charts and visualizations |
| CSV | **csv** | CSV parsing/serialization |
| Logging | **logger** | Structured logging |
| File Access | **file_picker** | Cross-platform file selection for CSV import |
| Date/Time | **intl** | Date formatting and localization utilities |
| Identity | **uuid** | Generate unique trade identifiers |
| Connectivity | **connectivity_plus** | Network status detection for sync logic |
| Filesystem | **path_provider** | Locate filesystem directories for export |
| Sharing | **share_plus** | Share exported CSV files (mobile) |

**Code generation** (via `dart run build_runner build --delete-conflicting-outputs`):
- `freezed` — immutable data classes, copyWith, equality
- `drift` — database code
- `riverpod_generator` — generated providers (code-gen Riverpod)

Supabase project ref: `bheohnfxjnwdkqvftbnc` (configured in `.mcp.json`)

## Architecture

Clean Architecture with **layer-first** directory structure. Dependency direction: **Presentation → Domain ← Data**.

```
lib/
├── app/                              # Application shell
│   ├── app.dart                      # MaterialApp with GoRouter
│   ├── router.dart                   # GoRouter configuration
│   └── theme/                        # Light and dark theme definitions
│
├── core/                             # Shared infrastructure
│   ├── constants/                    # App-wide constants
│   ├── errors/                       # Failure and exception classes
│   ├── extensions/                   # Dart extension methods
│   ├── logger/                       # Logger configuration
│   ├── network/                      # Connectivity checker
│   ├── sync/                         # Offline-first sync engine
│   └── utils/                        # Utility functions (date parsing, CSV, etc.)
│
├── domain/                           # Domain layer (pure Dart, zero external deps)
│   ├── entities/                     # Domain entities
│   │   ├── user.dart
│   │   └── trade_position.dart
│   ├── repositories/                 # Repository interfaces (abstract)
│   │   ├── trade_query_repository.dart
│   │   ├── trade_command_repository.dart
│   │   ├── trade_import_repository.dart
│   │   ├── trade_export_repository.dart
│   │   ├── auth_repository.dart
│   │   └── user_profile_repository.dart
│   ├── usecases/                     # Single-responsibility use cases
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
│   └── enums/                        # Domain enums
│       ├── trade_side.dart
│       └── close_reason.dart
│
├── data/                             # Data layer (implements domain interfaces)
│   ├── datasources/                  # Data sources (local + remote)
│   │   ├── trade_local_data_source.dart    # Drift (SQLite)
│   │   ├── trade_remote_data_source.dart   # Supabase
│   │   ├── auth_remote_data_source.dart    # Supabase Auth
│   │   └── user_remote_data_source.dart    # Supabase
│   ├── models/                       # Data transfer objects (Freezed)
│   │   ├── trade_position_dto.dart
│   │   ├── trade_analytics_dto.dart
│   │   ├── recommendation_dto.dart
│   │   └── user_dto.dart
│   └── repositories/                 # Repository implementations
│       ├── trade_query_repository_impl.dart
│       ├── trade_command_repository_impl.dart
│       ├── trade_import_repository_impl.dart
│       ├── trade_export_repository_impl.dart
│       ├── auth_repository_impl.dart
│       └── user_profile_repository_impl.dart
│
├── presentation/                     # Presentation layer (UI + state)
│   ├── pages/                        # Full screens
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
│   ├── widgets/                      # Shared/reusable widgets
│   │   ├── trade_card.dart
│   │   ├── analytics_chart.dart
│   │   ├── recommendation_card.dart
│   │   └── filter_bar.dart
│   └── providers/                    # Riverpod providers
│       ├── auth_provider.dart
│       ├── trade_provider.dart
│       ├── analytics_provider.dart
│       ├── recommendation_provider.dart
│       ├── import_export_provider.dart
│       ├── profile_provider.dart
│       └── theme_provider.dart
│
└── main.dart                         # Entry point
```

### Layer Rules

| Layer | Depends On | Contains |
|-------|-----------|----------|
| **Presentation** | Domain | Pages, widgets, Riverpod providers. Never imports data layer. |
| **Domain** | Nothing external | Pure Dart: entities, repository interfaces, use cases, enums. No framework imports. |
| **Data** | Domain | Repository implementations, data sources (Drift + Supabase), DTOs (Freezed). |

Dependency direction: **Presentation → Domain ← Data**.

### SOLID Principles (Strict)

| Principle | Application |
|-----------|-------------|
| **S** — Single Responsibility | Each class has one reason to change. Use cases encapsulate single actions. Widgets are decomposed into small, focused components. |
| **O** — Open/Closed | Extend via new implementations, not modification. Swap data sources without touching domain logic. |
| **L** — Liskov Substitution | All repository implementations are fully substitutable for their interfaces. |
| **I** — Interface Segregation | Repository interfaces split per operation type (query, command, import, export, auth, profile) — not one monolithic `TradeRepository`. |
| **D** — Dependency Inversion | Domain defines interfaces; data layer implements. Use cases receive interfaces via constructor injection. |

### Repository Segregation

Repositories split by **operation type**, not entity. Each use case injects only the interface it needs.

**Interfaces** (`domain/repositories/`):
- `trade_query_repository.dart` — read operations (getTrades, getTradeById, getAnalytics)
- `trade_command_repository.dart` — write operations (addTrade, updateTrade, deleteTrade)
- `trade_import_repository.dart` — bulk import (importFromCsv)
- `trade_export_repository.dart` — export (exportToCsv)
- `auth_repository.dart` — authentication
- `user_profile_repository.dart` — profile CRUD

**Implementations** (`data/repositories/`): same names with `_impl` suffix.

Injection examples:
- `GetTradeAnalyticsUseCase` → depends on `TradeQueryRepository`
- `AddTradeUseCase` → depends on `TradeCommandRepository`
- `ImportTradesUseCase` → depends on `TradeImportRepository`

### Offline-First Strategy

1. All writes go to Drift (local SQLite) immediately.
2. Background sync engine monitors connectivity (via `connectivity_plus`) and pushes unsynced records to Supabase.
3. All reads come from Drift for instant, offline-capable responses.
4. On login, full pull from Supabase seeds the local database.
5. Conflict resolution: last-write-wins based on `updated_at` timestamp.
6. Unsynced records (`is_synced = false`) are queued for push on connectivity restore.

## Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (Freezed, Drift, Riverpod)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs

# Run the app
flutter run

# Run all tests
flutter test

# Run a single test file
flutter test test/path/to/test.dart

# Analyze code
flutter analyze

# Run on specific platforms
flutter run -d linux
flutter run -d chrome --web-renderer canvaskit
```

## Documentation Reference Rule

**Always query MCP Context7 first** before using any package API, configuration, or pattern. Do not rely on memory or assumed knowledge — resolve the library ID via Context7, then query the specific documentation needed. This applies to all packages: Flutter, Riverpod, GoRouter, Supabase, Drift, Freezed, etc.

## Data Model

Four entities, all scoped to authenticated user via `user_id`.

### User

| Field | Type | Description |
|-------|------|-------------|
| id | `UUID` | PK (Supabase Auth user ID) |
| email | `String` | User email |
| display_name | `String` | Display name |
| created_at | `DateTime` | Account creation timestamp |
| updated_at | `DateTime` | Last update timestamp |

### ClosedPosition

| Field | Type | Notes |
|-------|------|-------|
| id | `String` | PK (UUID or imported ID) |
| user_id | `UUID` | FK to User |
| symbol | `String` | Instrument ticker (e.g., NDX100, EURUSD, BTCUSD) |
| open_time | `DateTime` | UTC |
| close_time | `DateTime` | UTC |
| volume | `double` | Lot size |
| side | `enum {BUY, SELL}` | Trade direction |
| open_price | `double` | Entry price |
| close_price | `double` | Exit price |
| stop_loss | `double?` | Nullable |
| take_profit | `double?` | Nullable |
| swap | `double` | Default 0.0 |
| commission | `double` | Default 0.0 |
| profit | `double` | Auto-calculated (user may override) |
| reason | `enum {TP, SL, User, Manual}` | Close reason |
| created_at, updated_at | `DateTime` | Timestamps |
| is_synced | `bool` | Sync flag |

### OpenPosition

Same fields as ClosedPosition except: no `close_time`, no `close_price`, no `reason`. Has `current_price` (`double?`, nullable) instead. Profit is floating P/L based on current price.

### FinanceRecord

| Field | Type | Notes |
|-------|------|-------|
| id | `String` | PK (UUID, auto-generated) |
| user_id | `UUID` | FK to User |
| type | `enum {Deposit, Withdrawal}` | Transaction type |
| time | `DateTime` | UTC |
| amount | `double` | Transaction amount |
| status | `String` | e.g., Done, Pending, Failed |
| payment_gateway | `String` | e.g., Manual, Bank Transfer |
| details | `String` | Additional details |
| created_at, updated_at | `DateTime` | Timestamps |
| is_synced | `bool` | Sync flag |

### Relationships

- User → ClosedPosition: one-to-many
- User → OpenPosition: one-to-many
- User → FinanceRecord: one-to-many
- OpenPosition → ClosedPosition: conversion (open position removed, closed position created)

### Business Rules

- `close_time` must be ≥ `open_time`
- `profit` auto-calculated from open/close/current price, side, and volume (user may override)
- All queries scoped to authenticated user

## CSV Import Formats

Reference CSV files define the import schemas:
- `CLOSED_POSITIONS_*.csv` — header: `ID,Symbol,Open Time,Volume,Side,Close Time,Open Price,Close Price,Stop Loss,Take Profit,Swap,Commission,Profit,Reason`
- `OPEN_POSITIONS_*.csv` — header: `ID,Symbol,Open Time,Volume,Side,Open Price,Current Price,Stop Loss,Take Profit,Swap,Commission,Profit`
- `FINANCE_*.csv` — header: `Type,Time,Amount,Status,Payment gateway,Details`

Date format in CSVs: `dd/MM/yyyy HH:mm:ss`. The `Total` summary row at end of file must be ignored during import.

## Design System

**Stitch project:** `4123685228949170691`
**Design system asset:** `assets/e7a43ef6e8e043d19af8b6698210b4e4`
**Design philosophy:** "Curated Ledger" aesthetic — premium stationery journal. Mood: Calm Authority. Airy, minimalist, editorial, refined.
**Device target:** Mobile-first (390×780px).

### Color Palette

#### Primary (Crimson)

| Token | Hex | Usage |
|-------|-----|-------|
| Primary | `#be0038` | CTA buttons, accent bars, active nav |
| Primary Container | `#ffdada` | Selected chip fills, tinted backgrounds |
| On Primary | `#fff6f5` | Text on primary backgrounds |
| On Primary Container | `#a60030` | Text inside primary container |
| Primary Fixed | `#840024` | Darkest primary text |
| Gradient | `#be0038` → `#a80030` at 135° | Primary button fill |

#### Success (Forest)

| Token | Hex | Usage |
|-------|-----|-------|
| Success | `#006f05` | Win/profit states, positive accent bars |
| Success Container | `#7aee68` | Light success backgrounds |
| On Success Container | `#005603` | Text inside success container |

#### Error (Brick)

| Token | Hex | Usage |
|-------|-----|-------|
| Error | `#9e422c` | Loss/danger states (**never use "Alert Red"**) |
| Error Container | `#fe8b70` | Light error backgrounds |
| On Error Container | `#742410` | Text inside error container |

#### Surface Hierarchy (tonal layering replaces shadows)

| Level | Hex | Usage |
|-------|-----|-------|
| Base | `#f9f9f9` | Page background |
| Section | `#f2f4f4` | Grouped content, card clusters |
| Surface Container | `#ebeeef` | Standard elevated blocks |
| Interactive | `#ffffff` | Active cards, focused inputs |

#### Text

| Token | Hex | Usage |
|-------|-----|-------|
| Primary Text | `#2d3435` | Headlines, key figures. **Never use `#000000`.** |
| Secondary Text | `#5a6061` | Body copy, notes, descriptions |
| Outline | `#757c7d` | Borders, dividers |
| Outline Variant | `#adb3b4` | Ghost borders (at 15% opacity) |

#### Inverse / Dark Mode

| Token | Hex | Usage |
|-------|-----|-------|
| Inverse Surface | `#0c0f0f` | Dark mode background |
| Inverse Primary | `#ff5169` | Primary on dark surfaces |
| Inverse On-Surface | `#9c9d9d` | Muted text on dark surfaces |

### Typography

**Two-font system:**
- **Manrope** — headlines, display figures, page titles. Weights 600–800.
- **Inter** — body text, labels, form inputs, chips. Weights 400–700.

| Role | Font | Weight | Size |
|------|------|--------|------|
| Display figures (P&L, balance) | Manrope | 800 (ExtraBold) | 56px |
| Page titles | Manrope | 700 (Bold) | 24px |
| Section headers | Manrope | 600 (SemiBold) | 18px |
| Body text | Inter | 400 (Regular) | 14px |
| Data labels | Inter | 500 (Medium, ALL CAPS) | 12px |
| Button text | Inter | 600 (SemiBold) | varies |

Data labels in ALL CAPS with 0.05rem letter-spacing (e.g., "ENTRY PRICE", "EXIT DATE").

### Components

#### Cards
- Corner radius: 12px
- Background: `#ffffff` on `#ebeeef` backgrounds (soft lift effect)
- **No visible borders. No drop shadows.** Depth via tonal layering only.
- Trade status accent: 4px vertical bar on left edge — `#006f05` (win) or `#9e422c` (loss).
- List separators: 16px vertical whitespace. **No divider lines.**

#### Buttons

| Type | Shape | Background | Text Color |
|------|-------|-----------|------------|
| Primary | Pill (full radius) | Gradient `#be0038` → `#a80030` at 135° | `#fff6f5` |
| Secondary | Pill | `#e4e9ea` | `#2d3435` |
| Tertiary | Text-only | None | `#be0038` Bold |

FAB shadow: Crimson Heart at 10% opacity, 32px blur, 12px Y-offset (ambient shadow reserved for floating elements only).

#### Input Fields
- Resting: background `#f2f4f4`
- Focus: background transitions to `#ffffff`, 2px Crimson Heart bottom-border animates from center outward
- Labels: Inter 500, ALL CAPS

#### Performance Chips
- Default: `#dde4e5` background, `#5a6061` text
- Selected: `#ffdada` background, `#a60030` text
- Shape: pill

#### Bottom Navigation
- Glassmorphism: `#f9f9f9` at 80% opacity, 20px backdrop blur
- Active: Crimson Heart icon with label
- Inactive: `#757c7d` icon with label
- **Icons must always have labels.**

### Layout Rules

- **No-Line Rule:** No 1px borders for sectioning. Boundaries defined by background color shifts only.
- **Ghost Border Fallback:** If container on identical-color background, use 1px `#adb3b4` at 15% opacity.
- **Whitespace:** 32px+ between major sections, 16px between list items, 16–20px horizontal padding, 16px card internal padding.
- **Alignment:** Left-align headlines/labels, right-align key data (P&L, percentages).
- **Grid:** Single-column mobile (390px), full-width with horizontal padding.

### Elevation

Traditional Material shadows (0–24dp) are **replaced by tonal layering**. Ambient shadows reserved for FABs and modals only (Crimson Heart 10%, 32px blur, 12px Y).

### Design Rules (Do's and Don'ts)

**Do:**
- Use 32px+ whitespace between major sections
- Use `#006f05` for all "Win" states
- Left-align headlines, right-align key data
- Use tonal layering for depth

**Don't:**
- Never use `#000000` — always `#2d3435`
- Never use standard Material Design elevations
- Never use icons without labels for primary navigation
- Never use "Alert Red" for errors — use `#9e422c`
- Never use 1px solid borders for sectioning — use background color shifts

## Screen Map

```
Login ──▶ Register
  │
  ▼
Dashboard (Home)
  ├── Closed Positions List (view, filter, sort)
  │     └── Position Detail
  ├── Open Positions List (view, filter, sort)
  │     └── Position Detail
  │     └── Close Position (convert to closed)
  ├── Finance History (deposits, withdrawals)
  ├── Add Position (input form — open or closed)
  ├── Import/Export
  │     ├── Import CSV (closed positions, open positions, finance)
  │     └── Export CSV (closed positions, open positions, finance)
  ├── Recommendations
  └── Settings
        ├── Theme Toggle
        ├── Profile
        ├── Change Password
        └── Sign Out
```

## Platform Support

| Platform | Minimum Version | Notes |
|----------|----------------|-------|
| Android | API 21+ (5.0) | Primary target |
| iOS | 12.0+ | Primary target |
| macOS | 10.14+ (Mojave) | Supported |
| Windows | Windows 10+ | Supported |
| Linux | Modern distros | Supported |
| Web | Latest Chrome/Firefox/Edge/Safari | Supported (Drift via sql.js or Supabase-only fallback) |

## Non-Functional Requirements

### Performance Targets

| Metric | Target |
|--------|--------|
| Dashboard load | < 500ms for up to 10,000 trades |
| CSV import (1,000 rows) | < 3 seconds |
| CSV export (10,000 rows) | < 2 seconds |
| Screen transitions | 60fps, no jank |
| Local query response | < 50ms |

### Security

- Auth: Supabase Auth with JWT tokens stored securely
- Data isolation: Row-Level Security (RLS) on Supabase — users access own data only
- Input validation: all form fields validated before persistence
- CSV sanitization: imported data sanitized before storage
- Local DB: not encrypted in v1 (deferred to v2)

### Reliability

- Full read/write offline
- No data loss during sync; failed syncs auto-retry
- Unsynced local data persists across app crashes

<!-- rtk-instructions v2 -->
# RTK (Rust Token Killer) - Token-Optimized Commands

## Golden Rule

**Always prefix commands with `rtk`**. If RTK has a dedicated filter, it uses it. If not, it passes through unchanged. This means RTK is always safe to use.

**Important**: Even in command chains with `&&`, use `rtk`:
```bash
# ❌ Wrong
git add . && git commit -m "msg" && git push

# ✅ Correct
rtk git add . && rtk git commit -m "msg" && rtk git push
```

## RTK Commands by Workflow

### Build & Compile (80-90% savings)
```bash
rtk cargo build         # Cargo build output
rtk cargo check         # Cargo check output
rtk cargo clippy        # Clippy warnings grouped by file (80%)
rtk tsc                 # TypeScript errors grouped by file/code (83%)
rtk lint                # ESLint/Biome violations grouped (84%)
rtk prettier --check    # Files needing format only (70%)
rtk next build          # Next.js build with route metrics (87%)
```

### Test (90-99% savings)
```bash
rtk cargo test          # Cargo test failures only (90%)
rtk vitest run          # Vitest failures only (99.5%)
rtk playwright test     # Playwright failures only (94%)
rtk test <cmd>          # Generic test wrapper - failures only
```

### Git (59-80% savings)
```bash
rtk git status          # Compact status
rtk git log             # Compact log (works with all git flags)
rtk git diff            # Compact diff (80%)
rtk git show            # Compact show (80%)
rtk git add             # Ultra-compact confirmations (59%)
rtk git commit          # Ultra-compact confirmations (59%)
rtk git push            # Ultra-compact confirmations
rtk git pull            # Ultra-compact confirmations
rtk git branch          # Compact branch list
rtk git fetch           # Compact fetch
rtk git stash           # Compact stash
rtk git worktree        # Compact worktree
```

Note: Git passthrough works for ALL subcommands, even those not explicitly listed.

### GitHub (26-87% savings)
```bash
rtk gh pr view <num>    # Compact PR view (87%)
rtk gh pr checks        # Compact PR checks (79%)
rtk gh run list         # Compact workflow runs (82%)
rtk gh issue list       # Compact issue list (80%)
rtk gh api              # Compact API responses (26%)
```

### JavaScript/TypeScript Tooling (70-90% savings)
```bash
rtk pnpm list           # Compact dependency tree (70%)
rtk pnpm outdated       # Compact outdated packages (80%)
rtk pnpm install        # Compact install output (90%)
rtk npm run <script>    # Compact npm script output
rtk npx <cmd>           # Compact npx command output
rtk prisma              # Prisma without ASCII art (88%)
```

### Files & Search (60-75% savings)
```bash
rtk ls <path>           # Tree format, compact (65%)
rtk read <file>         # Code reading with filtering (60%)
rtk grep <pattern>      # Search grouped by file (75%)
rtk find <pattern>      # Find grouped by directory (70%)
```

### Analysis & Debug (70-90% savings)
```bash
rtk err <cmd>           # Filter errors only from any command
rtk log <file>          # Deduplicated logs with counts
rtk json <file>         # JSON structure without values
rtk deps                # Dependency overview
rtk env                 # Environment variables compact
rtk summary <cmd>       # Smart summary of command output
rtk diff                # Ultra-compact diffs
```

### Infrastructure (85% savings)
```bash
rtk docker ps           # Compact container list
rtk docker images       # Compact image list
rtk docker logs <c>     # Deduplicated logs
rtk kubectl get         # Compact resource list
rtk kubectl logs        # Deduplicated pod logs
```

### Network (65-70% savings)
```bash
rtk curl <url>          # Compact HTTP responses (70%)
rtk wget <url>          # Compact download output (65%)
```

### Meta Commands
```bash
rtk gain                # View token savings statistics
rtk gain --history      # View command history with savings
rtk discover            # Analyze Claude Code sessions for missed RTK usage
rtk proxy <cmd>         # Run command without filtering (for debugging)
rtk init                # Add RTK instructions to CLAUDE.md
rtk init --global       # Add RTK to ~/.claude/CLAUDE.md
```

## Token Savings Overview

| Category | Commands | Typical Savings |
|----------|----------|-----------------|
| Tests | vitest, playwright, cargo test | 90-99% |
| Build | next, tsc, lint, prettier | 70-87% |
| Git | status, log, diff, add, commit | 59-80% |
| GitHub | gh pr, gh run, gh issue | 26-87% |
| Package Managers | pnpm, npm, npx | 70-90% |
| Files | ls, read, grep, find | 60-75% |
| Infrastructure | docker, kubectl | 85% |
| Network | curl, wget | 65-70% |

Overall average: **60-90% token reduction** on common development operations.
<!-- /rtk-instructions -->