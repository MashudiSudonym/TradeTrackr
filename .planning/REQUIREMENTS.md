# Requirements: TradeTrackr

**Defined:** 2026-05-04
**Core Value:** Traders can log every trade and see actionable analytics that reveal strengths, weaknesses, and patterns

## v1 Requirements

Requirements for completing PRD v1. Each maps to roadmap phases.

### Open Positions

- [ ] **OPEN-01**: User can view a dedicated Open Positions list page showing all open positions with real-time data from the local database
- [ ] **OPEN-02**: User can close an open position via the Close Position Sheet with close price, close time, reason, and auto-calculated profit
- [ ] **OPEN-03**: User can convert an open position to a closed position atomically (insert closed + delete open in a single transaction)
- [ ] **OPEN-04**: User sees updated position counts on dashboard after closing a position

### Analytics Dashboard

- [ ] **DASH-01**: Dashboard displays all 13 summary metrics computed from real trade data (total trades, open positions count, win rate, total P/L, avg profit, largest win, largest loss, profit factor, avg risk-reward ratio, avg holding duration, account balance, total deposits, total withdrawals)
- [ ] **DASH-02**: Equity curve chart renders real cumulative P/L over time from closed positions sorted by close time
- [ ] **DASH-03**: P/L distribution chart renders real profit/loss amounts grouped into bins from closed positions
- [ ] **DASH-04**: Win/Loss by Symbol chart renders real wins vs losses per symbol from closed positions
- [ ] **DASH-05**: Win/Loss by Reason chart renders real close reason distribution (TP, SL, User, Manual) from closed positions
- [ ] **DASH-06**: Profit by Day of Week chart renders real average profit grouped by weekday from closed positions
- [ ] **DASH-07**: Profit by Session chart renders real average profit grouped by trading session (Asian, London, New York) from closed positions
- [ ] **DASH-08**: Analytics provider is wired to the real GetTradeAnalyticsUseCase instead of returning mock data
- [ ] **DASH-09**: Profit factor is calculated correctly as sum of gross profits / sum of gross losses (not avgWin / avgLoss)

### Dashboard Filters

- [ ] **FILT-01**: User can filter dashboard analytics by date range (from-to date picker)
- [ ] **FILT-02**: User can filter dashboard analytics by symbol (multi-select from existing trade symbols)
- [ ] **FILT-03**: User can filter dashboard analytics by side (BUY / SELL / All toggle)
- [ ] **FILT-04**: User can filter dashboard analytics by close reason (multi-select: TP, SL, User, Manual)
- [ ] **FILT-05**: All dashboard metrics and charts update when filters are applied

### Finance Tracking

- [ ] **FIN-01**: Finance page displays real finance records from the local database instead of mock data
- [ ] **FIN-02**: Account balance is computed as total deposits minus total withdrawals plus total realized P/L from closed positions
- [ ] **FIN-03**: Total deposits and total withdrawals are computed from finance records and displayed on dashboard

### Trade Management

- [ ] **TRAD-01**: User can edit a closed position's fields from the trade detail page (reuse AddTradePage in edit mode with pre-populated data)
- [ ] **TRAD-02**: User can edit an open position's fields from the trade detail page
- [ ] **TRAD-03**: User can delete a trade from the detail page with a confirmation dialog
- [ ] **TRAD-04**: Trade list page refreshes after edit or delete operation

### CSV Import

- [ ] **IMPT-01**: User can select a CSV file from device storage via system file picker filtered to .csv files
- [ ] **IMPT-02**: CSV format is auto-detected based on header row columns (closed positions, open positions, or finance records)
- [ ] **IMPT-03**: Import validates each row for required fields, valid types, and recognized enum values
- [ ] **IMPT-04**: Import skips rows whose ID already exists in the database and reports duplicate count
- [ ] **IMPT-05**: Import ignores the Total summary row at end of file
- [ ] **IMPT-06**: Import parses dates in dd/MM/yyyy HH:mm:ss format
- [ ] **IMPT-07**: Import displays a summary report after completion (total processed, imported, skipped, errors)
- [ ] **IMPT-08**: Import progress is shown during file processing

### CSV Export

- [ ] **EXPT-01**: User can export closed positions, open positions, or finance records as CSV files
- [ ] **EXPT-02**: Export generates CSV with real data from the local database in the same column format as import templates
- [ ] **EXPT-03**: Export files are named tradetrackr_{type}_YYYYMMDD_HHmmss.csv
- [ ] **EXPT-04**: Export saves to platform-appropriate location (Downloads on Android, share sheet on iOS, file dialog on desktop, download folder on web)
- [ ] **EXPT-05**: User can export all records or a filtered subset by date range

