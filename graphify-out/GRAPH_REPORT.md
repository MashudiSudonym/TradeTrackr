# Graph Report - TradeTrackr  (2026-05-05)

## Corpus Check
- 227 files · ~136,479 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1535 nodes · 3076 edges · 84 communities detected
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 23 edges (avg confidence: 0.81)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `49ae5d71`
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
- [[_COMMUNITY_Community 93|Community 93]]

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 118 edges
2. `package:flutter_riverpod/flutter_riverpod.dart` - 48 edges
3. `../presentation/providers/di_providers.dart` - 47 edges
4. `../../../core/extensions/context_extensions.dart` - 36 edges
5. `package:google_fonts/google_fonts.dart` - 36 edges
6. `../core/result.dart` - 34 edges
7. `package:go_router/go_router.dart` - 27 edges
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
- `AppDelegate` --inherits--> `FlutterImplicitEngineDelegate`  [EXTRACTED]
  macos/Runner/AppDelegate.swift → ios/Runner/AppDelegate.swift

## Hyperedges (group relationships)
- **Clean Architecture Tri-Layer System** — presentation_layer, domain_layer, data_layer [EXTRACTED 1.00]
- **Offline-First Sync Pipeline** — drift, supabase, sync_engine, connectivity_checker [EXTRACTED 1.00]
- **Code Generation Toolchain** — build_runner, freezed, drift, riverpod [EXTRACTED 1.00]

## Communities (143 total, 7 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.05
Nodes (63): dart:io, ../../data/repositories/trade_command_repository_impl.dart, ../../data/repositories/trade_import_repository_impl.dart, ../../data/repositories/trade_query_repository_impl.dart, ../datasources/trade_local_data_source.dart, ../../domain/entities/closed_position.dart, ../../domain/entities/finance_record.dart, ../../domain/entities/open_position.dart (+55 more)

### Community 1 - "Community 1"
Cohesion: 0.05
Nodes (73): ../../../core/extensions/context_extensions.dart, responsiveEdgeInsets, responsiveFontSize, responsiveHeight, responsivePadding, responsiveSpacing, responsiveWidth, _BentoMetrics (+65 more)

### Community 2 - "Community 2"
Cohesion: 0.06
Nodes (63): ../core/result.dart, ../core/usecase.dart, ../../domain/repositories/trade_command_repository.dart, ../../domain/repositories/trade_import_repository.dart, ../../domain/repositories/trade_query_repository.dart, ../../domain/repositories/user_profile_repository.dart, ../../domain/usecases/add_trade.dart, ../../domain/usecases/delete_trade.dart (+55 more)

### Community 3 - "Community 3"
Cohesion: 0.06
Nodes (52): chart_container.dart, date_range_picker.dart, AnalyticsFilterBar, build, Column, SizedBox, build, ChartContainer (+44 more)

### Community 4 - "Community 4"
Cohesion: 0.06
Nodes (57): AddTradePage, GoRouter, MainShell, TradeDetailPage, build, dispose, LoginPage, _LoginPageState (+49 more)

### Community 5 - "Community 5"
Cohesion: 0.06
Nodes (51): ../constants/app_constants.dart, DateFormat, DateTime, DateUtils, endOfDay, formatCsvDate, formatDisplayDate, formatDisplayDateTime (+43 more)

### Community 6 - "Community 6"
Cohesion: 0.08
Nodes (43): AddFinancePage, _AddFinancePageState, build, _buildDateTimePicker, _buildTypeToggle, dispose, Exception, _FieldLabel (+35 more)

### Community 7 - "Community 7"
Cohesion: 0.1
Nodes (37): build, dispose, _FieldLabel, Padding, ProfileEditPage, _ProfileEditPageState, Scaffold, SingleChildScrollView (+29 more)

### Community 8 - "Community 8"
Cohesion: 0.1
Nodes (33): build, _buildExportTab, _buildImportTab, _buildTopBar, _CheckboxRow, _FormatRow, GestureDetector, ImportExportPage (+25 more)

### Community 9 - "Community 9"
Cohesion: 0.09
Nodes (38): Freezed 3.x abstract Keyword Requirement, build_runner Code Generation, Clean Architecture, CloseReason Enum, ClosedPosition Entity, ConnectivityChecker, Context7 Documentation Rule, CSV Import/Export Format (+30 more)

