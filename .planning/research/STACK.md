# Technology Stack — Missing PRD v1 Features

**Project:** TradeTrackr
**Researched:** 2026-05-04
**Scope:** Libraries and patterns needed to complete 9 missing features
**Overall confidence:** HIGH

## Executive Summary

**No new packages are required.** All missing PRD v1 features can be implemented with the existing dependency set. The primary gap across every feature is not missing libraries — it's wiring: connecting existing domain/data layers to existing UI widgets.

Three packages (`csv`, `file_picker`, `share_plus`) should be upgraded to latest major versions because: (a) they have breaking API changes that affect how we'll write new code, (b) they are not yet used anywhere in the codebase, so upgrading is zero-cost, and (c) the new APIs are strictly better.

One package (`fl_chart`) should explicitly **not** be upgraded — all 6 chart widgets are already written against the 0.70.x API and the work is data wiring, not chart API changes.

Theme persistence is a one-liner wiring task using `shared_preferences` which is already at the latest version (2.5.5).

## Recommended Changes

### Upgrade: csv ^6.0.0 → ^8.0.0

| Attribute | Value |
|-----------|-------|
| **Current** | 6.0.0 (resolved in lockfile) |
| **Target** | ^8.0.0 |
| **Confidence** | HIGH — verified on pub.dev (published 46 days ago) |
| **Breaking** | Yes — `CsvToListConverter`/`ListToCsvConverter` → `csv.decode()`/`csv.encode()` |
| **Used in codebase** | Yes — `trade_import_repository_impl.dart` and `trade_export_repository_impl.dart` |

**Why upgrade:** The v8 API is strictly better for the import/export use case:
- `csv.decode(input)` replaces `CsvToListConverter().convert(input)` — cleaner
- `csv.encode(data)` replaces `ListToCsvConverter().convert(data)` — cleaner
- `csv.decodeWithHeaders(input)` returns `List<CsvRow>` with map-like access by column name — eliminates manual column-index mapping (`row[0]`, `row[1]`, etc.)
- Stream transformer support (`file.openRead().transform(csv.decoder)`) for large files
- Auto-delimiter detection
- Better handling of edge cases (malformed CSV, misplaced quotes)

**Migration impact:** The import/export repositories use v6 API in 5 locations:
- `trade_import_repository_impl.dart`: 4× `CsvToListConverter().convert()`
- `trade_export_repository_impl.dart`: 3× `ListToCsvConverter().convert()`

All are in partially-complete implementations with TODOs. This is the right time to upgrade.

```dart
// BEFORE (v6):
final rows = const CsvToListConverter().convert(input);
final position = ClosedPosition(
  symbol: row[1]?.toString() ?? '',   // manual index mapping
  // ...
);

// AFTER (v8):
final rows = csv.decode(input);
// OR with header access:
final rows = csv.decodeWithHeaders(input);
final position = ClosedPosition(
  symbol: row['Symbol'] ?? '',  // name-based access
  // ...
);
```

**Source:** pub.dev/packages/csv v8.0.0 README — verified 2026-05-04

---

### Upgrade: file_picker ^9.2.3 → ^11.0.2

| Attribute | Value |
|-----------|-------|
| **Current** | 9.2.3 (resolved in lockfile) |
| **Target** | ^11.0.2 |
| **Confidence** | HIGH — verified on pub.dev (published 28 days ago) |
| **Breaking** | Yes — `FilePicker.platform.pickFiles()` → `FilePicker.pickFiles()` |
| **Used in codebase** | No — zero imports, zero usage |

**Why upgrade:** v11 introduces a cleaner static API and is required for the CSV export save dialog:
- `FilePicker.pickFiles()` — static method, no `.platform.` indirection
- `FilePicker.saveFile(bytes: ..., fileName: ...)` — cross-platform save dialog (desktop: save-as dialog, mobile: save to Downloads, web: trigger download). Essential for CSV export.
- Platform support: Android, iOS, Linux, macOS, Windows, Web — all 6 TradeTrackr targets

**Zero migration cost:** No existing code uses `file_picker`. The CSV import page UI is a shell with no file picker wired. We write new code against v11 API from scratch.

```dart
// CSV Import — pick a CSV file
final result = await FilePicker.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['csv'],
  withData: true,  // load bytes for immediate parsing
);
if (result != null) {
  final bytes = result.files.first.bytes;
  final csvString = utf8.decode(bytes);
  // parse with csv package...
}

// CSV Export — save file (all platforms)
final csvData = utf8.encode(csvString);
await FilePicker.saveFile(
  fileName: 'trades_export_${DateTime.now().toIso8601String().split('T')[0]}.csv',
  bytes: Uint8List.fromList(csvData),
  type: FileType.custom,
  allowedExtensions: ['csv'],
);
```

