# Graph Report - TradeTrackr  (2026-05-04)

## Corpus Check
- 201 files · ~123,289 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1471 nodes · 3017 edges · 92 communities detected
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 23 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `5cf948cc`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]
- [[_COMMUNITY_Community 33|Community 33]]
- [[_COMMUNITY_Community 34|Community 34]]
- [[_COMMUNITY_Community 35|Community 35]]
- [[_COMMUNITY_Community 36|Community 36]]
- [[_COMMUNITY_Community 37|Community 37]]
- [[_COMMUNITY_Community 38|Community 38]]
- [[_COMMUNITY_Community 39|Community 39]]
- [[_COMMUNITY_Community 40|Community 40]]
- [[_COMMUNITY_Community 41|Community 41]]
- [[_COMMUNITY_Community 42|Community 42]]
- [[_COMMUNITY_Community 43|Community 43]]
- [[_COMMUNITY_Community 44|Community 44]]
- [[_COMMUNITY_Community 45|Community 45]]
- [[_COMMUNITY_Community 46|Community 46]]
- [[_COMMUNITY_Community 47|Community 47]]
- [[_COMMUNITY_Community 48|Community 48]]
- [[_COMMUNITY_Community 49|Community 49]]
- [[_COMMUNITY_Community 50|Community 50]]
- [[_COMMUNITY_Community 51|Community 51]]
- [[_COMMUNITY_Community 52|Community 52]]
- [[_COMMUNITY_Community 53|Community 53]]
- [[_COMMUNITY_Community 54|Community 54]]
- [[_COMMUNITY_Community 55|Community 55]]
- [[_COMMUNITY_Community 56|Community 56]]
- [[_COMMUNITY_Community 57|Community 57]]
- [[_COMMUNITY_Community 58|Community 58]]
- [[_COMMUNITY_Community 59|Community 59]]
- [[_COMMUNITY_Community 60|Community 60]]
- [[_COMMUNITY_Community 61|Community 61]]
- [[_COMMUNITY_Community 62|Community 62]]
- [[_COMMUNITY_Community 63|Community 63]]
- [[_COMMUNITY_Community 64|Community 64]]
- [[_COMMUNITY_Community 65|Community 65]]
- [[_COMMUNITY_Community 66|Community 66]]
- [[_COMMUNITY_Community 67|Community 67]]
- [[_COMMUNITY_Community 68|Community 68]]
- [[_COMMUNITY_Community 69|Community 69]]
- [[_COMMUNITY_Community 70|Community 70]]
- [[_COMMUNITY_Community 71|Community 71]]
- [[_COMMUNITY_Community 72|Community 72]]
- [[_COMMUNITY_Community 73|Community 73]]
- [[_COMMUNITY_Community 74|Community 74]]
- [[_COMMUNITY_Community 75|Community 75]]
- [[_COMMUNITY_Community 76|Community 76]]
- [[_COMMUNITY_Community 77|Community 77]]
- [[_COMMUNITY_Community 78|Community 78]]
- [[_COMMUNITY_Community 79|Community 79]]
- [[_COMMUNITY_Community 80|Community 80]]
- [[_COMMUNITY_Community 81|Community 81]]
- [[_COMMUNITY_Community 82|Community 82]]
- [[_COMMUNITY_Community 83|Community 83]]
- [[_COMMUNITY_Community 84|Community 84]]
- [[_COMMUNITY_Community 85|Community 85]]
- [[_COMMUNITY_Community 86|Community 86]]
- [[_COMMUNITY_Community 87|Community 87]]
- [[_COMMUNITY_Community 88|Community 88]]
- [[_COMMUNITY_Community 89|Community 89]]
- [[_COMMUNITY_Community 90|Community 90]]
- [[_COMMUNITY_Community 91|Community 91]]

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 118 edges
2. `package:flutter_riverpod/flutter_riverpod.dart` - 48 edges
3. `../presentation/providers/di_providers.dart` - 47 edges
4. `../../../core/extensions/context_extensions.dart` - 36 edges
5. `package:google_fonts/google_fonts.dart` - 36 edges
6. `../core/result.dart` - 34 edges
7. `package:go_router/go_router.dart` - 26 edges
8. `../../domain/entities/closed_position.dart` - 26 edges
9. `_` - 25 edges
10. `_` - 25 edges

## Surprising Connections (you probably didn't know these)
- `ClosedPosition Entity` --semantically_similar_to--> `Tonal Layering`  [INFERRED] [semantically similar]
  ARCHITECTURE.md → DESIGN.md
