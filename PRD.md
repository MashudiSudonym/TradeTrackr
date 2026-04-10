# Product Requirements Document — TradeTrackr

**Version**: 1.0.0
**Date**: 2026-04-11
**Status**: Draft

---

## 1. Overview

### 1.1 Product Vision

TradeTrackr is a cross-platform trading journal application that enables traders to record, analyze, and improve their trading performance. By providing structured trade logging, visual analytics, and actionable recommendations, TradeTrackr transforms raw trade data into measurable insight.

### 1.2 Problem Statement

Traders who rely on memory or scattered spreadsheets lack a systematic way to evaluate their performance. Without structured records, it is difficult to identify recurring mistakes, measure win/loss ratios, or optimize strategies. Existing solutions are often bloated, subscription-heavy, or platform-locked.

### 1.3 Solution

TradeTrackr provides a lightweight, offline-first trading journal that runs on every major platform. Traders log each position manually or via CSV import, then review their performance through an interactive dashboard. A built-in recommendation engine surfaces patterns from historical data to help traders refine their approach.

### 1.4 Target User

A disciplined individual trader who:
- Actively trades financial instruments (indices, forex, crypto, stocks, etc.)
- Records every opened and closed position to maintain a journal
- Wants to measure and improve trading performance over time
- Prefers a self-hosted or privacy-respecting tool over cloud-only SaaS

### 1.5 Language

The application UI, documentation, and all user-facing content for v1 are in **English only**.

---

## 2. MVP Features (v1)

### 2.1 Authentication

Simple email and password authentication powered by Supabase Auth.

| Requirement | Detail |
|-------------|--------|
| Sign Up | Email + password registration with email verification |
| Sign In | Email + password login |
| Sign Out | Clear local session and navigate to login screen |
| Password Reset | Send password reset email via Supabase |
| Session Persistence | Remain signed in across app restarts using stored JWT |
| Route Guard | Unauthenticated users are redirected to the login screen |

### 2.2 User Profile

| Requirement | Detail |
|-------------|--------|
| View Profile | Display name, email, account creation date |
| Edit Profile | Update display name |
| Change Password | Form to update password (requires current password) |
| Delete Account | Request account deletion which removes all user data |

### 2.3 Trade Position Input Form

A form to manually input a closed trade position. Fields are derived from `example_trade_report.csv`.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| ID | `String` | Auto-generated | Unique trade identifier (UUID) |
| Symbol | `String` | Yes | Traded instrument ticker (e.g., NDX100, EURUSD, BTCUSD) |
| Open Time | `DateTime` | Yes | Timestamp when the position was opened |
| Close Time | `DateTime` | Yes | Timestamp when the position was closed |
| Volume | `double` | Yes | Position size / lot size |
| Side | `enum (BUY, SELL)` | Yes | Trade direction |
| Open Price | `double` | Yes | Entry price |
| Close Price | `double` | Yes | Exit price |
| Stop Loss | `double` | No | Stop loss price level |
| Take Profit | `double` | No | Take profit price level |
| Swap | `double` | No (default 0.0) | Overnight swap fee |
| Commission | `double` | No (default 0.0) | Broker commission |
| Profit | `double` | Auto-calculated | Gross profit/loss (close price − open price, adjusted for side and volume) |
| Reason | `enum (TP, SL, User, Manual)` | Yes | Reason for closing the position |

**Business rules:**
- `Close Time` must be equal to or after `Open Time`.
- `Profit` is auto-calculated from open price, close price, side, and volume. The user may override the value.
- On successful submission, the trade is saved to the local Drift database and synced to Supabase.

### 2.4 CSV Import

Import trade positions from a `.csv` file matching the format of `example_trade_report.csv`.

| Requirement | Detail |
|-------------|--------|
| File Picker | System file picker filtered to `.csv` files |
| Format | Must match: `ID,Symbol,Open Time,Volume,Side,Close Time,Open Price,Close Price,Stop Loss,Take Profit,Swap,Commission,Profit,Reason` |
| Validation | Reject rows with missing required fields, invalid types, or unrecognized Side/Reason values |
| Duplicate Handling | Skip rows whose ID already exists in the database; report count of skipped duplicates |
| Summary Report | After import, show: total rows processed, rows imported, rows skipped, rows with errors |
| Date Parsing | Support `dd/MM/yyyy HH:mm:ss` format from the CSV; auto-detect other common formats |
| Header Row | First row is treated as header; the `Total` summary row at the end is ignored |

### 2.5 CSV Export

Export stored trade positions to a `.csv` file.