**Source:** pub.dev/packages/file_picker v11.0.2 — verified 2026-05-04

---

### Upgrade: share_plus ^10.1.4 → ^13.1.0

| Attribute | Value |
|-----------|-------|
| **Current** | 10.1.4 (resolved in lockfile) |
| **Target** | ^13.1.0 |
| **Confidence** | HIGH — verified on pub.dev (published 13 days ago) |
| **Breaking** | Yes — `Share.share()` → `SharePlus.instance.share(ShareParams(...))` |
| **Used in codebase** | No — zero imports, zero usage |

**Why upgrade:** v13 replaces deprecated static methods with a cleaner instance-based API:
- `SharePlus.instance.share(ShareParams(files: [...], fileNameOverrides: [...]))` — replaces deprecated `Share.shareXFiles()`
- `ShareResult.status` — proper result handling (success / dismissed / unavailable)
- `fileNameOverrides` — control file names for `XFile.fromData()` exports
- File sharing not supported on Linux (only text) — acceptable for v1

**Zero migration cost:** No existing code uses `share_plus`. We write new code against v13 from scratch.

**Why use BOTH `file_picker.saveFile()` AND `share_plus`:**
- Desktop (Linux/macOS/Windows): `FilePicker.saveFile()` — native save-as dialog
- Mobile (Android/iOS): `SharePlus.instance.share()` — system share sheet (Save to Files, AirDrop, email, etc.)
- Web: `FilePicker.saveFile()` triggers browser download

```dart
// Mobile — share via system sheet
final csvBytes = utf8.encode(csvString);
final params = ShareParams(
  files: [XFile.fromData(csvBytes, mimeType: 'text/csv')],
  fileNameOverrides: ['trades_export.csv'],
  sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
);
final result = await SharePlus.instance.share(params);
```

**Source:** pub.dev/packages/share_plus v13.1.0 — verified 2026-05-04

---

### Stay: fl_chart ^0.70.2

| Attribute | Value |
|-----------|-------|
| **Current** | 0.70.2 (resolved in lockfile) |
| **Available** | 1.2.0 (latest) |
| **Confidence** | HIGH — verified on pub.dev |
| **Breaking if upgraded** | Yes — API changes between 0.x and 1.x |
| **Used in codebase** | Yes — 6 chart widgets, ~400 lines of fl_chart API usage |

**Why NOT upgrade:** All 6 chart widgets are already written and rendering correctly with mock data:

| Chart Widget | fl_chart Type | Lines |
|-------------|--------------|-------|
| `EquityCurveChart` | `LineChart` + `LineChartData` | 223 |
| `PlDistributionChart` | `BarChart` + `BarChartData` | ~60 |
| `WinLossBySymbolChart` | `BarChart` (grouped) | ~80 |
| `WinLossByReasonChart` | `PieChart` + `PieChartData` | 92 |
| `ProfitByDayChart` | `BarChart` | ~60 |
| `ProfitBySessionChart` | `BarChart` | ~60 |

The widgets use: `FlSpot`, `LineChartBarData`, `BarChartGroupData`, `BarChartRodData`, `PieChartSectionData`, `FlGridData`, `FlTitlesData`, `SideTitles`, `LineTouchData`, `BarTouchData`, `PieTouchData`, gradient fills, tooltips — all available in 0.70.x.

The actual work is **replacing mock data with real data from providers**. The chart APIs don't change. Upgrading to 1.x would require auditing all 6 widgets for breaking changes with zero feature benefit. This can be done as a separate maintenance pass after PRD v1 ships.

**Source:** Codebase analysis of `lib/presentation/widgets/charts/` — 6 chart files

---

### Already Current: shared_preferences 2.5.5

| Attribute | Value |
|-----------|-------|
| **Current** | 2.5.5 (resolved in lockfile — already latest) |
| **Latest** | 2.5.5 |
| **Confidence** | HIGH — verified on pub.dev (published 39 days ago) |

**No action needed.** The `^2.3.5` constraint in pubspec.yaml already resolved to the latest 2.5.5. Used for onboarding flag. Theme persistence just needs wiring:

```dart
// theme_provider.dart — current state
@Riverpod(keepAlive: true)
class Theme extends _$Theme {
  @override
  ThemeMode build() => ThemeMode.system; // TODO: add shared_preferences persistence

  // ...
}

// theme_provider.dart — after wiring
@Riverpod(keepAlive: true)
class Theme extends _$Theme {
  @override
  ThemeMode build() {
    // Read persisted theme, default to system
    _loadSavedTheme();
    return ThemeMode.system;
  }

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme_mode');
    if (saved != null) {
      state = ThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ThemeMode.system,
      );
    }
  }

  void setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', mode.name);
  }
  // ...
}
```

