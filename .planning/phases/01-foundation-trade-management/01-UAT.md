---
status: testing
phase: 01-foundation-trade-management
source: 01-01-SUMMARY.md, 01-02-SUMMARY.md
started: 2026-05-05T06:00:00Z
updated: 2026-05-05T06:50:00Z
---

## Current Test

number: 3
name: View Trade Detail
expected: |
  Tap on a trade in the list. The trade detail page opens showing all trade fields (symbol, side, prices, pips, profit, close reason, dates).
awaiting: user response

## Tests

### 1. App Cold Start
expected: Start the app (flutter run -d linux). It launches without errors in the console. The dashboard/trade list screen loads and shows existing data or an empty state.
result: pass

### 2. Add a Closed Position
expected: Navigate to Add Trade page. Fill in trade details (symbol, side, entry/exit price, dates, etc.) and submit. The trade appears in the trade list on the dashboard.
result: pass

### 3. View Trade Detail
expected: Tap on a trade in the list. The trade detail page opens showing all trade fields (symbol, side, prices, pips, profit, close reason, dates).
result: [pending]

### 4. Edit a Trade
expected: On the trade detail page, tap Edit. The AddTradePage opens in edit mode with all fields pre-populated with the trade's existing data. Change a value (e.g., exit price), submit, and return to the trade list. The updated value is reflected.
result: [pending]

### 5. Delete a Trade
expected: On the trade detail page, tap Delete. A confirmation AlertDialog appears. Confirm deletion. You are returned to the trade list and the trade no longer appears.
result: [pending]

### 6. Trade List Refresh After Edit
expected: After editing a trade and returning to the list, the trade list immediately reflects the updated data without needing to manually refresh or restart the app.
result: [pending]

### 7. Trade List Refresh After Delete
expected: After deleting a trade and returning to the list, the deleted trade is immediately gone without needing to manually refresh.
result: [pending]

### 8. Theme Persistence - Switch to Dark Mode
expected: Switch the app theme to dark mode. The UI updates immediately. Close and restart the app. The dark theme is still active.
result: [pending]

### 9. Theme Persistence - Switch Back to Light/System
expected: Switch the theme from dark back to light or system. The UI updates immediately. Close and restart the app. The new theme preference persists.
result: [pending]

### 10. Console is Clean in Production Mode
expected: Run the app (not in debug mode if possible, or check console output). No Supabase debug logging messages appear in the console output.
result: [pending]

## Summary

total: 10
passed: 2
issues: 0
pending: 8
skipped: 0

## Gaps

[none yet]