| Requirement | Detail |
|-------------|--------|
| Export Scope | All trades, or a filtered subset (by date range, symbol, side, or reason) |
| File Naming | `tradetrackr_export_YYYYMMDD_HHmmss.csv` |
| Columns | Same columns as import format, in the same order |
| Platform Handling | Save to Downloads (Android), share sheet (iOS), file dialog (Desktop), download folder (Web) |

### 2.6 Analytics Dashboard

The central screen that displays computed analytics from the user's trade history.

**Summary Metrics:**

| Metric | Description |
|--------|-------------|
| Total Trades | Count of all closed positions |
| Win Rate | Percentage of trades with profit > 0 |
| Total Profit/Loss | Sum of all trade profits (net of swap and commission) |
| Average Profit per Trade | Mean profit across all trades |
| Largest Win | Highest single-trade profit |
| Largest Loss | Lowest single-trade profit |
| Profit Factor | Sum of gross profits / Sum of gross losses |
| Average Risk-Reward Ratio | Average (take profit − open price) / (open price − stop loss) for trades with both SL and TP set |
| Average Holding Duration | Mean time between open and close timestamps |

**Charts and Visualizations:**

| Chart | Description |
|-------|-------------|
| Equity Curve | Line chart of cumulative profit over time |
| Profit/Loss Distribution | Bar chart or histogram of trade profits |
| Win/Loss by Symbol | Grouped bar chart showing wins vs losses per symbol |
| Win/Loss by Reason | Pie or donut chart showing distribution of close reasons (TP, SL, User, Manual) |
| Profit by Day of Week | Bar chart of average profit grouped by weekday |
| Profit by Session | Bar chart of average profit grouped by time-of-day session (e.g., Asian, London, New York) |

**Filters:**

| Filter | Type |
|--------|------|
| Date Range | Date picker (from — to) |
| Symbol | Multi-select dropdown |
| Side | Toggle (BUY / SELL / All) |
| Reason | Multi-select dropdown |

### 2.7 Recommendation Engine

A feature that analyzes stored trade data and surfaces actionable insights.

| Recommendation | Logic |
|----------------|-------|
| Best Performing Symbol | Identify the symbol with highest total net profit (minimum 5 trades) |
| Worst Performing Symbol | Identify the symbol with lowest total net profit (minimum 5 trades) |
| Best Day to Trade | Day of week with highest average profit (minimum 5 trades on that day) |
| Worst Day to Trade | Day of week with lowest average profit (minimum 5 trades on that day) |
| Best Session | Time-of-day session with highest average profit (minimum 5 trades) |
| Avg Win vs Avg Loss | Compare average winning trade vs average losing trade; flag if avg loss > avg win |
| Consecutive Losses | Alert if currently on a streak of 3+ consecutive losses |
| Risk-Reward Alert | Flag if average risk-reward ratio falls below 1:1 |
| Win Rate Trend | Compare win rate of last 10 trades vs overall; flag if declining by >15% |
| Overtrading Alert | Flag if more than X trades are logged in a single day (configurable threshold) |

**Presentation:** Recommendations are displayed as a card list on the dashboard, each with a title, short description, and severity indicator (info, warning, critical).

### 2.8 Dark Theme

| Requirement | Detail |
|-------------|--------|
| Theme Toggle | Switch in settings or app bar to toggle between light and dark mode |
| Default | System preference (follows OS dark/light setting) |
| Persistence | User's choice is stored locally and persists across sessions |
| Full Coverage | All screens, charts, and components support both themes |

### 2.9 UI Design Style

The application follows a **clean, minimal, and highly legible** design language inspired by Airbnb's design system. The goal is to present financial data without visual clutter so traders can scan and interpret their performance at a glance.

**Design Principles:**

| Principle | Application |
|-----------|-------------|
| Clarity over decoration | Every element serves a purpose. No ornamental graphics, gradients, or visual noise. Data speaks for itself. |
| Generous whitespace | Content breathes. Screens use ample spacing between sections, cards, and data rows. |
| Content-first layout | Numbers, charts, and trade details are the focal point. Chrome and navigation recede. |
| Typographic hierarchy | Clear distinction between headings, body text, labels, and numeric data through size, weight, and color contrast. |

**Visual Tokens:**

| Token | Light Theme | Dark Theme |
|-------|-------------|------------|
| Background | `#FFFFFF` | `#121212` |
| Surface / Card | `#F7F7F7` | `#1E1E1E` |
| Primary | `#FF385C` | `#FF385C` |
| Primary Text | `#222222` | `#F5F5F5` |
| Secondary Text | `#717171` | `#A0A0A0` |
| Border / Divider | `#DDDDDD` | `#333333` |
| Success (Profit) | `#008A09` | `#34C759` |
| Danger (Loss) | `#BD1313` | `#FF453A` |

