# Design System: TradeTrackr — Minimalist App Design
**Project ID:** `4123685228949170691`
**Design System:** TradeTrackr Mono-Accent (`assets/e7a43ef6e8e043d19af8b6698210b4e4`)
**Device:** Mobile-first (390×780px)

---

## 1. Visual Theme & Atmosphere

**Creative North Star: "The Financial Curator"**

The design language follows a "Curated Ledger" aesthetic — a high-end editorial digital experience that evokes a premium physical stationery journal. The mood is **Calm Authority**: sophisticated neutrals, expansive white space, intentional asymmetry, and a singular high-energy accent color that guides the eye toward action without increasing cognitive load.

Key atmospheric qualities: **Airy, Minimalist, Editorial, Premium, Refined.** The design rejects rigid, boxy fintech conventions in favor of tonal layering and generous breathing room between data sections.

---

## 2. Color Palette & Roles

### Primary Accent
| Name | Hex | Role |
|------|-----|------|
| Crimson Heart | `#be0038` | Primary actions, CTA buttons, accent bars, active navigation states |
| Crimson Heart (Source) | `#FF385C` | Source seed color for dynamic color system |
| Crimson Dim | `#a80030` | Button gradient endpoint, pressed states |
| Crimson Blush | `#ffdada` | Primary container — tinted backgrounds, selected chip fills |
| Soft Rose | `#fff6f5` | Text on primary backgrounds |
| Deep Crimson | `#a60030` | Text inside primary container |
| Rich Garnet | `#840024` | Primary fixed text (darkest) |

### Success / Tertiary
| Name | Hex | Role |
|------|-----|------|
| Forest Depth | `#006f05` | Win/profit states, success indicators, positive accent bars |
| Forest Source | `#008A09` | Source seed color for tertiary |
| Forest Dim | `#006104` | Tertiary dim variant |
| Lime Glow | `#7aee68` | Tertiary container — light success backgrounds |
| Soft Lime | `#6cdf5c` | Tertiary fixed dim |
| Pale Mint | `#ebffe0` | Text on tertiary backgrounds |
| Deep Forest | `#005603` | Text inside tertiary container |

### Error / Danger
| Name | Hex | Role |
|------|-----|------|
| Muted Brick | `#9e422c` | Loss/danger states, error indicators, negative accent bars |
| Deep Ember | `#5c1202` | Error dim variant |
| Warm Coral | `#fe8b70` | Error container — light error backgrounds |
| Blush White | `#fff7f6` | Text on error backgrounds |
| Burnt Sienna | `#742410` | Text inside error container |

### Surface Hierarchy (Paper-on-Stone)
| Name | Hex | Role |
|------|-----|------|
| Warm Paper | `#f9f9f9` | Base layer — the "desk" background |
| Ledger Sheet | `#f2f4f4` | Section layer — grouped content backgrounds |
| Pure White | `#ffffff` | Interactive layer — active cards, focused inputs |
| Cool Mist | `#ebeeef` | Surface container — standard elevation blocks |
| Silver Mist | `#e4e9ea` | Surface container high — elevated sections |
| Pale Stone | `#dde4e5` | Surface container highest — prominent blocks |
| Warm Dim | `#d4dbdd` | Surface dim — subtle background variation |

### Text Hierarchy
| Name | Hex | Role |
|------|-----|------|
| Charcoal Ink | `#2d3435` | Primary text — headlines, key figures. Never use pure `#000000`. |
| Slate Detail | `#5a6061` | Secondary text — body copy, trade notes, descriptions |
| Muted Steel | `#757c7d` | Outline — borders, dividers, subtle separators |
| Ghost Line | `#adb3b4` | Outline variant — ghost borders at 15% opacity |

### Secondary / Neutral Accent
| Name | Hex | Role |
|------|-----|------|
| Warm Graphite | `#605f5f` | Secondary actions, inactive states |
| Charcoal Source | `#222222` | Source seed color for secondary |
| Soft Linen | `#e5e2e1` | Secondary container — chip backgrounds, secondary fills |
| Snow White | `#fbf8f8` | Text on secondary backgrounds |

