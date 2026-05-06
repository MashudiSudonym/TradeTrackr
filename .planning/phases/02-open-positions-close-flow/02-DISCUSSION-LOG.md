# Phase 2: Open Positions & Close Flow - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-06
**Phase:** 2-Open Positions & Close Flow
**Areas discussed:** Page layout, Close sheet behavior, Navigation & dashboard refresh, Empty state & error handling, Card tap behavior, Pull-to-refresh, Dashboard card content

---

## Open Positions Page Layout

| Option | Description | Selected |
|--------|-------------|----------|
| Cards in ListView | Simple scrollable list of OpenPositionCard widgets — matches TradeListPage pattern | ✓ |
| Grouped by symbol | Group positions by trading symbol with section headers | |
| You decide | Let the agent decide | |

**User's choice:** Cards in ListView
**Notes:** Recommended option — consistent with existing TradeListPage pattern

| Option | Description | Selected |
|--------|-------------|----------|
| Newest first by open time | Most recent positions at top — natural for trading journals | ✓ |
| Oldest first | Oldest positions first — useful for finding long-held positions | |
| You decide | Let the agent decide | |

**User's choice:** Newest first by open time

| Option | Description | Selected |
|--------|-------------|----------|
| Count in title | Show position count in app bar like "Open Positions (3)" | ✓ |
| Separate count badge | Just "Open Positions" as title, count shown separately | |
| You decide | Let the agent decide | |

**User's choice:** Count in title

---

## Close Sheet Behavior

| Option | Description | Selected |
|--------|-------------|----------|
| Pre-fill both | Close price = open price, close time = current time | ✓ |
| Empty fields | User must enter everything manually | |
| You decide | Let the agent decide | |

**User's choice:** Pre-fill both

| Option | Description | Selected |
|--------|-------------|----------|
| USER | Most common reason for manual close | ✓ |
| No default (must pick) | Forces user to pick explicitly | |
| You decide | Let the agent decide | |

**User's choice:** USER

---

## Navigation & Dashboard Refresh

| Option | Description | Selected |
|--------|-------------|----------|
| Dashboard card tap | Tap the open positions count on dashboard to navigate | ✓ |
| New bottom nav tab | Replace one of the 5 bottom nav tabs | |
| Dashboard card + app bar action | Both a card tap and an app bar action | |
| You decide | Let the agent decide | |

**User's choice:** Dashboard card tap

| Option | Description | Selected |
|--------|-------------|----------|
| Invalidate on close | Invalidate both providers immediately after close | ✓ |
| Refresh on dashboard revisit | Dashboard re-fetches only when user navigates back | |
| You decide | Let the agent decide | |

**User's choice:** Invalidate on close

---

## Empty State & Error Handling

| Option | Description | Selected |
|--------|-------------|----------|
| Icon + message | Centered icon with "No open positions" message and subtitle | ✓ |
| Empty state + CTA button | Show message plus "Add your first position" button | |
| You decide | Let the agent decide | |

**User's choice:** Icon + message

| Option | Description | Selected |
|--------|-------------|----------|
| SnackBar + dismiss sheet | Show SnackBar with error message and dismiss the sheet | ✓ |
| Inline error in sheet | Keep sheet open, show error at top of sheet | |
| You decide | Let the agent decide | |

**User's choice:** SnackBar + dismiss sheet

---

## Card Tap Behavior

| Option | Description | Selected |
|--------|-------------|----------|
| Navigate to detail page | Navigate to existing trade detail page with position data | ✓ |
| Expand inline | Expand card to show more details inline | |
| No action on tap | Only Close button is interactive | |
| You decide | Let the agent decide | |

**User's choice:** Navigate to detail page

---

## Pull-to-Refresh

| Option | Description | Selected |
|--------|-------------|----------|
| Pull-to-refresh | Standard pull-to-refresh on the list, refreshes from local DB | ✓ |
| No pull-to-refresh | Data auto-refreshes via provider invalidation only | |
| You decide | Let the agent decide | |

**User's choice:** Pull-to-refresh

---

## Dashboard Card Content

| Option | Description | Selected |
|--------|-------------|----------|
| Count only | Show "Open Positions: 3" on dashboard card | ✓ |
| Count + floating P/L | Show count plus total floating P/L | |
| You decide | Let the agent decide | |

**User's choice:** Count only
**Notes:** Real-time price feeds are out of scope (v2), so floating P/L would be misleading

---

## Agent's Discretion

- Exact empty state icon choice
- Snackbar duration and action text
- Transition animation for close sheet dismissal
- SliverAppBar vs standard AppBar for page header
- Loading state animation (spinner vs shimmer)

## Deferred Ideas

None — discussion stayed within phase scope