**Note:** The `SharedPreferences` API (synchronous reads after `getInstance()`) is being deprecated in favor of `SharedPreferencesAsync`. For storing a single theme string, the legacy API is perfectly fine and simpler. Migration to the async API can happen later.

**Source:** pub.dev/packages/shared_preferences v2.5.5 docs — verified 2026-05-04

## No Additional Libraries Needed

Every missing feature is implementable with the current stack:

### CSV Import — file_picker + csv + dart:io

| Need | Covered By | Status |
|------|-----------|--------|
| File picker dialog | `file_picker` v11 (after upgrade) | Upgrade needed |
| CSV parsing | `csv` v8 (after upgrade) | Upgrade needed |
| Date format parsing | `intl` DateFormat + RegExp (already used) | Ready |
| Validation | Pure Dart logic | Build it |
| Duplicate detection | Drift DB query before insert | Build it |
| Summary report | `ImportResult` entity (already exists) | Ready |

### CSV Export — csv + file_picker + share_plus + path_provider

| Need | Covered By | Status |
|------|-----------|--------|
| CSV generation | `csv` v8 (after upgrade) | Upgrade needed |
| Desktop save dialog | `file_picker` v11 `saveFile()` | Upgrade needed |
| Mobile share sheet | `share_plus` v13 (after upgrade) | Upgrade needed |
| Web download | `file_picker` v11 `saveFile()` | Upgrade needed |
| Temp file path | `path_provider` 2.1.5 | Ready |
| File naming | `intl` date formatting | Ready |

### Open Positions + Close Flow — existing stack only

| Need | Covered By | Status |
|------|-----------|--------|
| Open positions query | `TradeQueryRepository.getOpenPositions()` | Ready |
| Close position form | `ClosePositionSheet` widget (exists) | Wire it |
| Auto-calculate profit | Pure Dart math | Build it |
| Persist closed position | `TradeCommandRepository` | Ready |
| Delete open position | `TradeCommandRepository` | Ready |

### Dashboard Analytics — existing stack only

| Need | Covered By | Status |
|------|-----------|--------|
| 13 metric computations | `TradeQueryRepository.getAnalytics()` → `TradeAnalytics` entity | Implement repo |
| 6 chart data feeds | Riverpod providers → chart widget params | Wire it |
| `fl_chart` rendering | 6 chart widgets (already built) | Wire it |

The 13 metrics map to existing `TradeAnalytics` fields: `totalTrades`, `openPositions`, `winRate`, `totalProfitLoss`, `averageProfit`, `largestWin`, `largestLoss`, `profitFactor`, `averageRiskRewardRatio`, `averageHoldingDuration`, `accountBalance`, `totalDeposits`, `totalWithdrawals`, `bestSymbol`, `worstSymbol`, `consecutiveLosses`.

### Dashboard Filters — Flutter SDK built-in

| Need | Covered By | Status |
|------|-----------|--------|
| Date range picker | Flutter `showDateRangePicker()` | Already implemented in `DateRangePicker` widget |
| Symbol filter | `MultiSelectChip` widget (exists) | Wire it |
| Side filter | `PillToggle<TradeSide>` (exists) | Wire it |
| Reason filter | `MultiSelectChip` widget (exists) | Wire it |
| Filter propagation | `TradeFilter` entity (exists) | Wire it |

The `DateRangePicker` widget at `lib/presentation/widgets/date_range_picker.dart` already uses Flutter's built-in `showDateRangePicker()`. No third-party date picker needed.

### Recommendation Engine — existing stack only

| Need | Covered By | Status |
|------|-----------|--------|
| 5 existing rules | `GetRecommendationsUseCase` (5 rules implemented) | Expand to 10 |
| Analytics data | `TradeAnalytics` entity (all fields needed are present) | Ready |
| Rule evaluation | Pure Dart logic | Build 5 more rules |

### Finance Page — existing stack only

| Need | Covered By | Status |
|------|-----------|--------|
| Finance records query | `TradeLocalDataSource.getAllFinanceRecords()` | Ready |
| Riverpod provider | Needs creation | Build it |
| UI page | Finance page exists (mock data) | Wire it |

### Edit/Delete Trade — existing stack only

| Need | Covered By | Status |
|------|-----------|--------|
| Update trade | `TradeCommandRepository` + `updateClosedPosition` | Ready |
| Delete trade | `delete_trade.dart` use case | Ready |
| UI confirmation | Flutter dialog | Build it |
| Navigation back | GoRouter (installed) | Ready |

### Theme Persistence — shared_preferences (already latest)

| Need | Covered By | Status |
|------|-----------|--------|
| Read persisted theme | `SharedPreferences.getInstance()` → `getString()` | Wire it |
| Write theme on change | `setString()` in setter methods | Wire it |
| Provider integration | `@Riverpod(keepAlive: true)` Theme notifier | Ready |