**Typography:**

| Role | Weight | Size |
|------|--------|------|
| Screen Title | Bold | 24px |
| Section Heading | Semi-bold | 18px |
| Card Title / Metric Label | Medium | 16px |
| Body Text | Regular | 14px |
| Caption / Hint | Regular | 12px |
| Numeric Data (Profit, Price) | Semi-bold / Tabular | 16px |

**Component Style:**

| Component | Style |
|-----------|-------|
| Cards | Flat with subtle 1px border, 12px corner radius, no drop shadow |
| Buttons (Primary) | Filled with primary color, 8px corner radius, bold label |
| Buttons (Secondary) | Transparent with 1px border, 8px corner radius |
| Input Fields | Underlined or filled with light surface background, no heavy borders |
| Charts | Flat colors, no 3D effects, consistent with token palette |
| Icons | Outlined style (e.g., Material Symbols — outlined variant) |
| Bottom Navigation | Minimal, icon + label, no background color fill on active tab |
| App Bar | Clean, no elevation, flat background matching screen |

---

## 3. Data Model

### 3.1 Entities

#### User

| Field | Type | Description |
|-------|------|-------------|
| id | `UUID` | Primary key (Supabase Auth user ID) |
| email | `String` | User email address |
| display_name | `String` | Display name |
| created_at | `DateTime` | Account creation timestamp |
| updated_at | `DateTime` | Last profile update timestamp |

#### TradePosition

| Field | Type | Description |
|-------|------|-------------|
| id | `String` | Primary key (UUID or imported ID) |
| user_id | `UUID` | Foreign key to User |
| symbol | `String` | Traded instrument |
| open_time | `DateTime` | Position open timestamp (UTC) |
| close_time | `DateTime` | Position close timestamp (UTC) |
| volume | `double` | Position size |
| side | `enum` | BUY or SELL |
| open_price | `double` | Entry price |
| close_price | `double` | Exit price |
| stop_loss | `double?` | Stop loss price (nullable) |
| take_profit | `double?` | Take profit price (nullable) |
| swap | `double` | Swap fee |
| commission | `double` | Broker commission |
| profit | `double` | Profit or loss amount |
| reason | `enum` | Close reason: TP, SL, User, Manual |
| created_at | `DateTime` | Record creation timestamp |
| updated_at | `DateTime` | Record last update timestamp |
| is_synced | `bool` | Whether the record has been synced to Supabase |

### 3.2 Relationships

- **User → TradePosition**: One-to-many. Each trade position belongs to one user.
- All queries on trade positions are scoped to the authenticated user.

### 3.3 Sync Strategy (Offline-First)

| Aspect | Strategy |
|--------|----------|
| Local Store | Drift (SQLite) is the primary data source |
| Remote Store | Supabase PostgreSQL is the secondary/truth source when online |
| Writes | All writes go to Drift first, then sync to Supabase when connectivity is available |
| Reads | Always read from Drift for instant response |
| Conflict Resolution | Last-write-wins based on `updated_at` timestamp |
| Sync Queue | Unsynced records (`is_synced = false`) are pushed to Supabase on connectivity restore |
| Initial Sync | On first login, pull all user's trade data from Supabase into Drift |

---

## 4. Tech Stack

All packages must use the **latest stable versions** as of the project start date.

| Layer | Technology | Purpose |
|-------|-----------|---------|
| UI Framework | **Flutter** (SDK 3.x, latest stable) | Cross-platform UI toolkit |
| State Management | **Riverpod** (flutter_riverpod) | Reactive state management with code-gen support |
| Routing | **GoRouter** | Declarative routing with deep link support |
| Backend / Auth | **Supabase** (supabase_flutter) | Authentication, remote database, and API |
| Local Database | **Drift** (drift + drift_flutter) | Offline-first SQLite ORM |
| Data Classes | **Freezed** (freezed + freezed_annotation) | Immutable data classes with union types |
| Logging | **Logger** | Structured logging for debugging |
| CSV Parsing | **csv** | Parse and serialize CSV files |
| Charts | **fl_chart** | Rendering dashboard charts and graphs |
| File Picking | **file_picker** | Cross-platform file selection for CSV import |
| DateTime | **intl** | Date formatting and localization utilities |
| UUID | **uuid** | Generate unique trade identifiers |
| Connectivity | **connectivity_plus** | Detect network status for sync logic |
| Path | **path_provider** | Locate filesystem directories for export |
| Sharing | **share_plus** | Share exported CSV files (mobile) |