### Community 10 - "Community 10"
Cohesion: 0.09
Nodes (34): addTradeUseCase, appDatabase, authRemoteDataSource, AuthRemoteDataSourceImpl, authRepository, AuthRepositoryImpl, deleteTradeUseCase, exportTradesUseCase (+26 more)

### Community 11 - "Community 11"
Cohesion: 0.11
Nodes (31): build, _buildDeleteAccountButton, _buildLogoutButton, _buildSectionLabel, _buildSettingsCards, _buildTopBar, CircularProgressIndicator, Column (+23 more)

### Community 12 - "Community 12"
Cohesion: 0.12
Nodes (24): Align, build, Center, ResponsiveCenter, ResponsiveCentered, ResponsiveScaffold, Scaffold, build (+16 more)

### Community 13 - "Community 13"
Cohesion: 0.11
Nodes (19): RegisterPlugins(), FlutterWindow(), OnCreate(), Create(), Destroy(), EnableFullDpiSupportIfAvailable(), GetClientArea(), GetThisFromHandle() (+11 more)

### Community 14 - "Community 14"
Cohesion: 0.11
Nodes (26): addTradeUseCase, appDatabase, authRemoteDataSource, authRepository, create, debugGetCreateSourceHash, deleteTradeUseCase, exportTradesUseCase (+18 more)

### Community 15 - "Community 15"
Cohesion: 0.14
Nodes (22): ../../domain/entities/recommendation.dart, ../../domain/enums/severity.dart, Recommendation, build, Center, _Content, RecommendationCard, RecommendationsPage (+14 more)

### Community 16 - "Community 16"
Cohesion: 0.15
Nodes (23): ../../data/datasources/drift/database.dart, ../../data/datasources/trade_local_data_source_impl.dart, drift/database.dart, AppDatabase, ClosedPositions, driftDatabase, FinanceRecords, into (+15 more)

### Community 17 - "Community 17"
Cohesion: 0.16
Nodes (25): _, appDatabase, ClosedPositionData, ClosedPositionsCompanion, copyWith, copyWithCompanion, create, debugGetCreateSourceHash (+17 more)

### Community 18 - "Community 18"
Cohesion: 0.19
Nodes (13): core/constants/supabase_constants.dart, core/sync/sync_callback.dart, AuthRefreshNotifier, OnboardingRefreshNotifier, SupabaseConstants, callbackDispatcher, ProviderScope, _setupGlobalErrorHandling (+5 more)

### Community 19 - "Community 19"
Cohesion: 0.21
Nodes (16): AppTypography, bodyLarge, bodyMedium, bodySmall, buildResponsiveTextTheme, buildTextTheme, displayLarge, displayMedium (+8 more)

### Community 20 - "Community 20"
Cohesion: 0.22
Nodes (18): class, error, identical, offline, orElse, pending, StateError, synced (+10 more)

### Community 21 - "Community 21"
Cohesion: 0.22
Nodes (18): addClosedPosition, addOpenPosition, call, closeOpenPosition, create, debugGetCreateSourceHash, deleteClosedPosition, deleteOpenPosition (+10 more)

### Community 22 - "Community 22"
Cohesion: 0.22
Nodes (11): Analytics, formattedBalance, formattedTotalPnL, formattedWinRate, hasCompletedOnboarding, OnboardingNotifier, Recommendations, ../mock/mock_data.dart (+3 more)

### Community 23 - "Community 23"
Cohesion: 0.25
Nodes (16): class, error, identical, idle, ImportError, ImportIdle, ImportLoading, ImportSuccess (+8 more)

### Community 24 - "Community 24"
Cohesion: 0.23
Nodes (14): build, _drawCandlestick, _drawLabel, _drawSparkle, LayoutBuilder, _Onboarding1Painter, _Onboarding2Painter, _Onboarding3Painter (+6 more)

