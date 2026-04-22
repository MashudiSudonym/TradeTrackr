# CSV Import/Export Format Reference

This directory contains CSV template files for importing trading data into TradeTrackr.

## Files

| File | Purpose |
|------|---------|
| `CLOSED_POSITIONS_TEMPLATE.csv` | Template for completed/closed trade positions |
| `OPEN_POSITIONS_TEMPLATE.csv` | Template for active/open trade positions |
| `FINANCE_TEMPLATE.csv` | Template for deposits and withdrawals |

---

## Closed Positions Format

**File:** `CLOSED_POSITIONS_TEMPLATE.csv`

| Column | Type | Required | Description | Example |
|--------|------|----------|-------------|---------|
| ID | String | Yes | Unique identifier (UUID or custom) | `550e8400-...` |
| Symbol | String | Yes | Trading instrument ticker | `NDX100`, `EURUSD`, `BTCUSD` |
| Open Time | DateTime | Yes | Position open time (UTC) | `15/01/2026 08:30:00` |
| Volume | Double | Yes | Lot size or contract quantity | `1.0`, `0.5` |
| Side | Enum | Yes | Trade direction | `BUY` or `SELL` |
| Close Time | DateTime | Yes | Position close time (UTC) | `15/01/2026 10:15:00` |
| Open Price | Double | Yes | Entry price | `21250.5` |
| Close Price | Double | Yes | Exit price | `21300.0` |
| Stop Loss | Double | No | Stop loss price (empty if none) | `21200.0` |
| Take Profit | Double | No | Take profit price (empty if none) | `21400.0` |
| Swap | Double | Yes | Swap/rollover fee | `-0.5` |
| Commission | Double | Yes | Trading commission | `2.5` |
| Profit | Double | Yes | Net profit/loss | `47.5` |
| Reason | Enum | Yes | Close reason | `TP`, `SL`, `USER`, `MANUAL` |

**Date Format:** `dd/MM/yyyy HH:mm:ss` (24-hour format, UTC timezone)

**Close Reasons:**
- `TP` - Take Profit hit
- `SL` - Stop Loss hit
- `USER` - Manually closed by user
- `MANUAL` - Manual intervention

**Note:** The last row with `Total` is a summary row and will be ignored during import.

---

## Open Positions Format

**File:** `OPEN_POSITIONS_TEMPLATE.csv`

| Column | Type | Required | Description | Example |
|--------|------|----------|-------------|---------|
| ID | String | Yes | Unique identifier (UUID or custom) | `660e8400-...` |
| Symbol | String | Yes | Trading instrument ticker | `NDX100`, `EURUSD` |
| Open Time | DateTime | Yes | Position open time (UTC) | `17/01/2026 08:30:00` |
| Volume | Double | Yes | Lot size or contract quantity | `1.0`, `0.5` |
| Side | Enum | Yes | Trade direction | `BUY` or `SELL` |
| Open Price | Double | Yes | Entry price | `21350.0` |
| Current Price | Double | No | Current market price | `21380.0` |
| Stop Loss | Double | No | Stop loss price (empty if none) | `21300.0` |
| Take Profit | Double | No | Take profit price (empty if none) | `21500.0` |
| Swap | Double | Yes | Swap/rollover fee | `-0.3` |
| Commission | Double | Yes | Trading commission | `0.0` |
| Profit | Double | Yes | Floating profit/loss | `29.7` |

**Date Format:** `dd/MM/yyyy HH:mm:ss` (24-hour format, UTC timezone)

**Note:** The last row with `Total` is a summary row and will be ignored during import.

---

## Finance Records Format

**File:** `FINANCE_TEMPLATE.csv`

| Column | Type | Required | Description | Example |
|--------|------|----------|-------------|---------|
| Type | Enum | Yes | Transaction type | `Deposit` or `Withdrawal` |
| Time | DateTime | Yes | Transaction time (UTC) | `01/01/2026 10:00:00` |
| Amount | Double | Yes | Transaction amount | `10000.0` |
| Status | String | Yes | Transaction status | `Done`, `Pending`, `Failed` |
| Payment gateway | String | Yes | Payment method | `Manual`, `Bank Transfer` |
| Details | String | Yes | Additional notes | `Initial deposit` |

**Date Format:** `dd/MM/yyyy HH:mm:ss` (24-hour format, UTC timezone)

**Transaction Types:**
- `Deposit` - Funds added to account
- `Withdrawal` - Funds removed from account

**Note:** The last row with `Total` is a summary row and will be ignored during import.

---

## Import Instructions

1. **Copy the template** that matches your data type
2. **Fill in your data** following the format exactly
3. **Save as CSV** with UTF-8 encoding
4. **Import via app:** Settings → Import/Export → Import CSV

**Important:**
- Use `dd/MM/yyyy HH:mm:ss` date format (e.g., `15/01/2026 14:30:00`)
- All times must be in UTC timezone
- Use `BUY` or `SELL` for side (uppercase)
- Use proper close reasons: `TP`, `SL`, `USER`, `MANUAL`
- The `Total` row at the end is optional and will be ignored
- Empty values for optional fields should be left blank (not `NULL` or `null`)

---

## Export Format

When exporting data from TradeTrackr, the same format is used. You can:
- Export for backup purposes
- Export for analysis in spreadsheet software
- Export, modify, and re-import (keeping IDs to avoid duplicates)

**Export Location:** Settings → Import/Export → Export CSV

Files are saved to the app's documents directory or shared via platform share sheet.