- `Result<T> Pattern` --semantically_similar_to--> `TradeFormState Freezed Union`  [INFERRED] [semantically similar]
  RESULT_PATTERN.md → FREEZED_GUIDE.md
- `ImportState Freezed Union` --conceptually_related_to--> `Riverpod (flutter_riverpod)`  [INFERRED]
  FREEZED_GUIDE.md → CLAUDE.md
- `Result<T> Pattern` --conceptually_related_to--> `Repository Segregation Pattern`  [INFERRED]
  RESULT_PATTERN.md → ARCHITECTURE.md
- `_` --defines--> `debugGetCreateSourceHash`  [EXTRACTED]
  app/app.g.dart → lib/app/app.g.dart

## Hyperedges (group relationships)
- **Clean Architecture Tri-Layer System** — presentation_layer, domain_layer, data_layer [EXTRACTED 1.00]
- **Offline-First Sync Pipeline** — drift, supabase, sync_engine, connectivity_checker [EXTRACTED 1.00]
- **Code Generation Toolchain** — build_runner, freezed, drift, riverpod [EXTRACTED 1.00]

## Communities (125 total, 7 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.05
Nodes (74): build, dispose, LoginPage, _LoginPageState, PopScope, SizedBox, SnackBar, _ActionButton (+66 more)

### Community 1 - "Community 1"
Cohesion: 0.07
Nodes (41): ../core/result.dart, ../core/usecase.dart, ../../domain/repositories/auth_repository.dart, ../entities/closed_position.dart, ../entities/recommendation.dart, ../entities/trade_analytics.dart, ../entities/trade_filter.dart, ../entities/user.dart (+33 more)

### Community 2 - "Community 2"
Cohesion: 0.06
Nodes (52): form_field_label.dart, build, _buildProfitDisplay, ClosePositionSheet, _ClosePositionSheetState, Container, dispose, Expanded (+44 more)

### Community 3 - "Community 3"
Cohesion: 0.07
Nodes (46): chart_container.dart, build, ChartContainer, EquityCurveChart, _EquityCurveChartState, _formatYValue, LineChart, LineTooltipItem (+38 more)

### Community 4 - "Community 4"
Cohesion: 0.07
Nodes (50): ../../../core/extensions/context_extensions.dart, responsiveEdgeInsets, responsiveFontSize, responsiveHeight, responsivePadding, responsiveSpacing, responsiveWidth, _BentoMetrics (+42 more)

### Community 5 - "Community 5"
Cohesion: 0.07
Nodes (48): build, _buildExportTab, _buildImportTab, _buildTopBar, _CheckboxRow, _FormatRow, GestureDetector, ImportExportPage (+40 more)

### Community 6 - "Community 6"
Cohesion: 0.08
Nodes (44): build, dispose, _FieldLabel, Padding, ProfileEditPage, _ProfileEditPageState, Scaffold, SingleChildScrollView (+36 more)

### Community 7 - "Community 7"
Cohesion: 0.09
Nodes (38): Freezed 3.x abstract Keyword Requirement, build_runner Code Generation, Clean Architecture, CloseReason Enum, ClosedPosition Entity, ConnectivityChecker, Context7 Documentation Rule, CSV Import/Export Format (+30 more)

### Community 8 - "Community 8"
Cohesion: 0.12
Nodes (24): Align, build, Center, ResponsiveCenter, ResponsiveCentered, ResponsiveScaffold, Scaffold, build (+16 more)

### Community 9 - "Community 9"
Cohesion: 0.11
Nodes (19): RegisterPlugins(), FlutterWindow(), OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable(), GetClientArea(), GetThisFromHandle() (+11 more)

### Community 10 - "Community 10"
Cohesion: 0.16
Nodes (25): _, appDatabase, ClosedPositionData, ClosedPositionsCompanion, copyWith, copyWithCompanion, create, debugGetCreateSourceHash (+17 more)

### Community 11 - "Community 11"
Cohesion: 0.16
Nodes (23): appDatabase, authRemoteDataSource, AuthRemoteDataSourceImpl, authRepository, AuthRepositoryImpl, supabaseClient, tradeCommandRepository, TradeCommandRepositoryImpl (+15 more)

### Community 12 - "Community 12"
Cohesion: 0.16
Nodes (22): AddTradePage, _AddTradePageState, build, _buildDateTimePicker, _buildPositionTypeToggle, _buildReasonDropdown, _buildSideToggle, Container (+14 more)