### Community 25 - "Community 25"
Cohesion: 0.21
Nodes (12): ../../data/repositories/trade_export_repository_impl.dart, ../../data/repositories/user_profile_repository_impl.dart, ../datasources/user_remote_data_source.dart, ../../domain/core/result.dart, ../../domain/repositories/trade_export_repository.dart, TradeExportRepositoryImpl, setCurrentUserId, UserProfileRepositoryImpl (+4 more)

### Community 26 - "Community 26"
Cohesion: 0.19
Nodes (7): ImportResultDto, toEntity, User, UserDto, ImportState, SyncStatusState, package:freezed_annotation/freezed_annotation.dart

### Community 27 - "Community 27"
Cohesion: 0.19
Nodes (11): ../../data/datasources/auth_remote_data_source.dart, ../../data/datasources/user_remote_data_source.dart, ../../data/repositories/auth_repository_impl.dart, ../datasources/auth_remote_data_source.dart, ../../domain/entities/user.dart, ../../domain/repositories/auth_repository.dart, AuthRemoteDataSource, UserRemoteDataSource (+3 more)

### Community 28 - "Community 28"
Cohesion: 0.23
Nodes (11): app_colors.dart, app_component_themes.dart, app_typography.dart, AppComponentThemes, BottomNavigationBarThemeData, FloatingActionButtonThemeData, AppTheme, _buildTheme (+3 more)

### Community 29 - "Community 29"
Cohesion: 0.25
Nodes (13): form_field_label.dart, build, _buildProfitDisplay, ClosePositionSheet, _ClosePositionSheetState, Container, dispose, Expanded (+5 more)

### Community 30 - "Community 30"
Cohesion: 0.14
Nodes (4): fl_register_plugins(), main(), my_application_activate(), my_application_new()

### Community 31 - "Community 31"
Cohesion: 0.26
Nodes (12): add_finance_page.dart, build, _buildFinanceList, _buildTopBar, Container, _FinanceCard, FinancePage, _formatDate (+4 more)

### Community 32 - "Community 32"
Cohesion: 0.23
Nodes (10): ../../core/sync/sync_engine.dart, dart:async, ../../data/datasources/trade_local_data_source.dart, ../../data/datasources/trade_remote_data_source.dart, dispose, SyncEngine, TradeLocalDataSource, TradeRemoteDataSource (+2 more)

### Community 33 - "Community 33"
Cohesion: 0.26
Nodes (10): ../../core/network/connectivity_checker.dart, ConnectivityChecker, connectivityChecker, _initializeWorkmanager, _listenToConnectivity, performPeriodicSync, SyncController, syncEngine (+2 more)

### Community 34 - "Community 34"
Cohesion: 0.28
Nodes (11): AnimatedBuilder, build, builder, dispose, Function, initState, LinearGradient, ShaderMask (+3 more)

### Community 35 - "Community 35"
Cohesion: 0.3
Nodes (10): build, ClipRect, GestureDetector, _GlassBottomNav, _handleTabTap, MainShell, _NavTab, _NavTabItem (+2 more)

### Community 36 - "Community 36"
Cohesion: 0.33
Nodes (10): app/app.dart, build, didChangeAppLifecycleState, dispose, handleAppLifecycleState, initState, TradeTrackrApp, TradeTrackrAppState (+2 more)

### Community 37 - "Community 37"
Cohesion: 0.33
Nodes (10): ../../core/logger/app_logger.dart, ../errors/failures.dart, AuthFailure, CsvParseFailure, DatabaseFailure, logFailure, NetworkFailure, setLogLevel (+2 more)

### Community 38 - "Community 38"
Cohesion: 0.31
Nodes (7): auth_provider.dart, di_providers.dart, Auth, Exception, Exception, Profile, ../presentation/providers/auth_provider.dart

### Community 39 - "Community 39"
Cohesion: 0.36
Nodes (9): ../../core/errors/failures.dart, AuthFailure, CsvParseFailure, DatabaseFailure, Failure, NetworkFailure, SyncFailure, toString (+1 more)

### Community 40 - "Community 40"
Cohesion: 0.31
Nodes (8): auth_remote_data_source.dart, ../../data/datasources/auth_remote_data_source_impl.dart, ../../data/datasources/trade_remote_data_source_impl.dart, AuthFailure, AuthRemoteDataSourceImpl, TradeRemoteDataSourceImpl, package:supabase_flutter/supabase_flutter.dart, trade_remote_data_source.dart

