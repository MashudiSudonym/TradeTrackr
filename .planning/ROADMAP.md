# Roadmap: TradeTrackr

## Overview

Complete PRD v1 by wiring 50 requirements across 5 phases. This is a brownfield Flutter trading journal where most UI, domain, and data layers already exist — the primary work is connecting providers to real data, creating 2 missing pages (open positions, close position), and fixing 5 data integrity bugs. Phase 1 establishes foundations (DI, packages, theme, trade CRUD). Phase 2 delivers the user's top priority (open positions + atomic close flow). Phase 3 builds the critical analytics pipeline that dashboard, charts, filters, and recommendations all depend on. Phase 4 completes CSV import/export with platform-specific file handling. Phase 5 wires the recommendation engine to real grouped analytics.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Foundation & Trade Management** - DI registration, package upgrades, theme persistence, trade edit/delete wiring, finance provider ✓
- [ ] **Phase 2: Open Positions & Close Flow** - Dedicated open positions page, close position sheet, atomic transactions, critical bug fixes
- [ ] **Phase 3: Analytics Pipeline & Dashboard** - Real analytics data, finance metrics, all 6 charts, dashboard filters, bug fixes
- [ ] **Phase 4: CSV Import & Export** - File picker, format detection, robust parsing, platform-specific save/share
- [ ] **Phase 5: Recommendation Engine** - All 10 rules wired to real analytics with minimum trade thresholds

## Phase Details

### Phase 1: Foundation & Trade Management
**Goal**: Users can manage existing trades and their app preferences persist across sessions
**Depends on**: Nothing (first phase)
**Requirements**: THEM-01, TRAD-01, TRAD-02, TRAD-03, TRAD-04
**Success Criteria** (what must be TRUE):
  1. User can toggle theme between light/dark/system and the preference persists after app restart
  2. User can navigate to trade detail, tap Edit, modify fields, save, and see updated data in the trade list
  3. User can delete a trade from the detail page with a confirmation dialog and the trade disappears from the list
**Plans:** 2 plans

Plans:
- [x] 01-01-PLAN.md — DI wiring, serialization cleanup, and codebase housekeeping
- [x] 01-02-PLAN.md — Trade edit/delete wiring and theme persistence

### Phase 2: Open Positions & Close Flow
**Goal**: Users can view, manage, and close their open positions without risk of data loss
**Depends on**: Phase 1
**Requirements**: OPEN-01, OPEN-02, OPEN-03, OPEN-04
**Success Criteria** (what must be TRUE):
  1. User can view a dedicated Open Positions page listing all their open positions with real data from the local database
  2. User can close an open position by entering close price, time, and reason, and the position atomically moves to closed trades (survives app crashes)
  3. User sees updated open/closed position counts on the dashboard after closing a position
  4. Close position operation uses Drift transaction wrapping — no data loss if app crashes between delete and insert
**Plans**: TBD

Plans:
- [ ] 02-01: TBD

### Phase 3: Analytics Pipeline & Dashboard
**Goal**: Users see accurate, real-time analytics from their actual trade data with working filters and charts
**Depends on**: Phase 1, Phase 2
**Requirements**: DASH-01, DASH-02, DASH-03, DASH-04, DASH-05, DASH-06, DASH-07, DASH-08, DASH-09, FILT-01, FILT-02, FILT-03, FILT-04, FILT-05, FIN-01, FIN-02, FIN-03
**Success Criteria** (what must be TRUE):
  1. Dashboard displays all 13 summary metrics computed from real trade data (not mock) including correct profit factor (sumWins/sumLosses)
  2. All 6 charts render real trade data — equity curve with cumulative P/L, P/L distribution, wins/losses by symbol and reason, profit by day and session
  3. User can filter dashboard by date range, symbol, side, and close reason, and all metrics and charts update accordingly
  4. Finance page displays real records with correct account balance (deposits - withdrawals + realized P/L)
**Plans**: TBD

Plans:
- [ ] 03-01: TBD

### Phase 4: CSV Import & Export
**Goal**: Users can bulk import trades from broker CSV files and export their data in standard format across all platforms
**Depends on**: Phase 1, Phase 3
**Requirements**: IMPT-01, IMPT-02, IMPT-03, IMPT-04, IMPT-05, IMPT-06, IMPT-07, IMPT-08, EXPT-01, EXPT-02, EXPT-03, EXPT-04, EXPT-05
**Success Criteria** (what must be TRUE):
  1. User can select a CSV file, see format auto-detected, rows validated, duplicates skipped, and a completion summary (imported, skipped, errors)
  2. User can export closed positions, open positions, or finance records as named CSV files saved to platform-appropriate locations (Downloads on Android, share sheet on iOS, file dialog on desktop, download on web)
**Plans**: TBD

Plans:
- [ ] 04-01: TBD

### Phase 5: Recommendation Engine
**Goal**: Users see personalized, data-driven trading recommendations based on their actual performance patterns
**Depends on**: Phase 3
**Requirements**: RECO-01, RECO-02, RECO-03, RECO-04, RECO-05, RECO-06, RECO-07, RECO-08, RECO-09, RECO-10, RECO-11
**Success Criteria** (what must be TRUE):
  1. User sees best/worst performing symbols, best/worst trading days, and best trading session — each with minimum 5-trade threshold to avoid statistically invalid recommendations
  2. User sees risk alerts: consecutive loss streak (current, not all-time max), avg win vs avg loss comparison, risk-reward ratio warning, win rate trend (last 10 vs overall), and overtrading alert
  3. All recommendations update when new trades are added, existing trades are modified, or analytics filters change
**Plans**: TBD

Plans:
- [ ] 05-01: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Foundation & Trade Management | 2/2 | ✓ Complete | 2026-05-05 |
| 2. Open Positions & Close Flow | 0/? | Not started | - |
| 3. Analytics Pipeline & Dashboard | 0/? | Not started | - |
| 4. CSV Import & Export | 0/? | Not started | - |
| 5. Recommendation Engine | 0/? | Not started | - |
