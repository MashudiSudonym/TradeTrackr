# TradeTrackr - Product Requirements Document v1.0

## 1. Product Overview

### 1.1 Product Vision
A comprehensive trading journal application designed for disciplined traders who meticulously record their trading positions to gain deep insights into their trading performance.

### 1.2 Product Mission
Empower traders to make data-driven decisions by providing tools to log, analyze, and receive recommendations based on their historical trading data.

### 1.3 Target Audience
**Primary**: Disciplined retail traders who:
- Actively maintain trading journals
- Trade indices (NDX100, SPX500), stocks, forex, or crypto
- Want to understand their performance patterns
- Seek data-driven insights to improve their strategies
- Value detailed analysis of their trading history

---

## 2. Problem Statement

Traders who diligently journal their positions face several challenges:

| Problem | Impact |
|---------|--------|
| Scattered records across spreadsheets/notebooks | Difficult to analyze trends and patterns |
| Manual calculations for win rate, P&L, etc. | Time-consuming and error-prone |
| No visual representation of performance | Hard to identify strengths/weaknesses |
| Cannot easily identify profitable patterns | Missed opportunities for optimization |
| Data siloed in manual formats | Cannot get AI-powered insights |

---

## 3. Solution

TradeTrackr is a cross-platform trading journal that:
- Centralizes all trading records in one place
- Provides visual analytics dashboard
- Enables CSV import/export for data portability
- Delivers intelligent recommendations based on historical data
- Works offline with automatic cloud synchronization

---

## 4. MVP Features v1.0

### 4.1 Analytics Dashboard

#### 4.1.1 Performance Overview
Display key metrics at a glance:

| Metric | Description |
|--------|-------------|
| Total P&L | Net profit/loss across all trades |
| Win Rate | Percentage of profitable trades |
| Total Trades | Total number of closed positions |
| Average Win | Mean profit on winning trades |
| Average Loss | Mean loss on losing trades |
| Profit Factor | Gross Profit / Gross Loss |
| Max Drawdown | Largest peak-to-trough decline |
| Best Trade | Highest single profit |
| Worst Trade | Largest single loss |

#### 4.1.2 Visual Charts
- **Equity Curve**: Line chart showing cumulative P&L over time
- **Win/Loss Distribution**: Pie chart showing win vs loss count
- **Performance by Symbol**: Bar chart comparing P&L per trading instrument
- **Performance by Time Period**: Daily, weekly, monthly view filters

#### 4.1.3 Detailed Statistics Panel
- Breakdown by BUY vs SELL positions
- Average holding time per trade
- Success rate by close reason (TP, SL, Manual)
- Most traded symbols ranking

### 4.2 Trading Position Input Form

Form fields matching the CSV structure:

| Field | Type | Required | Validation |
|-------|------|----------|------------|
| Symbol | Text | Yes | Must not be empty |
| Open Time | DateTime | Yes | Must be valid datetime |
| Volume | Decimal | Yes | Must be > 0 |
| Side | Dropdown | Yes | BUY or SELL |
| Close Time | DateTime | No | Must be > Open Time if provided |
| Open Price | Decimal | Yes | Must be > 0 |
| Close Price | Decimal | No | Must be > 0 if provided |
| Stop Loss | Decimal | No | Must be > 0 if provided |
| Take Profit | Decimal | No | Must be > 0 if provided |
| Swap | Decimal | No | Default: 0 |
| Commission | Decimal | No | Default: 0 |
| Profit | Decimal | Auto | Calculated automatically |
| Close Reason | Dropdown | No | TP, SL, User, Partial, Expired |
| Notes | Text | No | Optional notes |

**Automatic Calculations**:
- Profit for BUY: `(Close Price - Open Price) × Volume - Commission - Swap`
- Profit for SELL: `(Open Price - Close Price) × Volume - Commission - Swap`

### 4.3 CSV Import

**Supported Format**: Matches `example_trade_report.csv`

```
ID,Symbol,Open Time,Volume,Side,Close Time,Open Price,Close Price,Stop Loss,Take Profit,Swap,Commission,Profit,Reason
```

**Features**:
- File selection from device storage
- Preview before import (show first 10 rows)
- Validation with error highlighting
- Skip/Update/Duplicate options for conflicts
- Progress indicator for large files
- Success/failure summary after import

### 4.4 CSV Export