### Community 41 - "Community 41"
Cohesion: 0.4
Nodes (10): _, class, Failure, identical, orElse, StateError, Success, _then (+2 more)

### Community 42 - "Community 42"
Cohesion: 0.36
Nodes (9): dart:ui, build, ClipRect, GestureDetector, NavigationRailWidget, _NavTab, _RailTabItem, SizedBox (+1 more)

### Community 43 - "Community 43"
Cohesion: 0.4
Nodes (10): _, class, _ClosedPositionDto, identical, _OpenPositionDto, orElse, StateError, _then (+2 more)

### Community 44 - "Community 44"
Cohesion: 0.4
Nodes (10): _, class, EqualUnmodifiableListView, identical, _ImportResultDto, orElse, StateError, _then (+2 more)

### Community 45 - "Community 45"
Cohesion: 0.36
Nodes (8): capitalize, formatNumber, formatPercentage, isBlank, isNotEmpty, isNullOrEmpty, StringUtils, truncate

### Community 46 - "Community 46"
Cohesion: 0.22
Nodes (3): FlutterAppDelegate, FlutterImplicitEngineDelegate, AppDelegate

### Community 47 - "Community 47"
Cohesion: 0.39
Nodes (8): build, setDark, setLight, setSystem, setTheme, Theme, toggleTheme, ../presentation/providers/theme_provider.dart

### Community 48 - "Community 48"
Cohesion: 0.44
Nodes (9): authState, create, debugGetCreateSourceHash, overrideWithValue, runBuild, supabaseAuthState, supabaseAuthStateStream, _ (+1 more)

### Community 49 - "Community 49"
Cohesion: 0.44
Nodes (9): create, debugGetCreateSourceHash, formattedBalance, formattedTotalPnL, formattedWinRate, overrideWithValue, runBuild, _ (+1 more)

### Community 50 - "Community 50"
Cohesion: 0.39
Nodes (7): ChartMockData, _DayProfit, _EquityPoint, _PLBucket, _ReasonCount, _SessionProfit, _SymbolPerf

### Community 51 - "Community 51"
Cohesion: 0.39
Nodes (7): build, dispose, FilterBar, _FilterBarState, Padding, Row, SizedBox

### Community 52 - "Community 52"
Cohesion: 0.39
Nodes (6): ../../app/theme/app_colors.dart, AppColors, build, PrimaryButton, SizedBox, package:flutter/material.dart

### Community 53 - "Community 53"
Cohesion: 0.39
Nodes (7): build, builder, Function, LayoutBuilder, mobile, ResponsiveBreakpointBuilder, ResponsiveBuilder

### Community 54 - "Community 54"
Cohesion: 0.44
Nodes (9): _, class, _FinanceRecordDto, identical, orElse, StateError, _then, toString (+1 more)

### Community 55 - "Community 55"
Cohesion: 0.44
Nodes (9): _, class, identical, orElse, StateError, _then, toString, _UserDto (+1 more)

### Community 56 - "Community 56"
Cohesion: 0.39
Nodes (7): ResponsiveBorderRadius, ResponsiveBreakpoints, ResponsiveGridColumns, ResponsiveIconSize, ResponsivePadding, ResponsiveScale, ResponsiveSpacing

### Community 57 - "Community 57"
Cohesion: 0.5
Nodes (8): connectivityChecker, create, debugGetCreateSourceHash, overrideWithValue, runBuild, syncEngine, _, _

### Community 58 - "Community 58"
Cohesion: 0.43
Nodes (6): build, DateRangePicker, _formatDate, GestureDetector, SizedBox, Theme

### Community 59 - "Community 59"
Cohesion: 0.43
Nodes (6): build, GestureDetector, _PageButton, PaginationBar, Row, SizedBox

### Community 60 - "Community 60"
Cohesion: 0.43
Nodes (6): build, Container, Function, GestureDetector, PillOption, PillToggle

### Community 61 - "Community 61"
Cohesion: 0.57
Nodes (7): _, build, create, debugGetCreateSourceHash, overrideWithValue, runBuild, _