### Inverse / Dark Mode Tokens
| Name | Hex | Role |
|------|-----|------|
| Inverse Surface | `#0c0f0f` | Dark mode background |
| Inverse Primary | `#ff5169` | Primary on dark surfaces |
| Inverse On-Surface | `#9c9d9d` | Muted text on dark surfaces |

---

## 3. Typography Rules

**Typefaces:** Two-font system for authoritative hierarchy.

### Manrope (Display & Headlines)
- **Role:** Page titles, large figures (P&L, balance), section headers
- **Character:** Modern, geometric, editorial "magazine" feel
- **Weight:** 600–800 (SemiBold to ExtraBold)
- **Scale:**
  - Display LG: 3.5rem (56px) — Total P&L, Account Balance
  - Headline SM: 1.5rem (24px) — Page titles

### Inter (Body, Labels & Functional)
- **Role:** Journaling text, trade notes, data labels, form inputs, chips
- **Character:** Maximum legibility for long reading sessions
- **Weight:** 400–700 (Regular to Bold)
- **Scale:**
  - Body MD: 0.875rem (14px) — Trade notes, descriptions
  - Label MD: 0.75rem (12px) — Data headers in ALL CAPS with 0.05rem letter-spacing (e.g., "ENTRY PRICE", "EXIT DATE")

### Weight Distribution
| Usage | Font | Weight |
|-------|------|--------|
| Display figures | Manrope | 800 (ExtraBold) |
| Page titles | Manrope | 700 (Bold) |
| Section headers | Manrope | 600 (SemiBold) |
| Body text | Inter | 400 (Regular) |
| Data labels | Inter | 500 (Medium) — ALL CAPS |
| Button text | Inter | 600 (SemiBold) |

---

## 4. Component Stylings

### Cards & Containers
- **Shape:** Gently curved corners (12px / `ROUND_EIGHT` border radius)
- **Background:** `surface_container_lowest` (`#ffffff`) on `surface_container` (`#ebeeef`) backgrounds — "Soft Lift" effect
- **Borders:** No visible borders. Use background color shifts to define sections.
- **Shadows:** Flat — no drop shadows. Depth via tonal layering only.
- **Trade status accent:** 4px vertical bar on left edge — Forest Depth (`#006f05`) for wins, Muted Brick (`#9e422c`) for losses.
- **List separators:** 16px vertical whitespace between items. No divider lines.

### Buttons (The "Action" Set)
| Type | Shape | Background | Text | Border |
|------|-------|-----------|------|--------|
| Primary | Pill-shaped (`full`) | Gradient: Crimson Heart → Crimson Dim at 135deg | Soft Rose (`#fff6f5`) | None |
| Secondary | Pill-shaped (`full`) | Silver Mist (`#e4e9ea`) | Charcoal Ink (`#2d3435`) | None |
| Tertiary | Text-only | None | Crimson Heart (`#be0038`) Bold | None |

- **FAB shadow:** If floating (e.g., "New Trade" button), use ambient shadow — Crimson Heart at 10% opacity, 32px blur, 12px Y-offset.

### Input Fields
- **Style:** Minimalist underline or soft-tonal block
- **Resting:** Background `surface_container_low` (`#f2f4f4`)
- **Focus:** Background transitions to Pure White (`#ffffff`), 2px Crimson Heart bottom-border animates from center outward
- **Labels:** Inter Label MD in ALL CAPS

### Performance Chips (Long/Short, Strategy Type)
- **Default:** `surface_variant` (`#dde4e5`) background with Slate Detail (`#5a6061`) text
- **Selected:** Crimson Blush (`#ffdada`) background with Deep Crimson (`#a60030`) text
- **Shape:** Pill-shaped (`full` radius)

### Bottom Navigation
- **Style:** Glassmorphism — Warm Paper (`#f9f9f9`) at 80% opacity with 20px backdrop blur
- **Active tab:** Crimson Heart icon with label
- **Inactive tab:** Muted Steel (`#757c7d`) icon with label
- **Rule:** Icons must always have labels. Clarity is the ultimate luxury.

---

## 5. Layout Principles

### The "No-Line" Rule
Standard 1px borders are strictly prohibited for sectioning. Structural boundaries are defined exclusively through **background color shifts**:
- Page → Section: `surface` (`#f9f9f9`) to `surface_container_low` (`#f2f4f4`)
- Section → Card: `surface_container_low` to `surface_container_lowest` (`#ffffff`)