### Recommendation Engine

- [ ] **RECO-01**: Best performing symbol is identified by highest total net profit (minimum 5 trades)
- [ ] **RECO-02**: Worst performing symbol is identified by lowest total net profit (minimum 5 trades)
- [ ] **RECO-03**: Best day to trade is identified by highest average profit by day of week (minimum 5 trades)
- [ ] **RECO-04**: Worst day to trade is identified by lowest average profit by day of week (minimum 5 trades)
- [ ] **RECO-05**: Best trading session is identified by highest average profit by time-of-day session (minimum 5 trades)
- [ ] **RECO-06**: Average win vs average loss comparison flags if avg loss exceeds avg win
- [ ] **RECO-07**: Consecutive loss alert triggers when user has 3+ consecutive losses
- [ ] **RECO-08**: Risk-reward alert flags when average risk-reward ratio falls below 1:1
- [ ] **RECO-09**: Win rate trend compares last 10 trades vs overall and flags if declining by more than 15%
- [ ] **RECO-10**: Overtrading alert flags if more than X trades in a single day (configurable threshold)
- [ ] **RECO-11**: Recommendation provider is wired to real analytics data instead of mock data

### Theme

- [ ] **THEM-01**: User's theme preference (light, dark, system) persists across app restarts via shared_preferences

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Notifications
- **NOTF-01**: User receives trade close reminders
- **NOTF-02**: User receives weekly performance summary

### Enhanced Trading
- **TRADE-01**: Broker API auto-import
- **TRADE-02**: Real-time price feeds for open positions

### Multi-Account
- **ACCT-01**: User can manage multiple trading accounts
- **ACCT-02**: Cross-account analytics comparison

## Out of Scope

| Feature | Reason |
|---------|--------|
| Broker API auto-import | Requires per-broker SDKs, deferred to v2 |
| Real-time price feeds | Requires paid market data API, deferred to v2 |
| Multi-account support | Adds data model complexity, single-account assumption for v1 |
| Social features / sharing | Not core to journaling value, adds privacy/moderation concerns |
| Strategy backtesting | Completely different product scope (simulation engine) |
| Tags / custom labels on trades | PRD defers, requires data model changes and CSV format changes |
| OAuth login | Email/password sufficient for v1 |
| Mobile app store deployment | Separate milestone after v1 features complete |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| OPEN-01 | — | Pending |
| OPEN-02 | — | Pending |
| OPEN-03 | — | Pending |
| OPEN-04 | — | Pending |
| DASH-01 | — | Pending |
| DASH-02 | — | Pending |
| DASH-03 | — | Pending |
| DASH-04 | — | Pending |
| DASH-05 | — | Pending |
| DASH-06 | — | Pending |
| DASH-07 | — | Pending |
| DASH-08 | — | Pending |
| DASH-09 | — | Pending |
| FILT-01 | — | Pending |
| FILT-02 | — | Pending |
| FILT-03 | — | Pending |
| FILT-04 | — | Pending |
| FILT-05 | — | Pending |
| FIN-01 | — | Pending |
| FIN-02 | — | Pending |
| FIN-03 | — | Pending |
| TRAD-01 | — | Pending |
| TRAD-02 | — | Pending |
| TRAD-03 | — | Pending |
| TRAD-04 | — | Pending |
| IMPT-01 | — | Pending |
| IMPT-02 | — | Pending |
| IMPT-03 | — | Pending |
| IMPT-04 | — | Pending |
| IMPT-05 | — | Pending |
| IMPT-06 | — | Pending |
| IMPT-07 | — | Pending |
| IMPT-08 | — | Pending |
| EXPT-01 | — | Pending |
| EXPT-02 | — | Pending |
| EXPT-03 | — | Pending |
| EXPT-04 | — | Pending |
| EXPT-05 | — | Pending |
| RECO-01 | — | Pending |
| RECO-02 | — | Pending |
| RECO-03 | — | Pending |
| RECO-04 | — | Pending |
| RECO-05 | — | Pending |
| RECO-06 | — | Pending |
| RECO-07 | — | Pending |
| RECO-08 | — | Pending |
| RECO-09 | — | Pending |
| RECO-10 | — | Pending |
| RECO-11 | — | Pending |
| THEM-01 | — | Pending |

**Coverage:**
- v1 requirements: 46 total
- Mapped to phases: 0
- Unmapped: 46

---
*Requirements defined: 2026-05-04*
*Last updated: 2026-05-04 after initial definition*