### Community 62 - "Community 62"
Cohesion: 0.57
Nodes (7): build, create, debugGetCreateSourceHash, overrideWithValue, runBuild, _, _

### Community 63 - "Community 63"
Cohesion: 0.57
Nodes (7): create, debugGetCreateSourceHash, hasCompletedOnboarding, overrideWithValue, runBuild, _, _

### Community 64 - "Community 64"
Cohesion: 0.57
Nodes (7): build, create, debugGetCreateSourceHash, overrideWithValue, runBuild, _, _

### Community 65 - "Community 65"
Cohesion: 0.48
Nodes (5): build, Function, GestureDetector, MultiSelectChip, Wrap

### Community 66 - "Community 66"
Cohesion: 0.48
Nodes (5): build, ChartContainer, Container, SizedBox, ../section_label.dart

### Community 67 - "Community 67"
Cohesion: 0.47
Nodes (4): wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16()

### Community 68 - "Community 68"
Cohesion: 0.33
Nodes (3): RegisterGeneratedPlugins(), NSWindow, MainFlutterWindow

### Community 69 - "Community 69"
Cohesion: 0.53
Nodes (5): ../../data/datasources/user_remote_data_source_impl.dart, AuthFailure, DatabaseFailure, UserRemoteDataSourceImpl, user_remote_data_source.dart

### Community 71 - "Community 71"
Cohesion: 0.6
Nodes (3): NoParams, UseCase, result.dart

### Community 72 - "Community 72"
Cohesion: 0.8
Nodes (5): create, debugGetCreateSourceHash, runBuild, _, _

### Community 73 - "Community 73"
Cohesion: 0.8
Nodes (5): create, debugGetCreateSourceHash, runBuild, _, _

### Community 74 - "Community 74"
Cohesion: 0.6
Nodes (3): build, FormFieldLabel, Padding

### Community 75 - "Community 75"
Cohesion: 0.6
Nodes (3): AppTextFormField, build, TextFormField

### Community 76 - "Community 76"
Cohesion: 0.6
Nodes (3): build, Container, PricingRow

### Community 77 - "Community 77"
Cohesion: 0.6
Nodes (3): build, Padding, SectionLabel

## Knowledge Gaps
- **42 isolated node(s):** `FlutterSceneDelegate`, `-registerWithRegistry`, `FlutterAppDelegate`, `FlutterImplicitEngineDelegate`, `Intercept NOTIFY_DEBUGGER_ABOUT_RX_PAGES and touch the pages.` (+37 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **7 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `Community 52` to `Community 0`, `Community 1`, `Community 3`, `Community 4`, `Community 5`, `Community 6`, `Community 7`, `Community 8`, `Community 11`, `Community 12`, `Community 15`, `Community 18`, `Community 19`, `Community 24`, `Community 28`, `Community 29`, `Community 31`, `Community 34`, `Community 35`, `Community 36`, `Community 42`, `Community 47`, `Community 51`, `Community 53`, `Community 58`, `Community 59`, `Community 60`, `Community 65`, `Community 66`, `Community 74`, `Community 75`, `Community 76`, `Community 77`?**
  _High betweenness centrality (0.270) - this node is a cross-community bridge._
- **Why does `package:flutter_riverpod/flutter_riverpod.dart` connect `Community 18` to `Community 1`, `Community 3`, `Community 36`, `Community 4`, `Community 6`, `Community 7`, `Community 8`, `Community 37`, `Community 11`, `Community 15`, `Community 31`?**
  _High betweenness centrality (0.055) - this node is a cross-community bridge._
- **Why does `../presentation/providers/di_providers.dart` connect `Community 10` to `Community 32`, `Community 0`, `Community 2`, `Community 36`, `Community 69`, `Community 40`, `Community 16`, `Community 22`, `Community 25`, `Community 27`?**
  _High betweenness centrality (0.053) - this node is a cross-community bridge._
- **What connects `FlutterSceneDelegate`, `-registerWithRegistry`, `FlutterAppDelegate` to the rest of the system?**
  _42 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._
- **Should `Community 1` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._
- **Should `Community 2` be split into smaller, more focused modules?**
  _Cohesion score 0.06 - nodes in this community are weakly interconnected._