**Features**:
- Export all trades or apply filters:
  - Date range selector
  - Symbol filter
  - Side filter (BUY/SELL)
  - Close reason filter
- Format matching import structure for round-trip compatibility
- Shareable file (email, cloud storage, etc.)

### 4.5 AI-Powered Recommendations

Generate insights from stored trading data:

#### 4.5.1 Performance Patterns
- "Your most profitable trading hour: 14:00-16:00"
- "Best day of week for you: Wednesday"
- "Top performing symbol: NDX100 (+$XXX)"

#### 4.5.2 Risk Analysis
- Recommended position sizing based on historical drawdowns
- Suggested stop-loss distance based on volatility patterns
- Warning when approaching maximum drawdown threshold

#### 4.5.3 Strategy Insights
- Win rate comparison: BUY vs SELL
- Average holding time: Winning trades vs Losing trades
- Impact of overnight holding on profitability
- Close reason analysis (TP vs SL vs Manual)

### 4.6 Authentication

**Simple Email/Password Authentication**:
- Registration with email and password
- Email validation (optional for v1)
- Login form with email/password
- Password reset via email link
- Remember me functionality
- Session persistence

### 4.7 User Profile

**Editable Fields**:
| Field | Type | Description |
|-------|------|-------------|
| Display Name | Text | User's preferred name |
| Email | Text | Read-only (change via separate flow) |
| Trading Experience | Dropdown | Beginner, Intermediate, Advanced, Professional |
| Risk Tolerance | Dropdown | Conservative, Moderate, Aggressive |
| Preferred Symbols | Multi-select | Quick filter selection |

**Account Actions**:
- Change password
- Logout
- Delete account (with confirmation dialog)

### 4.8 Dark Theme Support

- System theme detection (auto)
- Manual Light/Dark toggle
- Persisted user preference
- All screens theme-compliant

---

## 5. Information Architecture

### 5.1 Navigation Structure

```
/                          → Redirect (auth check)
├── /auth
│   ├── /login            → Login page
│   ├── /register         → Registration page
│   └── /forgot-password  → Password reset
├── /dashboard            → Analytics dashboard (home)
├── /trades
│   ├── /                 → Trades list with filters
│   ├── /new              → Create new trade
│   ├── /:id              → Trade detail/edit
│   └── /import           → CSV import page
├── /recommendations      → AI insights page
├── /profile              → User profile
└── /settings             → App settings
```

### 5.2 Screen Hierarchy

```
Level 1 (Tabs): Dashboard, Trades, Recommendations, Profile
Level 2: Detail pages, forms, modals
Level 3: Settings sub-pages, confirmation dialogs
```

---

## 6. Technical Requirements

### 6.1 Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| UI Framework | Flutter | 3.27+ |
| State Management | Riverpod | 2.6+ |
| Navigation | GoRouter | 14.0+ |
| Code Generation | Freezed | 2.5+ |
| Logging | Logger | 2.4+ |
| Local Database | Drift | 2.18+ |
| Backend | Supabase | - |

### 6.2 Architecture Pattern

#### Clean Architecture with Layer Structure

```
┌─────────────────────────────────────────────────────┐
│                   PRESENTATION LAYER                │
│  ┌─────────────┐  ┌─────────────┐  ┌────────────┐  │
│  │    Pages    │  │   Widgets   │  │ Providers  │  │
│  │  (Screens)  │  │  (Components)│ │  (State)   │  │
│  └─────────────┘  └─────────────┘  └────────────┘  │
└─────────────────────────────────────────────────────┘
                         ↓ depends on
┌─────────────────────────────────────────────────────┐
│                    DOMAIN LAYER                     │
│  ┌─────────────┐  ┌─────────────┐  ┌────────────┐  │
│  │  Entities   │  │  Use Cases  │  │Repositories│  │
│  │  (Models)   │  │ (Interactors)│ │ (Interfaces)│  │
│  └─────────────┘  └─────────────┘  └────────────┘  │
└─────────────────────────────────────────────────────┘
                         ↓ depends on
┌─────────────────────────────────────────────────────┐
│                      DATA LAYER                     │
│  ┌─────────────┐  ┌─────────────┐  ┌────────────┐  │
│  │  Datasources│  │   Models    │  │  Mappers   │  │
│  │ (Supabase,  │  │ (DTOs, Adapters)│            │  │
│  │  Drift)     │  │             │  │            │  │
│  └─────────────┘  └─────────────┘  └────────────┘  │
└─────────────────────────────────────────────────────┘
```