### Community 13 - "Community 13"
Cohesion: 0.14
Nodes (18): add_finance_page.dart, build, _buildFinanceList, _buildTopBar, Container, _FinanceCard, FinancePage, _formatDate (+10 more)

### Community 14 - "Community 14"
Cohesion: 0.14
Nodes (20): build, _drawCandlestick, _drawLabel, _drawSparkle, LayoutBuilder, _Onboarding1Painter, _Onboarding2Painter, _Onboarding3Painter (+12 more)

### Community 15 - "Community 15"
Cohesion: 0.17
Nodes (21): _ActionButtons, build, Center, Column, Container, _formatDateTime, _formatDuration, _HeroPnlCard (+13 more)

### Community 16 - "Community 16"
Cohesion: 0.15
Nodes (15): ../../data/datasources/auth_remote_data_source.dart, ../../data/datasources/user_remote_data_source.dart, ../../data/repositories/auth_repository_impl.dart, ../../data/repositories/user_profile_repository_impl.dart, ../datasources/auth_remote_data_source.dart, ../datasources/user_remote_data_source.dart, ../../domain/entities/user.dart, ../../domain/repositories/user_profile_repository.dart (+7 more)

### Community 17 - "Community 17"
Cohesion: 0.19
Nodes (14): core/constants/supabase_constants.dart, core/sync/sync_callback.dart, AuthRefreshNotifier, OnboardingRefreshNotifier, SupabaseConstants, callbackDispatcher, ProviderScope, _setupGlobalErrorHandling (+6 more)

### Community 18 - "Community 18"
Cohesion: 0.19
Nodes (18): AddFinancePage, _AddFinancePageState, build, _buildDateTimePicker, _buildTypeToggle, dispose, Exception, _FieldLabel (+10 more)

### Community 19 - "Community 19"
Cohesion: 0.19
Nodes (15): ../../data/repositories/trade_command_repository_impl.dart, ../../data/repositories/trade_query_repository_impl.dart, ../datasources/trade_local_data_source.dart, ../../domain/core/result.dart, ../../domain/enums/close_reason.dart, TradeCommandRepositoryImpl, _computeAnalytics, TradeAnalytics (+7 more)

### Community 20 - "Community 20"
Cohesion: 0.21
Nodes (16): AppTypography, bodyLarge, bodyMedium, bodySmall, buildResponsiveTextTheme, buildTextTheme, displayLarge, displayMedium (+8 more)

### Community 21 - "Community 21"
Cohesion: 0.22
Nodes (18): class, error, identical, offline, orElse, pending, StateError, synced (+10 more)

### Community 22 - "Community 22"
Cohesion: 0.2
Nodes (14): ../../domain/entities/open_position.dart, ../../domain/entities/trade_filter.dart, ../../domain/repositories/trade_command_repository.dart, ../../domain/repositories/trade_query_repository.dart, ../entities/finance_record.dart, ../entities/open_position.dart, ../enums/close_reason.dart, ../enums/trade_side.dart (+6 more)

### Community 23 - "Community 23"
Cohesion: 0.22
Nodes (18): addClosedPosition, addOpenPosition, call, closeOpenPosition, create, debugGetCreateSourceHash, deleteClosedPosition, deleteOpenPosition (+10 more)

### Community 24 - "Community 24"
Cohesion: 0.22
Nodes (15): appDatabase, authRemoteDataSource, authRepository, create, debugGetCreateSourceHash, overrideWithValue, supabaseClient, tradeCommandRepository (+7 more)

### Community 25 - "Community 25"
Cohesion: 0.25
Nodes (11): auth_provider.dart, di_providers.dart, Auth, Exception, Exception, Profile, Exception, OpenPositions (+3 more)

### Community 26 - "Community 26"
Cohesion: 0.22
Nodes (11): ../../domain/entities/recommendation.dart, ../../domain/entities/trade_analytics.dart, ../../domain/enums/severity.dart, TradeAnalytics, MockData, Recommendation, build, GestureDetector (+3 more)

### Community 27 - "Community 27"
Cohesion: 0.25
Nodes (16): class, error, identical, idle, ImportError, ImportIdle, ImportLoading, ImportSuccess (+8 more)

### Community 28 - "Community 28"
Cohesion: 0.19
Nodes (7): ImportResultDto, toEntity, User, UserDto, ImportState, SyncStatusState, package:freezed_annotation/freezed_annotation.dart

