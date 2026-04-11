# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TradeTrackr is a cross-platform trading journal app built with Flutter. It lets traders record, analyze, and improve their trading performance through manual entry or CSV import, with an analytics dashboard and recommendation engine. The app is offline-first (Drift/SQLite) with Supabase as the remote backend.

## Tech Stack

- **Flutter** (SDK 3.x) — cross-platform UI
- **Riverpod** (flutter_riverpod) — state management
- **GoRouter** — declarative routing
- **Drift** (drift + drift_flutter) — local SQLite ORM
- **Supabase** (supabase_flutter) — auth, remote database, API
- **Freezed** — immutable data classes with code generation
- **fl_chart** — charts and visualizations
- **csv** — CSV parsing/serialization
- **build_runner** — code generation runner

Supabase project ref: `bheohnfxjnwdkqvftbnc` (configured in `.mcp.json`)

## Architecture

Clean Architecture with **layer-first** directory structure. Dependency direction: **Presentation → Domain ← Data**.

```
lib/
├── app/          # Application shell (MaterialApp, GoRouter, theme)
├── core/         # Shared infra (constants, errors, extensions, sync engine, utils)
├── domain/       # Pure Dart — entities, repository interfaces, use cases, enums
├── data/         # Repository implementations, data sources (Drift + Supabase), DTOs
├── presentation/ # Pages, shared widgets, Riverpod providers
└── main.dart
```

**Layer rules:**
- **Domain** has zero external dependencies — no framework imports
- **Data** implements domain interfaces; handles Drift + Supabase data sources
- **Presentation** depends only on domain; never accesses data layer directly

**Repository segregation:** Repositories are split by operation type (query, command, import, export, auth, profile), not by entity. Each use case injects only the interface it needs.

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

Three core entities scoped per authenticated user:
- **ClosedPosition** — completed trades with close time, close price, reason (TP/SL/User/Manual)
- **OpenPosition** — active trades with current price; can be converted to ClosedPosition
- **FinanceRecord** — deposits/withdrawals

All entities have `user_id`, `is_synced`, `created_at`, `updated_at` fields for offline-first sync.

## CSV Import Formats

Reference CSV files define the import schemas:
- `CLOSED_POSITIONS_*.csv` — header: `ID,Symbol,Open Time,Volume,Side,Close Time,Open Price,Close Price,Stop Loss,Take Profit,Swap,Commission,Profit,Reason`
- `OPEN_POSITIONS_*.csv` — header: `ID,Symbol,Open Time,Volume,Side,Open Price,Current Price,Stop Loss,Take Profit,Swap,Commission,Profit`
- `FINANCE_*.csv` — header: `Type,Time,Amount,Status,Payment gateway,Details`

Date format in CSVs: `dd/MM/yyyy HH:mm:ss`. The `Total` summary row at end of file must be ignored during import.

## UI Design

Airbnb-inspired clean, minimal design. See PRD.md §2.9 for full design tokens (colors, typography, component styles). Key tokens:
- Primary: `#FF385C`, Success: `#008A09`/`#34C759`, Danger: `#BD1313`/`#FF453A`
- Cards: flat with 1px border, 12px corner radius, no drop shadow
- Icons: outlined style (Material Symbols)