#### SOLID Principles Implementation

**Single Responsibility Principle**
- Each class has one reason to change
- Clear separation: UI, business logic, data access

**Open/Closed Principle**
- Interfaces for extensibility
- Strategy pattern for recommendation engines

**Liskov Substitution Principle**
- Implementations properly substitute interfaces

**Interface Segregation Principle**
- Small, focused interfaces per domain

**Dependency Inversion Principle**
- Depend on abstractions via Riverpod providers

#### Repository Segregation Pattern

```
domain/repositories/
├── auth_repository.dart         # Authentication operations
├── trade_repository.dart        # Trade CRUD + queries
├── analytics_repository.dart    # Performance metrics
├── recommendation_repository.dart # AI insights
├── user_repository.dart         # Profile management
└── sync_repository.dart         # Offline sync orchestration
```

Each repository:
- Defines interface in domain layer
- Has implementation in data layer
- Supports both local (Drift) and remote (Supabase) sources

### 6.3 Offline-First Strategy

```
┌──────────────┐     ┌──────────────┐
│   User/UI    │────▶│ Local (Drift)│
└──────────────┘     └──────────────┘
                            │
                            ▼
                      ┌──────────────┐
                      │ Sync Queue   │
                      └──────────────┘
                            │
                            ▼
                      ┌──────────────┐
                      │ Supabase     │
                      │ (Background) │
                      └──────────────┘
```

**Sync Strategy**:
1. All writes immediately saved to local Drift DB
2. UI updates instantly (optimistic)
3. Background sync to Supabase when online
4. Conflict resolution: Last-write-wins with timestamps
5. Connectivity awareness: Pause/resume sync

---

## 7. Data Model

### 7.1 Core Entities

#### User Profile
```dart
class UserProfile {
  String id;
  String displayName;
  String email;
  TradingExperience experienceLevel;
  RiskTolerance riskTolerance;
  List<String> preferredSymbols;
  ThemePreference themePreference;
  DateTime createdAt;
  DateTime updatedAt;
}
```

#### Trade
```dart
class Trade {
  String id;
  String userId;
  String symbol;
  DateTime openTime;
  DateTime? closeTime;
  double volume;
  TradeSide side;  // BUY | SELL
  double openPrice;
  double? closePrice;
  double? stopLoss;
  double? takeProfit;
  double swap;
  double commission;
  double profit;
  CloseReason? closeReason;  // TP | SL | User | Partial | Expired
  String? notes;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? syncedAt;
}
```

### 7.2 Database Schema (Conceptual)

**user_profiles**
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PK, FK → auth.users |
| display_name | VARCHAR(100) | NOT NULL |
| trading_experience_level | VARCHAR(20) | beginner/intermediate/advanced/professional |
| risk_tolerance | VARCHAR(20) | conservative/moderate/aggressive |
| preferred_symbols | TEXT[] | - |
| theme_preference | VARCHAR(10) | light/dark/system |
| created_at | TIMESTAMPTZ | DEFAULT NOW() |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() |

**trades**
| Column | Type | Constraints |
|--------|------|-------------|
| id | UUID | PK, DEFAULT gen_random_uuid() |
| user_id | UUID | FK → auth.users, NOT NULL |
| symbol | VARCHAR(50) | NOT NULL |
| open_time | TIMESTAMPTZ | NOT NULL |
| close_time | TIMESTAMPTZ | - |
| volume | DECIMAL(10,4) | NOT NULL, CHECK > 0 |
| side | VARCHAR(10) | CHECK IN ('BUY', 'SELL') |
| open_price | DECIMAL(20,8) | NOT NULL, CHECK > 0 |
| close_price | DECIMAL(20,8) | CHECK > 0 OR NULL |
| stop_loss | DECIMAL(20,8) | - |
| take_profit | DECIMAL(20,8) | - |
| swap | DECIMAL(20,8) | DEFAULT 0 |
| commission | DECIMAL(20,8) | DEFAULT 0 |
| profit | DECIMAL(20,8) | DEFAULT 0 |
| close_reason | VARCHAR(20) | CHECK IN ('TP', 'SL', 'User', 'Partial', 'Expired') |
| notes | TEXT | - |
| is_deleted | BOOLEAN | DEFAULT FALSE |
| created_at | TIMESTAMPTZ | DEFAULT NOW() |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() |
| synced_at | TIMESTAMPTZ | - |