### Code Generation

The project uses build_runner for code generation:
- `freezed` — generates immutable data classes, copyWith, equality
- `drift` — generates database code
- `riverpod_generator` — generates providers (optional, if using code-gen Riverpod)

### Documentation Reference Rule

**MCP Context7 is the primary and mandatory reference** for all tech stack documentation during development. Before using any API, package, or framework pattern, developers must consult Context7 to ensure accuracy with the latest versions.

| Rule | Detail |
|------|--------|
| Primary Source | Always query MCP Context7 first when looking up documentation for any package or framework listed in the tech stack |
| Coverage | Applies to all technologies: Flutter, Riverpod, GoRouter, Supabase, Drift, Freezed, and all supporting packages |
| Purpose | Ensures code uses current APIs and avoids deprecated patterns from outdated training data |
| When to Use | Before writing any implementation involving a package API, configuration, migration guide, or setup pattern |
| Workflow | Resolve the library ID via Context7, then query the specific documentation needed — do not rely on memory or assumed knowledge |

---

## 5. Architecture

### 5.1 Clean Architecture — Layer-First Structure

The project follows **Clean Architecture** with a **layer-first** directory organization. Top-level directories represent architectural layers; features are organized as files within each layer. This ensures strict dependency enforcement at the folder level and makes the layer boundaries immediately visible.

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

### 5.2 Layer Rules

| Layer | Depends On | Description |
|-------|-----------|-------------|
| **Presentation** | Domain | UI, widgets, Riverpod providers. No direct data layer access. |
| **Domain** | Nothing | Pure Dart: entities, repository interfaces, use cases. No framework imports. |
| **Data** | Domain | Repository implementations, data sources, DTOs. Implements domain interfaces. |

Dependency direction: **Presentation → Domain ← Data**. The domain layer has zero external dependencies.

### 5.3 SOLID Principles (Strict Enforcement)

| Principle | Application |
|-----------|-------------|
| **S** — Single Responsibility | Each class has exactly one reason to change. Use cases encapsulate single actions. Widgets are decomposed into small, focused components. |
| **O** — Open/Closed | Entities and use cases are extended via new implementations, not modified. Repository interfaces allow swapping data sources without touching domain logic. |
| **L** — Liskov Substitution | All repository implementations are fully substitutable for their interfaces. Mock repositories pass the same contract tests as real ones. |
| **I** — Interface Segregation | Repository interfaces are split per feature (e.g., `TradeQueryRepository`, `TradeCommandRepository`) rather than one monolithic `TradeRepository`. |
| **D** — Dependency Inversion | Domain defines repository interfaces; data layer provides implementations. Use cases receive repository interfaces via constructor injection, not concrete classes. |

### 5.4 Repository Segregation Pattern

Repositories are split by **operation type**, not by entity. This ensures each use case depends only on the operations it needs. Interface definitions live in `domain/repositories/`; implementations live in `data/repositories/`.

**Interfaces** (`domain/repositories/`):

```
domain/repositories/
├── trade_query_repository.dart        # Read operations (getTrades, getTradeById, getAnalytics)
├── trade_command_repository.dart      # Write operations (addTrade, updateTrade, deleteTrade)
├── trade_import_repository.dart       # Bulk import operations (importFromCsv)
├── trade_export_repository.dart       # Export operations (exportToCsv)
├── auth_repository.dart               # Authentication operations
└── user_profile_repository.dart       # User profile CRUD
```

**Implementations** (`data/repositories/`):

```
data/repositories/
├── trade_query_repository_impl.dart
├── trade_command_repository_impl.dart
├── trade_import_repository_impl.dart
├── trade_export_repository_impl.dart
├── auth_repository_impl.dart
└── user_profile_repository_impl.dart
```

Each use case injects only the repository interface it requires:

```
GetTradeAnalyticsUseCase → depends on TradeQueryRepository (domain interface)
AddTradeUseCase → depends on TradeCommandRepository (domain interface)
ImportTradesUseCase → depends on TradeImportRepository (domain interface)
```

### 5.5 Offline-First Strategy

```
┌─────────────┐       ┌─────────────┐       ┌─────────────┐
│  Presentation│──────▶│   Domain    │◀──────│    Data     │
│  (Riverpod)  │       │  (Use Cases)│       │ (Drift +    │
│              │       │             │       │  Supabase)  │
└─────────────┘       └─────────────┘       └──────┬──────┘
                                                     │
                                              ┌──────▼──────┐
                                              │  Sync Engine │
                                              │ (background) │
                                              └─────────────┘
```