### Community 29 - "Community 29"
Cohesion: 0.23
Nodes (11): app_colors.dart, app_component_themes.dart, app_typography.dart, AppComponentThemes, BottomNavigationBarThemeData, FloatingActionButtonThemeData, AppTheme, _buildTheme (+3 more)

### Community 30 - "Community 30"
Cohesion: 0.14
Nodes (4): fl_register_plugins(), main(), my_application_activate(), my_application_new()

### Community 31 - "Community 31"
Cohesion: 0.24
Nodes (9): ../../app/theme/app_colors.dart, AppColors, build, FormFieldLabel, Padding, build, PrimaryButton, SizedBox (+1 more)

### Community 32 - "Community 32"
Cohesion: 0.26
Nodes (12): ../constants/app_constants.dart, DateFormat, DateTime, DateUtils, endOfDay, formatCsvDate, formatDisplayDate, formatDisplayDateTime (+4 more)

### Community 33 - "Community 33"
Cohesion: 0.28
Nodes (12): ../../data/datasources/drift/database.dart, AppDatabase, ClosedPositions, driftDatabase, FinanceRecords, into, MigrationStrategy, _openConnection (+4 more)

### Community 34 - "Community 34"
Cohesion: 0.26
Nodes (10): ../../core/network/connectivity_checker.dart, ConnectivityChecker, connectivityChecker, _initializeWorkmanager, _listenToConnectivity, performPeriodicSync, SyncController, syncEngine (+2 more)

### Community 35 - "Community 35"
Cohesion: 0.23
Nodes (10): ../../core/sync/sync_engine.dart, dart:async, ../../data/datasources/trade_local_data_source.dart, ../../data/datasources/trade_remote_data_source.dart, dispose, SyncEngine, TradeLocalDataSource, TradeRemoteDataSource (+2 more)

### Community 36 - "Community 36"
Cohesion: 0.26
Nodes (10): GoRouter, MainShell, TradeDetailPage, hasCompletedOnboarding, OnboardingNotifier, main_shell.dart, package:shared_preferences/shared_preferences.dart, ../presentation/pages/pages.dart (+2 more)

### Community 37 - "Community 37"
Cohesion: 0.28
Nodes (11): AnimatedBuilder, build, builder, dispose, Function, initState, LinearGradient, ShaderMask (+3 more)

### Community 38 - "Community 38"
Cohesion: 0.3
Nodes (11): ../../data/datasources/trade_local_data_source_impl.dart, drift/database.dart, ClosedPositionsCompanion, FinanceRecordsCompanion, _mapToClosedPositionCompanion, _mapToFinanceRecordCompanion, _mapToOpenPositionCompanion, OpenPositionsCompanion (+3 more)

### Community 39 - "Community 39"
Cohesion: 0.24
Nodes (8): ../../domain/entities/finance_record.dart, ../../domain/enums/finance_type.dart, ../enums/finance_type.dart, FinanceRecord, FinanceRecordDto, toEntity, FinanceRecord, FinanceType

### Community 40 - "Community 40"
Cohesion: 0.27
Nodes (9): date_range_picker.dart, ../../domain/enums/trade_side.dart, calculateProfit, TradeSide, AnalyticsFilterBar, build, Column, SizedBox (+1 more)

### Community 41 - "Community 41"
Cohesion: 0.3
Nodes (10): build, ClipRect, GestureDetector, _GlassBottomNav, _handleTabTap, MainShell, _NavTab, _NavTabItem (+2 more)

### Community 42 - "Community 42"
Cohesion: 0.33
Nodes (10): ../../core/logger/app_logger.dart, ../errors/failures.dart, AuthFailure, CsvParseFailure, DatabaseFailure, logFailure, NetworkFailure, setLogLevel (+2 more)

### Community 43 - "Community 43"
Cohesion: 0.33
Nodes (10): app/app.dart, build, didChangeAppLifecycleState, dispose, handleAppLifecycleState, initState, TradeTrackrApp, TradeTrackrAppState (+2 more)

### Community 44 - "Community 44"
Cohesion: 0.33
Nodes (10): dart:io, ../../data/repositories/trade_import_repository_impl.dart, FormatException, _parseCloseReason, _parseDateTime, _parseDouble, _parseFinanceType, _parseSide (+2 more)

### Community 45 - "Community 45"
Cohesion: 0.29
Nodes (8): ../../domain/entities/closed_position.dart, ClosedPosition, ClosedPositionDto, OpenPosition, OpenPositionDto, toEntity, ClosedPosition, copyWith

