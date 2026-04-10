# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TradeTrackr is a cross-platform trading journal application built with Flutter. It enables traders to log, analyze, and receive AI-powered recommendations based on their historical trading data.

**Key Features**: Analytics dashboard, trade CRUD operations, CSV import/export, AI-powered insights, email/password authentication, offline-first with cloud sync.

## Project Setup

This project has not been scaffolded yet. To initialize:

```bash
flutter create --org com.example --project-name tradetrackr .
```

After initialization, add dependencies to `pubspec.yaml` (see Technology Stack below) and run:
```bash
flutter pub get
```

## Development Commands

```bash
# Run development server (default device)
flutter run

# Run on specific target
flutter run -d chrome       # Web
flutter run -d linux        # Linux desktop
flutter run -d android      # Android emulator/device

# Build for production
flutter build apk           # Android APK
flutter build ios           # iOS
flutter build web           # Web
flutter build linux         # Linux desktop

# Testing
flutter test                                # Run all tests
flutter test test/path/to_test.dart         # Run single test file
flutter test --name "test_name"             # Run tests matching name

# Code quality
flutter analyze        # Static analysis (Dart analyzer)
dart format .          # Format code
dart fix --apply .     # Apply automated fixes
```

## Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| UI Framework | Flutter | 3.27+ |
| State Management | Riverpod | 2.6+ |
| Navigation | GoRouter | 14.0+ |
| Code Generation | Freezed | 2.5+ |
| Logging | Logger | 2.4+ |
| Local Database | Drift | 2.18+ |
| Backend | Supabase | - |

## Architecture: Clean Architecture

The app follows strict Clean Architecture with three layers. Dependency direction: **Presentation → Domain ← Data**

```
PRESENTATION LAYER
├── Pages/      # Full-screen views (Dashboard, Trades, etc.)
├── Widgets/    # Reusable UI components
└── Providers/  # Riverpod state providers

DOMAIN LAYER (no framework dependencies)
├── Entities/       # Core business models (Trade, UserProfile)
├── Use Cases/      # Business logic interactors
└── Repositories/   # Abstract repository interfaces

DATA LAYER
├── DataSources/    # Concrete implementations (Supabase, Drift)
├── Models/         # DTOs, adapters, mappers
└── Repositories/   # Repository implementations
```

**Key Principles**:
- Domain layer has zero framework dependencies
- All dependencies flow inward via Riverpod providers
- Use Freezed for immutable entities and union types
- Repository interfaces defined in Domain, implemented in Data

## Repository Pattern

Repositories are segregated by domain concern. Each has:
- Interface in `domain/repositories/`
- Implementation in `data/repositories/`
- Support for both local (Drift) and remote (Supabase) sources

```
domain/repositories/
├── auth_repository.dart            # Authentication operations
├── trade_repository.dart           # Trade CRUD + queries
├── analytics_repository.dart       # Performance metrics
├── recommendation_repository.dart  # AI insights
├── user_repository.dart            # Profile management
└── sync_repository.dart            # Offline sync orchestration
```

## Offline-First Strategy

**Data Flow**: User/UI → Local (Drift) → Sync Queue → Supabase (background)

1. All writes immediately saved to local Drift database
2. UI updates instantly (optimistic updates)
3. Background sync to Supabase when online
4. Conflict resolution: Last-write-wins with timestamps
5. Connectivity awareness pauses/resumes sync

**Implications**:
- Always write to Drift first, then queue for sync
- UI reads from local state only
- Sync runs in background, doesn't block UI
- Handle sync failures with exponential backoff retry

## Navigation Structure

GoRouter manages navigation with this route tree:

```
/ (redirect based on auth state)
├── /auth
│   ├── /login
│   ├── /register
│   └── /forgot-password
├── /dashboard           # Home after login
├── /trades
│   ├── /                # List with filters
│   ├── /new             # Create new trade
│   ├── /:id             # Detail/edit
│   └── /import          # CSV import
├── /recommendations     # AI insights
├── /profile
└── /settings
```

**Tab Navigation**: Level 1 has bottom nav tabs (Dashboard, Trades, Recommendations, Profile)

## Data Model

### Trade Entity
```dart
class Trade {
  String id;
  String userId;
  String symbol;                  // e.g., "NDX100"
  DateTime openTime;
  DateTime? closeTime;
  double volume;                  // Must be > 0
  TradeSide side;                 // BUY | SELL
  double openPrice;               // Must be > 0
  double? closePrice;             // Must be > 0 if provided
  double? stopLoss;
  double? takeProfit;
  double swap;                    // Default: 0
  double commission;              // Default: 0
  double profit;                  // Auto-calculated
  CloseReason? closeReason;       // TP | SL | User | Partial | Expired
  String? notes;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? syncedAt;
}
```

**Profit Calculation**:
- BUY: `(Close Price - Open Price) × Volume - Commission - Swap`
- SELL: `(Open Price - Close Price) × Volume - Commission - Swap`

### UserProfile Entity
```dart
class UserProfile {
  String id;
  String displayName;
  String email;
  TradingExperience experienceLevel;    // beginner/intermediate/advanced/professional
  RiskTolerance riskTolerance;          // conservative/moderate/aggressive
  List<String> preferredSymbols;
  ThemePreference themePreference;      // light/dark/system
  DateTime createdAt;
  DateTime updatedAt;
}
```

## CSV Import/Export Format

Reference file: `example_trade_report.csv`

**Columns**: `ID,Symbol,Open Time,Volume,Side,Close Time,Open Price,Close Price,Stop Loss,Take Profit,Swap,Commission,Profit,Reason`

**Date Format**: `dd/MM/yyyy HH:mm:ss`

**Import Notes**:
- Final row may be a "Total" summary line - skip during import
- ID is optional (generate UUID if missing)
- Validate all numeric values
- Handle missing optional fields gracefully

## Supabase Integration

**Project Reference**: `bheohnfxjnwdkqvftbnc` (configured in `.mcp.json`)

**Available MCP Tools**: Use Supabase MCP server for database operations, migrations, and type generation.

**Database**:
- PostgreSQL with Row Level Security (RLS)
- Users can only access their own data
- Tables: `user_profiles`, `trades`
- Indexes on `user_id`, `symbol`, `open_time DESC`, `close_time DESC`

**Auth**: Email/password authentication via Supabase Auth with JWT tokens

## Freezed Code Generation

After modifying Freezed-annotated classes, run:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Watch mode during development:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Important Design Decisions

1. **SOLID Principles**: Each repository has a single responsibility. Use interfaces for extensibility.
2. **Dependency Injection**: Use Riverpod providers, not manual constructor injection.
3. **Type Safety**: Leverage Freezed for compile-time safety and immutable models.
4. **Error Handling**: Repository methods return Result types or throw domain-specific exceptions.
5. **Logging**: Use Logger package with appropriate levels (finer, fine, info, warning, severe).