### Whitespace Strategy
- **Major sections:** 32px+ vertical spacing — let data "breathe"
- **List items:** 16px vertical whitespace between entries
- **Horizontal padding:** 16–20px consistent left/right margins
- **Card internal padding:** 16px

### Asymmetric Alignment
- Left-align headlines and labels
- Right-align key data points (P&L amounts, percentages)
- Creates a dynamic diagonal visual path

### Ghost Border Fallback
If a container sits on an identical-color background, use 1px border with Ghost Line (`#adb3b4`) at **15% opacity**. It should be felt, not seen.

### Grid
- Single-column mobile layout (390px width)
- Full-width components stretch edge-to-edge with horizontal padding
- Cards and grouped sections use section-layer backgrounds

---

## 6. Elevation & Depth: Tonal Layering

Traditional Material Design shadows (0dp–24dp) are replaced by **Tonal Layering**:

| Depth Level | Background | Role |
|-------------|-----------|------|
| Base | Warm Paper `#f9f9f9` | Page background |
| Section | Ledger Sheet `#f2f4f4` | Grouped content, card clusters |
| Surface | Cool Mist `#ebeeef` | Standard elevated blocks |
| Interactive | Pure White `#ffffff` | Active cards, focused inputs |

**Ambient Shadows** are reserved for truly floating elements only (FABs, modals):
- Shadow color: Crimson Heart at 10% opacity
- Blur: 32px
- Y-offset: 12px
- This mimics a colored light source, not a gray shadow

---

## 7. Screen Catalog

Reference screens in the Stitch project:

| Screen | ID | Width | Height |
|--------|-----|-------|--------|
| **Login (Light Mode)** | `265c16f1397543c9aa9cfaae453117cc` | 780 | 1768 |
| **Login Screen (Dark Mode)** | `ffa921cbbcbf4f0e8da814b091f98bf0` | 780 | 1768 |
| **Registration** | `fc982a47dd6f471dbf13f3eba93148c5` | 780 | 2104 |
| **Registration (Dark Mode)** | `55d07d5fb3234ba4aee67d218576d052` | 780 | 2120 |
| Dashboard | `3ab1efbc1cae40f0addcd6c61906a3b3` | 780 | 4556 |
| Dashboard (Dark) | `675d1f82285f44d9a43749ea9e77aadd` | 780 | 4678 |
| Dashboard (Improved Contrast) | `8eb8bfbba7a64587aca86008bd57fee8` | 780 | 4556 |
| Dashboard Dark (Improved Contrast) | `c1a1f55c852640d8b8d113e843378264` | 780 | 4678 |
| Trades | `3812a2a0a6084fcbaf13dfc7aef18005` | 780 | 3138 |
| Trades (Dark) | `4cdddb6f58cf43489e911c4e7d41ca7b` | 780 | 5196 |
| Trade Details | `525db91be61e436f93e86fbe116689d8` | 780 | 5078 |
| Trade Details (Dark) | `31565e6169264132840da794013366e4` | 780 | 4722 |
| Profile | `b2b7af3d68514a2d98e7fd134c156f26` | 780 | 4130 |
| Profile (Dark) | `7c1317496bdf41d1b6654242210c593a` | 780 | 3040 |
| Profile (Improved Contrast) | `3efde40bc15e4cfaa7d31de9fd419f68` | 780 | 4084 |
| Profile Dark (Improved Contrast) | `ac6d76fd2716433ba4c9c266c693fe53` | 780 | 3040 |

---

## 8. Do's and Don'ts

### Do
- Use extreme whitespace (32px+) between major sections to let the data "breathe"
- Use Forest Depth (`#006f05`) for all "Win" states — a calming, sophisticated green
- Lean into asymmetry — left-align headlines, right-align key data
- Use tonal layering for depth instead of shadows
- Use ghost borders at 15% opacity when needed

### Don'ts
- Never use pure black (`#000000`) — always Charcoal Ink (`#2d3435`)
- Never use standard Material Design elevations — stick to Tonal Layering
- Never use icons without labels for primary navigation
- Never use "Alert Red" for errors — use Muted Brick (`#9e422c`) for professional feel
- Never use 1px solid borders for sectioning — use background color shifts instead