### Community 46 - "Community 46"
Cohesion: 0.31
Nodes (8): auth_remote_data_source.dart, ../../data/datasources/auth_remote_data_source_impl.dart, ../../data/datasources/trade_remote_data_source_impl.dart, AuthFailure, AuthRemoteDataSourceImpl, TradeRemoteDataSourceImpl, package:supabase_flutter/supabase_flutter.dart, trade_remote_data_source.dart

### Community 47 - "Community 47"
Cohesion: 0.36
Nodes (9): ../../core/errors/failures.dart, AuthFailure, CsvParseFailure, DatabaseFailure, Failure, NetworkFailure, SyncFailure, toString (+1 more)

### Community 48 - "Community 48"
Cohesion: 0.4
Nodes (10): _, class, Failure, identical, orElse, StateError, Success, _then (+2 more)

### Community 49 - "Community 49"
Cohesion: 0.36
Nodes (9): dart:ui, build, ClipRect, GestureDetector, NavigationRailWidget, _NavTab, _RailTabItem, SizedBox (+1 more)

### Community 50 - "Community 50"
Cohesion: 0.4
Nodes (10): _, class, _ClosedPositionDto, identical, _OpenPositionDto, orElse, StateError, _then (+2 more)

### Community 51 - "Community 51"
Cohesion: 0.4
Nodes (10): _, class, EqualUnmodifiableListView, identical, _ImportResultDto, orElse, StateError, _then (+2 more)

### Community 52 - "Community 52"
Cohesion: 0.36
Nodes (8): capitalize, formatNumber, formatPercentage, isBlank, isNotEmpty, isNullOrEmpty, StringUtils, truncate

### Community 53 - "Community 53"
Cohesion: 0.22
Nodes (3): FlutterAppDelegate, FlutterImplicitEngineDelegate, AppDelegate

### Community 54 - "Community 54"
Cohesion: 0.39
Nodes (8): build, setDark, setLight, setSystem, setTheme, Theme, toggleTheme, ../presentation/providers/theme_provider.dart

### Community 55 - "Community 55"
Cohesion: 0.44
Nodes (9): authState, create, debugGetCreateSourceHash, overrideWithValue, runBuild, supabaseAuthState, supabaseAuthStateStream, _ (+1 more)

### Community 56 - "Community 56"
Cohesion: 0.44
Nodes (9): create, debugGetCreateSourceHash, formattedBalance, formattedTotalPnL, formattedWinRate, overrideWithValue, runBuild, _ (+1 more)

### Community 57 - "Community 57"
Cohesion: 0.39
Nodes (7): ChartMockData, _DayProfit, _EquityPoint, _PLBucket, _ReasonCount, _SessionProfit, _SymbolPerf

### Community 58 - "Community 58"
Cohesion: 0.39
Nodes (7): build, builder, Function, LayoutBuilder, mobile, ResponsiveBreakpointBuilder, ResponsiveBuilder

### Community 59 - "Community 59"
Cohesion: 0.39
Nodes (7): build, dispose, FilterBar, _FilterBarState, Padding, Row, SizedBox

### Community 60 - "Community 60"
Cohesion: 0.44
Nodes (9): _, class, _FinanceRecordDto, identical, orElse, StateError, _then, toString (+1 more)

### Community 61 - "Community 61"
Cohesion: 0.44
Nodes (9): _, class, identical, orElse, StateError, _then, toString, _UserDto (+1 more)

### Community 62 - "Community 62"
Cohesion: 0.39
Nodes (7): ResponsiveBorderRadius, ResponsiveBreakpoints, ResponsiveGridColumns, ResponsiveIconSize, ResponsivePadding, ResponsiveScale, ResponsiveSpacing

### Community 63 - "Community 63"
Cohesion: 0.5
Nodes (8): connectivityChecker, create, debugGetCreateSourceHash, overrideWithValue, runBuild, syncEngine, _, _

### Community 64 - "Community 64"
Cohesion: 0.43
Nodes (6): build, DateRangePicker, _formatDate, GestureDetector, SizedBox, Theme

### Community 65 - "Community 65"
Cohesion: 0.43
Nodes (6): build, Container, Function, GestureDetector, PillOption, PillToggle

### Community 66 - "Community 66"
Cohesion: 0.38
Nodes (5): ../../data/repositories/trade_export_repository_impl.dart, ../../domain/repositories/trade_export_repository.dart, TradeExportRepositoryImpl, TradeExportRepository, package:csv/csv.dart