## Alternatives Considered

| Decision Point | Recommended | Alternative | Why Not |
|---------------|-------------|-------------|---------|
| CSV parsing | Upgrade `csv` to v8 | Stay on v6 | v6 API works but v8's `decodeWithHeaders()` eliminates manual column-index mapping — cleaner, less error-prone |
| CSV export save | `file_picker` `saveFile()` | `path_provider` + `dart:io` File | `saveFile()` gives cross-platform save dialog (desktop), system share (mobile), browser download (web) — `path_provider` only gets a directory path |
| CSV export mobile | `share_plus` v13 `SharePlus.instance` | `file_picker` `saveFile()` on mobile | Mobile `saveFile()` is limited — share sheet is the expected UX pattern on Android/iOS (Save to Files, AirDrop, etc.) |
| Chart library | Stay on `fl_chart` 0.70.x | Upgrade to fl_chart 1.x | 6 chart widgets already written, upgrading = churn with zero feature benefit. Defer. |
| Date range picker | Flutter SDK `showDateRangePicker()` | `syncfusion_flutter_datepicker` or `table_calendar` | Already implemented with built-in widget. No need for a heavy third-party package. |
| Theme storage | `shared_preferences` | `hive` or `isar` | Overkill for a single string value. `shared_preferences` is already installed and at latest version. |
| Import validation | Manual Dart validation | `freezed` validated DTOs | DTOs are already Freezed. Validation logic belongs in the import repository where format-specific rules apply. |

## Installation

```bash
# Upgrade packages (3 breaking changes, zero existing usage)
flutter pub add 'csv:^8.0.0' 'file_picker:^11.0.2' 'share_plus:^13.1.0'

# Then run code generation (may need rebuild after csv API migration)
dart run build_runner build --delete-conflicting-outputs
```

## Migration Checklist

After running `flutter pub add`:

- [ ] **csv v6 → v8**: Update `trade_import_repository_impl.dart` — replace `CsvToListConverter().convert()` with `csv.decode()`
- [ ] **csv v6 → v8**: Update `trade_export_repository_impl.dart` — replace `ListToCsvConverter().convert()` with `csv.encode()`
- [ ] **file_picker v11**: New usage in CSV import page — use `FilePicker.pickFiles()` static API
- [ ] **file_picker v11**: New usage in CSV export — use `FilePicker.saveFile()` for desktop/web
- [ ] **share_plus v13**: New usage in CSV export — use `SharePlus.instance.share(ShareParams(...))` for mobile
- [ ] **No changes needed** for fl_chart, shared_preferences, or any other package

## Sources

| Source | Confidence | What It Verified |
|--------|-----------|-----------------|
| pub.dev/packages/csv v8.0.0 README | HIGH | v8 API (`csv.decode()`, `csv.encode()`, `decodeWithHeaders()`) |
| pub.dev/packages/file_picker v11.0.2 docs | HIGH | `FilePicker.pickFiles()`, `FilePicker.saveFile()` static API, platform chart |
| pub.dev/packages/share_plus v13.1.0 docs | HIGH | `SharePlus.instance.share(ShareParams(...))` API, file sharing support matrix |
| pub.dev/packages/fl_chart v1.2.0 | HIGH | Latest version available, breaking from 0.70.x |
| pub.dev/packages/shared_preferences v2.5.5 | HIGH | Already latest in lockfile, `SharedPreferencesAsync` migration optional |
| Context7 /file_picker docs | HIGH | `pickFiles()` params, `saveFile()` params and platform behavior |
| Context7 /csv docs | HIGH | `CsvToListConverter` → `csv.decode()` migration, header parsing |
| Context7 /fl_chart docs | HIGH | LineChart, BarChart, PieChart API stability in 0.70.x |
| Context7 /share_plus docs | HIGH | `ShareParams`, `XFile.fromData()`, `fileNameOverrides` |
| Context7 /shared_preferences docs | HIGH | `SharedPreferences.getInstance()`, `setString()`, `getString()` |
| Codebase analysis — `pubspec.lock` | HIGH | Resolved versions: csv 6.0.0, file_picker 9.2.3, share_plus 10.1.4, fl_chart 0.70.2, shared_preferences 2.5.5 |
| Codebase analysis — `trade_import_repository_impl.dart` | HIGH | v6 API usage: `CsvToListConverter` in 4 locations |
| Codebase analysis — `trade_export_repository_impl.dart` | HIGH | v6 API usage: `ListToCsvConverter` in 3 locations |
| Codebase analysis — 6 chart widgets | HIGH | fl_chart 0.70.x API usage, mock data pattern |
| Codebase analysis — `theme_provider.dart` | HIGH | TODO comment for shared_preferences persistence |