**Indexes**:
- `idx_trades_user_id` on (user_id)
- `idx_trades_symbol` on (symbol)
- `idx_trades_open_time` on (open_time DESC)
- `idx_trades_close_time` on (close_time DESC)

**Row Level Security (RLS)**:
- Users can only access their own data
- Separate policies for SELECT, INSERT, UPDATE, DELETE

---

## 8. Platform Support

### 8.1 Target Platforms

| Platform | Min Version | Notes |
|----------|-------------|-------|
| Android | API 21 (Lollipop) | 99%+ coverage |
| iOS | 12.0 | iPhone 5s+ |
| Web | Modern browsers | Chrome, Firefox, Safari, Edge |
| Windows | Windows 10+ | - |
| macOS | 10.14+ | - |
| Linux | All distributions | - |

### 8.2 Responsive Design Breakpoints

| Size | Platform | Layout |
|------|----------|--------|
| < 600px | Mobile (Portrait) | Single column, bottom nav |
| 600-900px | Mobile (Landscape)/Tablet | Two columns, adapted spacing |
| 900-1200px | Tablet/Desktop | Three columns, side nav possible |
| > 1200px | Desktop | Maximum content width, centered |

---

## 9. Non-Functional Requirements

### 9.1 Performance
| Metric | Target |
|--------|--------|
| Dashboard load time | < 2 seconds (1000 trades) |
| Form submission | < 500ms local, < 2s with sync |
| CSV import | 100 rows/second |
| Search/filter response | < 1 second |
| Animation smoothness | 60 FPS |

### 9.2 Security
| Aspect | Implementation |
|--------|----------------|
| Data at rest | Encrypted (Supabase) |
| Data in transit | HTTPS/TLS |
| Authentication | JWT tokens via Supabase Auth |
| Local storage | flutter_secure_storage |
| Input validation | All fields validated pre-submission |

### 9.3 Reliability
- Offline mode: Full functionality without network
- Sync reliability: Automatic retry with exponential backoff
- Data integrity: Conflict resolution on sync
- Crash recovery: Local state persistence

### 9.4 Usability
- **Accessibility**: WCAG 2.1 AA compliance
  - Minimum contrast ratio 4.5:1
  - Screen reader support
  - Scalable text (200%)
  - Keyboard navigation (web/desktop)

---

## 10. Localization

### v1.0 Scope
- **Primary Language**: English (US)
- All UI text in English
- Date/time formats: ISO 8601, localized display
- Number formats: Locale-aware decimals
- Future versions to support multi-language

---

## 11. Success Metrics (v1.0)

| Metric | Target | Measurement |
|--------|--------|-------------|
| User engagement | 70% DAU/MAU | Session tracking |
| Data entry | Avg 5 trades/week/user | Trade creation analytics |
| Feature usage | 80% use dashboard | Screen navigation tracking |
| App stability | < 1% crash rate | Crashlytics |
| Performance | 95th percentile < 3s | APM monitoring |
| User satisfaction | 4.0+ star rating | App store reviews |

---

## 12. Future Roadmap (Post v1.0)

### v1.1 - Enhanced Analytics
- Additional chart types (candlestick, heatmap)
- Custom date range analytics
- Performance comparison by strategy
- Export analytics as PDF reports

### v1.2 - Collaboration
- Share performance reports
- Trading community features
- Leaderboards (anonymous)
- Follow top performers

### v1.3 - Automation
- Trading platform API integration
- Auto-import from brokers
- Price alerts and notifications
- Position size calculator

### v2.0 - Advanced Features
- Strategy backtesting
- AI coach with personalized tips
- Multi-currency support
- Tax report generation
- Advanced risk metrics (Sharpe, Sortino, Calmar)

---

## 13. Constraints & Assumptions

### Constraints
- Development timeline: v1.0 in X weeks
- Budget considerations: Self-funded/bootstrapped
- Team size: Solo developer or small team
- API limitations: Supabase free tier initially

### Assumptions
- Users have basic trading knowledge
- Users primarily trade single assets (not complex spreads)
- Internet connectivity available periodically for sync
- Users comfortable with CSV format for data exchange

---

## 14. References

- Example CSV: `example_trade_report.csv`
- Supabase Docs: https://supabase.com/docs
- Flutter Docs: https://flutter.dev/docs
- Riverpod Docs: https://riverpod.dev
- GoRouter Docs: https://gorouter.dev