### Community 67 - "Community 67"
Cohesion: 0.57
Nodes (7): _, build, create, debugGetCreateSourceHash, overrideWithValue, runBuild, _

### Community 68 - "Community 68"
Cohesion: 0.57
Nodes (7): build, create, debugGetCreateSourceHash, overrideWithValue, runBuild, _, _

### Community 69 - "Community 69"
Cohesion: 0.57
Nodes (7): create, debugGetCreateSourceHash, hasCompletedOnboarding, overrideWithValue, runBuild, _, _

### Community 70 - "Community 70"
Cohesion: 0.57
Nodes (7): build, create, debugGetCreateSourceHash, overrideWithValue, runBuild, _, _

### Community 71 - "Community 71"
Cohesion: 0.48
Nodes (5): build, Function, GestureDetector, MultiSelectChip, Wrap

### Community 72 - "Community 72"
Cohesion: 0.48
Nodes (5): build, ChartContainer, Container, SizedBox, ../section_label.dart

### Community 73 - "Community 73"
Cohesion: 0.47
Nodes (4): wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16()

### Community 74 - "Community 74"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), NSWindow, MainFlutterWindow

### Community 75 - "Community 75"
Cohesion: 0.53
Nodes (5): ../../data/datasources/user_remote_data_source_impl.dart, AuthFailure, DatabaseFailure, UserRemoteDataSourceImpl, user_remote_data_source.dart

### Community 76 - "Community 76"
Cohesion: 0.53
Nodes (4): build, Container, SizedBox, StatusBadge

### Community 78 - "Community 78"
Cohesion: 0.6
Nodes (4): ../../domain/repositories/trade_import_repository.dart, ImportResult, toString, TradeImportRepository

### Community 79 - "Community 79"
Cohesion: 0.6
Nodes (3): NoParams, UseCase, result.dart

### Community 80 - "Community 80"
Cohesion: 0.8
Nodes (5): create, debugGetCreateSourceHash, runBuild, _, _

### Community 81 - "Community 81"
Cohesion: 0.8
Nodes (5): create, debugGetCreateSourceHash, runBuild, _, _

### Community 82 - "Community 82"
Cohesion: 0.6
Nodes (3): AppTextFormField, build, TextFormField

### Community 83 - "Community 83"
Cohesion: 0.6
Nodes (3): build, Container, SideChip

### Community 84 - "Community 84"
Cohesion: 0.6
Nodes (3): build, Container, PricingRow

### Community 85 - "Community 85"
Cohesion: 0.6
Nodes (3): build, Padding, SectionLabel

## Knowledge Gaps
- **10 isolated node(s):** `-registerWithRegistry`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `MainActivity`, `Flutter SDK 3.x`, `CloseReason Enum` (+5 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `Community 31` to `Community 0`, `Community 2`, `Community 3`, `Community 4`, `Community 5`, `Community 6`, `Community 8`, `Community 12`, `Community 13`, `Community 14`, `Community 15`, `Community 17`, `Community 18`, `Community 20`, `Community 26`, `Community 29`, `Community 36`, `Community 37`, `Community 40`, `Community 41`, `Community 43`, `Community 49`, `Community 54`, `Community 58`, `Community 59`, `Community 64`, `Community 65`, `Community 71`, `Community 72`, `Community 76`, `Community 82`, `Community 83`, `Community 84`, `Community 85`?**
  _High betweenness centrality (0.254) - this node is a cross-community bridge._
- **Why does `../presentation/providers/di_providers.dart` connect `Community 11` to `Community 33`, `Community 1`, `Community 35`, `Community 66`, `Community 38`, `Community 43`, `Community 75`, `Community 44`, `Community 46`, `Community 78`, `Community 16`, `Community 19`, `Community 22`, `Community 25`?**
  _High betweenness centrality (0.094) - this node is a cross-community bridge._
- **Why does `package:flutter_riverpod/flutter_riverpod.dart` connect `Community 17` to `Community 0`, `Community 3`, `Community 36`, `Community 4`, `Community 6`, `Community 5`, `Community 42`, `Community 43`, `Community 12`, `Community 13`, `Community 15`, `Community 18`?**
  _High betweenness centrality (0.064) - this node is a cross-community bridge._
- **What connects `-registerWithRegistry`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.`, `MainActivity` to the rest of the system?**
  _10 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.07 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._