1. **All writes** go to Drift (local SQLite) immediately.
2. A background sync engine monitors connectivity and pushes unsynced records to Supabase.
3. **All reads** come from Drift for instant, offline-capable responses.
4. On login, a full pull from Supabase seeds the local database.
5. Sync status is surfaced in the UI (synced / pending / offline).

---

## 6. Platform Support

| Platform | Minimum Version | Notes |
|----------|----------------|-------|
| Android | API 21+ (Android 5.0) | Primary target |
| iOS | 12.0+ | Primary target |
| macOS | 10.14+ (Mojave) | Supported |
| Windows | Windows 10+ | Supported |
| Linux | Any modern distro | Supported |
| Web | Latest Chrome, Firefox, Edge, Safari | Supported (no Drift — Supabase-only fallback) |

**Web caveat:** Drift supports Web via `sql.js` or `wa` (WASM). If full offline is required on Web, use Drift's Web support; otherwise, fall back to Supabase-only mode.

---

## 7. Non-Functional Requirements

### 7.1 Performance

| Requirement | Target |
|-------------|--------|
| Dashboard load time | < 500ms for up to 10,000 trades |
| CSV import (1,000 rows) | < 3 seconds |
| CSV export (10,000 rows) | < 2 seconds |
| Screen transition | 60fps, no jank |
| Local query response | < 50ms |

### 7.2 Security

| Requirement | Detail |
|-------------|--------|
| Authentication | Handled by Supabase Auth; JWT tokens stored securely |
| Data Isolation | Row-Level Security (RLS) on Supabase ensures users can only access their own data |
| Local Encryption | Drift database is not encrypted in v1 (deferred to v2) |
| Input Validation | All form fields validated before persistence |
| CSV Sanitization | Imported CSV data is sanitized and validated before storage |

### 7.3 Reliability

| Requirement | Detail |
|-------------|--------|
| Offline Operation | Full read/write capability without internet |
| Data Integrity | No data loss during sync; failed syncs are retried automatically |
| Crash Recovery | Unsynced local data persists across app crashes |

### 7.4 Usability

| Requirement | Detail |
|-------------|--------|
| Responsive Layout | Adapts to phone, tablet, and desktop form factors |
| Accessibility | Minimum contrast ratios, semantic labels for screen readers |
| Onboarding | Brief walkthrough on first launch explaining core features |

---

## 8. Screen Map

```
Login ──▶ Register
  │
  ▼
Dashboard (Home)
  ├── Trade List (view all positions, filter, sort)
  │     └── Trade Detail (view single position)
  ├── Add Trade (input form)
  ├── Import/Export
  │     ├── Import CSV
  │     └── Export CSV
  └── Settings
        ├── Theme Toggle
        ├── Profile
        ├── Change Password
        └── Sign Out
```

---

## 9. Out of Scope (v1)

The following features are explicitly excluded from v1 and deferred to future versions:

| Feature | Reason |
|---------|--------|
| Real-time trade sync / push notifications | Requires WebSocket infrastructure |
| Multi-language / i18n | v1 is English only |
| Social features (sharing, following) | Not core to journaling |
| Broker API integration / auto-import | Requires per-broker integration work |
| Strategy backtesting | Complex feature, deferred |
| Multi-account support | Adds data model complexity |
| Tags / custom labels on trades | Can be added in minor release |
| Chart annotations and notes | Deferred to v2 |
| Local database encryption | Deferred to v2 |
| Push notifications for sync status | Deferred to v2 |
| Widget support (Android/iOS home screen) | Deferred to v2 |

---

## 10. Success Metrics (v1)

| Metric | Target |
|--------|--------|
| User can log a trade in under 30 seconds | Manual input form is fast and validated |
| Dashboard renders analytics with 10,000+ trades | Smooth performance at scale |
| CSV import handles 1,000+ rows without crash | Robust parsing and validation |
| Full offline functionality | All core features work without internet |
| Cross-platform parity | Identical feature set on Android, iOS, Desktop, Web |

---

## 11. References

| Resource | Purpose |
|----------|---------|
| `example_trade_report.csv` | Source of truth for trade position field definitions and CSV format |
| Supabase Docs | Auth, database, and API reference |
| Drift Docs | Local database setup and queries |
| Riverpod Docs | State management patterns |
| GoRouter Docs | Navigation and deep linking |
| Freezed Docs | Immutable data class generation |
