# Graph Report - .  (2026-05-04)

## Corpus Check
- 176 files · ~78,213 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1212 nodes · 1495 edges · 88 communities detected
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 15 edges (avg confidence: 0.81)
- Token cost: 45,000 input · 12,000 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Domain Use Cases|Domain Use Cases]]
- [[_COMMUNITY_Equity Curve Charts|Equity Curve Charts]]
- [[_COMMUNITY_Profile Edit UI|Profile Edit UI]]
- [[_COMMUNITY_Architecture & Conventions|Architecture & Conventions]]
- [[_COMMUNITY_ImportExport UI|Import/Export UI]]
- [[_COMMUNITY_App Root & Lifecycle|App Root & Lifecycle]]
- [[_COMMUNITY_Sync Engine & Connectivity|Sync Engine & Connectivity]]
- [[_COMMUNITY_Analytics & Recommendations|Analytics & Recommendations]]
- [[_COMMUNITY_Responsive Layout Helpers|Responsive Layout Helpers]]
- [[_COMMUNITY_Settings UI|Settings UI]]
- [[_COMMUNITY_Drift Database Schema|Drift Database Schema]]
- [[_COMMUNITY_Add Trade UI|Add Trade UI]]
- [[_COMMUNITY_Database & Local Data Source|Database & Local Data Source]]
- [[_COMMUNITY_DI Provider Wiring|DI Provider Wiring]]
- [[_COMMUNITY_Trade Repository Implementations|Trade Repository Implementations]]
- [[_COMMUNITY_Dashboard UI|Dashboard UI]]
- [[_COMMUNITY_Closed Trades Page|Closed Trades Page]]
- [[_COMMUNITY_Trade Detail UI|Trade Detail UI]]
- [[_COMMUNITY_Add Finance UI|Add Finance UI]]
- [[_COMMUNITY_Onboarding Flow|Onboarding Flow]]
- [[_COMMUNITY_Typography System|Typography System]]
- [[_COMMUNITY_Sync Status State|Sync Status State]]
- [[_COMMUNITY_Database CRUD Operations|Database CRUD Operations]]
- [[_COMMUNITY_DI Provider Tests|DI Provider Tests]]
- [[_COMMUNITY_Router & Auth Constants|Router & Auth Constants]]
- [[_COMMUNITY_Analytics Filter UI|Analytics Filter UI]]
- [[_COMMUNITY_PnL Card Widget|PnL Card Widget]]
- [[_COMMUNITY_Import State Machine|Import State Machine]]
- [[_COMMUNITY_Onboarding Painters|Onboarding Painters]]
- [[_COMMUNITY_Close Position Sheet|Close Position Sheet]]
- [[_COMMUNITY_CSV Import Parser|CSV Import Parser]]
- [[_COMMUNITY_Trade Position DTOs|Trade Position DTOs]]
- [[_COMMUNITY_Date Utilities|Date Utilities]]
- [[_COMMUNITY_Win Rate Card Widget|Win Rate Card Widget]]
- [[_COMMUNITY_Finance Page UI|Finance Page UI]]
- [[_COMMUNITY_Theme Configuration|Theme Configuration]]
- [[_COMMUNITY_Navigation Drawer|Navigation Drawer]]
- [[_COMMUNITY_Animated Card Widget|Animated Card Widget]]
- [[_COMMUNITY_Import & User DTOs|Import & User DTOs]]
- [[_COMMUNITY_Registration UI|Registration UI]]
- [[_COMMUNITY_Bottom Navigation Shell|Bottom Navigation Shell]]
- [[_COMMUNITY_Navigation Rail Widget|Navigation Rail Widget]]
- [[_COMMUNITY_Login UI|Login UI]]
- [[_COMMUNITY_Auth Data Sources & Impl|Auth Data Sources & Impl]]
- [[_COMMUNITY_Finance Record DTO|Finance Record DTO]]
- [[_COMMUNITY_Result Success State|Result Success State]]
- [[_COMMUNITY_Failure Types|Failure Types]]
- [[_COMMUNITY_Form Field & Metric Widgets|Form Field & Metric Widgets]]
- [[_COMMUNITY_Position DTO Freezed State|Position DTO Freezed State]]
- [[_COMMUNITY_Import Result Freezed State|Import Result Freezed State]]
- [[_COMMUNITY_String Utilities|String Utilities]]
- [[_COMMUNITY_CSV Export Repository|CSV Export Repository]]
- [[_COMMUNITY_Recent Trades List|Recent Trades List]]
- [[_COMMUNITY_GoRouter Configuration|GoRouter Configuration]]
- [[_COMMUNITY_Auth State Provider|Auth State Provider]]
- [[_COMMUNITY_Formatted Metrics Provider|Formatted Metrics Provider]]
- [[_COMMUNITY_Auth & Profile Providers|Auth & Profile Providers]]
- [[_COMMUNITY_Remote Data Sources|Remote Data Sources]]
- [[_COMMUNITY_Chart Mock Data|Chart Mock Data]]
- [[_COMMUNITY_Responsive Breakpoints|Responsive Breakpoints]]
- [[_COMMUNITY_Supabase Auth State|Supabase Auth State]]
- [[_COMMUNITY_Open Position Card Widget|Open Position Card Widget]]
- [[_COMMUNITY_Splash Screen|Splash Screen]]
- [[_COMMUNITY_Trade Filters Widget|Trade Filters Widget]]
- [[_COMMUNITY_User Profile Repository|User Profile Repository]]
- [[_COMMUNITY_App Constants|App Constants]]
- [[_COMMUNITY_Responsive Wrapper|Responsive Wrapper]]
- [[_COMMUNITY_Theme Colors|Theme Colors]]
- [[_COMMUNITY_CSV Export Logic|CSV Export Logic]]
- [[_COMMUNITY_Main Entry Point|Main Entry Point]]
- [[_COMMUNITY_DI Providers Barrel|DI Providers Barrel]]
- [[_COMMUNITY_Finance Record Entity|Finance Record Entity]]
- [[_COMMUNITY_Recommendation Entity|Recommendation Entity]]
- [[_COMMUNITY_Severity Enum|Severity Enum]]
- [[_COMMUNITY_Pages Barrel|Pages Barrel]]
- [[_COMMUNITY_Widgets Barrel|Widgets Barrel]]
- [[_COMMUNITY_Providers Barrel|Providers Barrel]]
- [[_COMMUNITY_Repositories Barrel|Repositories Barrel]]
- [[_COMMUNITY_Use Cases Barrel|Use Cases Barrel]]
- [[_COMMUNITY_Router Provider|Router Provider]]
- [[_COMMUNITY_Theme Provider|Theme Provider]]
- [[_COMMUNITY_Scaffold Key|Scaffold Key]]
- [[_COMMUNITY_Finance Type Enum|Finance Type Enum]]
- [[_COMMUNITY_Trade Side Enum|Trade Side Enum]]
- [[_COMMUNITY_User Entity|User Entity]]
- [[_COMMUNITY_Logger Utility|Logger Utility]]
- [[_COMMUNITY_Connectivity Checker|Connectivity Checker]]
- [[_COMMUNITY_Sync Engine|Sync Engine]]

## God Nodes (most connected - your core abstractions)
1. `package:flutter/material.dart` - 59 edges
2. `_` - 25 edges
3. `package:flutter_riverpod/flutter_riverpod.dart` - 24 edges
4. `package:google_fonts/google_fonts.dart` - 18 edges
5. `_` - 18 edges
6. `_` - 18 edges
7. `../core/result.dart` - 17 edges
8. `_` - 16 edges
9. `../../domain/entities/closed_position.dart` - 15 edges
10. `TradeTrackr` - 14 edges

## Surprising Connections (you probably didn't know these)
- `ClosedPosition Entity` --semantically_similar_to--> `Tonal Layering`  [INFERRED] [semantically similar]
  ARCHITECTURE.md → DESIGN.md
- `Result<T> Pattern` --semantically_similar_to--> `TradeFormState Freezed Union`  [INFERRED] [semantically similar]
  RESULT_PATTERN.md → FREEZED_GUIDE.md
- `ImportState Freezed Union` --conceptually_related_to--> `Riverpod (flutter_riverpod)`  [INFERRED]
  FREEZED_GUIDE.md → CLAUDE.md
- `Result<T> Pattern` --conceptually_related_to--> `Repository Segregation Pattern`  [INFERRED]
  RESULT_PATTERN.md → ARCHITECTURE.md
- `../../app/theme/app_colors.dart` --defines--> `AppColors`  [EXTRACTED]
  presentation/widgets/onboarding_illustrations.dart → app/theme/app_colors.dart

## Hyperedges (group relationships)
- **Clean Architecture Tri-Layer System** — presentation_layer, domain_layer, data_layer [EXTRACTED 1.00]
- **Offline-First Sync Pipeline** — drift, supabase, sync_engine, connectivity_checker [EXTRACTED 1.00]
- **Code Generation Toolchain** — build_runner, freezed, drift, riverpod [EXTRACTED 1.00]

## Communities (98 total, 1 thin omitted)

### Community 0 - "Domain Use Cases"
Cohesion: 0.05
Nodes (42): ../core/result.dart, ../core/usecase.dart, ../../domain/repositories/auth_repository.dart, ../../domain/repositories/trade_export_repository.dart, ../../domain/repositories/user_profile_repository.dart, ../entities/closed_position.dart, ../entities/recommendation.dart, ../entities/trade_analytics.dart (+34 more)

### Community 1 - "Equity Curve Charts"
Cohesion: 0.05
Nodes (45): chart_container.dart, build, ChartContainer, EquityCurveChart, _EquityCurveChartState, _formatYValue, LineChart, LineTooltipItem (+37 more)

### Community 2 - "Profile Edit UI"
Cohesion: 0.05
Nodes (37): build, dispose, _FieldLabel, Padding, ProfileEditPage, _ProfileEditPageState, Scaffold, SingleChildScrollView (+29 more)

### Community 3 - "Architecture & Conventions"
Cohesion: 0.09
Nodes (38): Freezed 3.x abstract Keyword Requirement, build_runner Code Generation, Clean Architecture, CloseReason Enum, ClosedPosition Entity, ConnectivityChecker, Context7 Documentation Rule, CSV Import/Export Format (+30 more)

### Community 4 - "Import/Export UI"
Cohesion: 0.06
Nodes (34): build, _buildExportTab, _buildImportTab, _buildTopBar, _CheckboxRow, _FormatRow, GestureDetector, ImportExportPage (+26 more)

### Community 5 - "App Root & Lifecycle"
Cohesion: 0.07
Nodes (26): build, didChangeAppLifecycleState, dispose, handleAppLifecycleState, initState, TradeTrackrApp, TradeTrackrAppState, Analytics (+18 more)

### Community 6 - "Sync Engine & Connectivity"
Cohesion: 0.07
Nodes (27): dart:async, ../../data/datasources/trade_local_data_source.dart, ../../data/datasources/trade_remote_data_source.dart, ../errors/failures.dart, AuthFailure, CsvParseFailure, DatabaseFailure, logFailure (+19 more)

### Community 7 - "Analytics & Recommendations"
Cohesion: 0.07
Nodes (27): ../../domain/entities/recommendation.dart, ../../domain/entities/trade_analytics.dart, ../../domain/enums/severity.dart, ../enums/severity.dart, Recommendation, TradeAnalytics, MockData, Recommendation (+19 more)

### Community 8 - "Responsive Layout Helpers"
Cohesion: 0.08
Nodes (24): Align, build, Center, ResponsiveCenter, ResponsiveCentered, ResponsiveScaffold, Scaffold, build (+16 more)

### Community 9 - "Settings UI"
Cohesion: 0.08
Nodes (24): build, _buildDeleteAccountButton, _buildLogoutButton, _buildSectionLabel, _buildSettingsCards, _buildTopBar, CircularProgressIndicator, Column (+16 more)

### Community 10 - "Drift Database Schema"
Cohesion: 0.09
Nodes (24): _, appDatabase, ClosedPositionData, ClosedPositionsCompanion, copyWith, copyWithCompanion, create, debugGetCreateSourceHash (+16 more)

### Community 11 - "Add Trade UI"
Cohesion: 0.09
Nodes (22): AddTradePage, _AddTradePageState, build, _buildDateTimePicker, _buildPositionTypeToggle, _buildReasonDropdown, _buildSideToggle, Container (+14 more)

### Community 12 - "Database & Local Data Source"
Cohesion: 0.09
Nodes (21): drift/database.dart, AppDatabase, ClosedPositions, driftDatabase, FinanceRecords, into, MigrationStrategy, _openConnection (+13 more)

### Community 13 - "DI Provider Wiring"
Cohesion: 0.09
Nodes (22): appDatabase, authRemoteDataSource, AuthRemoteDataSourceImpl, authRepository, AuthRepositoryImpl, supabaseClient, tradeCommandRepository, TradeCommandRepositoryImpl (+14 more)

### Community 14 - "Trade Repository Implementations"
Cohesion: 0.12
Nodes (20): ../datasources/trade_local_data_source.dart, ../../domain/entities/closed_position.dart, ../../domain/entities/trade_filter.dart, ../../domain/repositories/trade_command_repository.dart, ../../domain/repositories/trade_query_repository.dart, ../entities/finance_record.dart, ../entities/open_position.dart, ../enums/close_reason.dart (+12 more)

### Community 15 - "Dashboard UI"
Cohesion: 0.09
Nodes (21): _BentoMetrics, build, Center, _ChartsSection, Column, Container, DashboardPage, _HeroSection (+13 more)

### Community 16 - "Closed Trades Page"
Cohesion: 0.1
Nodes (20): build, _buildFilterBar, _buildHero, _buildTopBar, _buildTradeList, Center, Column, Container (+12 more)

### Community 17 - "Trade Detail UI"
Cohesion: 0.1
Nodes (20): _ActionButtons, build, Center, Column, Container, _formatDateTime, _formatDuration, _HeroPnlCard (+12 more)

### Community 18 - "Add Finance UI"
Cohesion: 0.1
Nodes (19): AddFinancePage, _AddFinancePageState, build, _buildDateTimePicker, _buildTypeToggle, dispose, Exception, _FieldLabel (+11 more)

### Community 19 - "Onboarding Flow"
Cohesion: 0.11
Nodes (17): _ActionButton, AnimatedContainer, build, dispose, _DotIndicators, GestureDetector, _handleNext, _OnboardingPageContent (+9 more)

### Community 20 - "Typography System"
Cohesion: 0.12
Nodes (16): AppTypography, bodyLarge, bodyMedium, bodySmall, buildResponsiveTextTheme, buildTextTheme, displayLarge, displayMedium (+8 more)

### Community 21 - "Sync Status State"
Cohesion: 0.12
Nodes (17): class, error, identical, offline, orElse, pending, StateError, synced (+9 more)

### Community 22 - "Database CRUD Operations"
Cohesion: 0.12
Nodes (17): addClosedPosition, addOpenPosition, call, closeOpenPosition, create, debugGetCreateSourceHash, deleteClosedPosition, deleteOpenPosition (+9 more)

### Community 23 - "DI Provider Tests"
Cohesion: 0.12
Nodes (15): appDatabase, authRemoteDataSource, authRepository, create, debugGetCreateSourceHash, overrideWithValue, supabaseClient, tradeCommandRepository (+7 more)

### Community 24 - "Router & Auth Constants"
Cohesion: 0.15
Nodes (12): AuthRefreshNotifier, OnboardingRefreshNotifier, SupabaseConstants, callbackDispatcher, ProviderScope, _setupGlobalErrorHandling, Workmanager, package:flutter_dotenv/flutter_dotenv.dart (+4 more)

### Community 25 - "Analytics Filter UI"
Cohesion: 0.13
Nodes (13): date_range_picker.dart, ../../domain/enums/trade_side.dart, calculateProfit, TradeSide, AnalyticsFilterBar, build, Column, SizedBox (+5 more)

### Community 26 - "PnL Card Widget"
Cohesion: 0.13
Nodes (14): build, dispose, _formatProfit, GestureDetector, initState, _onTapCancel, _onTapDown, _onTapUp (+6 more)

### Community 27 - "Import State Machine"
Cohesion: 0.14
Nodes (15): class, error, identical, idle, ImportError, ImportIdle, ImportLoading, ImportSuccess (+7 more)

### Community 28 - "Onboarding Painters"
Cohesion: 0.13
Nodes (14): build, _drawCandlestick, _drawLabel, _drawSparkle, LayoutBuilder, _Onboarding1Painter, _Onboarding2Painter, _Onboarding3Painter (+6 more)

### Community 29 - "Close Position Sheet"
Cohesion: 0.14
Nodes (13): form_field_label.dart, build, _buildProfitDisplay, ClosePositionSheet, _ClosePositionSheetState, Container, dispose, Expanded (+5 more)

### Community 30 - "CSV Import Parser"
Cohesion: 0.14
Nodes (13): dart:io, ../../domain/repositories/trade_import_repository.dart, FormatException, _parseCloseReason, _parseDateTime, _parseDouble, _parseFinanceType, _parseSide (+5 more)

### Community 31 - "Trade Position DTOs"
Cohesion: 0.15
Nodes (11): ../../domain/enums/close_reason.dart, ClosedPosition, ClosedPositionDto, OpenPosition, OpenPositionDto, toEntity, CloseReason, build (+3 more)

### Community 32 - "Date Utilities"
Cohesion: 0.15
Nodes (12): ../constants/app_constants.dart, DateFormat, DateTime, DateUtils, endOfDay, formatCsvDate, formatDisplayDate, formatDisplayDateTime (+4 more)

### Community 33 - "Win Rate Card Widget"
Cohesion: 0.15
Nodes (12): build, dispose, _formatPercentage, GestureDetector, initState, _onTapCancel, _onTapDown, _onTapUp (+4 more)

### Community 34 - "Finance Page UI"
Cohesion: 0.15
Nodes (12): add_finance_page.dart, build, _buildFinanceList, _buildTopBar, Container, _FinanceCard, FinancePage, _formatDate (+4 more)

### Community 35 - "Theme Configuration"
Cohesion: 0.15
Nodes (11): app_colors.dart, app_component_themes.dart, app_typography.dart, AppComponentThemes, BottomNavigationBarThemeData, FloatingActionButtonThemeData, AppTheme, _buildTheme (+3 more)

### Community 36 - "Navigation Drawer"
Cohesion: 0.17
Nodes (11): build, Container, Divider, _DrawerFooter, _DrawerHeader, _DrawerNavItem, _getInitials, ListTile (+3 more)

### Community 37 - "Animated Card Widget"
Cohesion: 0.17
Nodes (11): AnimatedBuilder, build, builder, dispose, Function, initState, LinearGradient, ShaderMask (+3 more)

### Community 38 - "Import & User DTOs"
Cohesion: 0.18
Nodes (7): ImportResultDto, toEntity, User, UserDto, ImportState, SyncStatusState, package:freezed_annotation/freezed_annotation.dart

### Community 39 - "Registration UI"
Cohesion: 0.18
Nodes (10): build, dispose, _FieldLabel, PopScope, RegisterPage, _RegisterPageState, SizedBox, SnackBar (+2 more)

### Community 40 - "Bottom Navigation Shell"
Cohesion: 0.18
Nodes (10): build, ClipRect, GestureDetector, _GlassBottomNav, _handleTabTap, MainShell, _NavTab, _NavTabItem (+2 more)

### Community 41 - "Navigation Rail Widget"
Cohesion: 0.18
Nodes (10): ../../app/theme/app_colors.dart, dart:ui, AppColors, build, ClipRect, GestureDetector, NavigationRailWidget, _NavTab (+2 more)

### Community 42 - "Login UI"
Cohesion: 0.2
Nodes (9): build, dispose, LoginPage, _LoginPageState, PopScope, SizedBox, SnackBar, package:flutter/services.dart (+1 more)

### Community 43 - "Auth Data Sources & Impl"
Cohesion: 0.2
Nodes (7): ../datasources/auth_remote_data_source.dart, ../../domain/entities/user.dart, AuthRemoteDataSource, UserRemoteDataSource, AuthRepositoryImpl, copyWith, User

### Community 44 - "Finance Record DTO"
Cohesion: 0.22
Nodes (8): ../../domain/entities/finance_record.dart, ../../domain/enums/finance_type.dart, ../enums/finance_type.dart, FinanceRecord, FinanceRecordDto, toEntity, FinanceRecord, FinanceType

### Community 45 - "Result Success State"
Cohesion: 0.25
Nodes (9): _, class, Failure, identical, orElse, StateError, Success, _then (+1 more)

### Community 46 - "Failure Types"
Cohesion: 0.22
Nodes (8): AuthFailure, CsvParseFailure, DatabaseFailure, Failure, NetworkFailure, SyncFailure, toString, ValidationFailure

### Community 47 - "Form Field & Metric Widgets"
Cohesion: 0.22
Nodes (7): AppTextFormField, build, TextFormField, build, Container, MetricCard, package:flutter/material.dart

### Community 48 - "Position DTO Freezed State"
Cohesion: 0.25
Nodes (9): _, class, _ClosedPositionDto, identical, _OpenPositionDto, orElse, StateError, _then (+1 more)

### Community 49 - "Import Result Freezed State"
Cohesion: 0.25
Nodes (9): _, class, EqualUnmodifiableListView, identical, _ImportResultDto, orElse, StateError, _then (+1 more)

### Community 50 - "String Utilities"
Cohesion: 0.22
Nodes (8): capitalize, formatNumber, formatPercentage, isBlank, isNotEmpty, isNullOrEmpty, StringUtils, truncate

### Community 51 - "CSV Export Repository"
Cohesion: 0.25
Nodes (7): ../../domain/core/result.dart, TradeExportRepositoryImpl, getOrElse, getOrThrow, Result, when, package:csv/csv.dart

### Community 52 - "Recent Trades List"
Cohesion: 0.25
Nodes (7): build, _buildTradeRow, Column, Padding, RecentTradesList, SizedBox, package:intl/intl.dart

### Community 53 - "GoRouter Configuration"
Cohesion: 0.25
Nodes (6): GoRouter, MainShell, TradeDetailPage, main_shell.dart, package:go_router/go_router.dart, router_refresh_stream.dart

### Community 54 - "Auth State Provider"
Cohesion: 0.29
Nodes (8): authState, create, debugGetCreateSourceHash, overrideWithValue, runBuild, supabaseAuthState, supabaseAuthStateStream, _

### Community 55 - "Formatted Metrics Provider"
Cohesion: 0.29
Nodes (8): create, debugGetCreateSourceHash, formattedBalance, formattedTotalPnL, formattedWinRate, overrideWithValue, runBuild, _

### Community 56 - "Auth & Profile Providers"
Cohesion: 0.25
Nodes (6): auth_provider.dart, di_providers.dart, Auth, Exception, Exception, Profile

### Community 57 - "Remote Data Sources"
Cohesion: 0.25
Nodes (6): auth_remote_data_source.dart, AuthFailure, AuthRemoteDataSourceImpl, TradeRemoteDataSourceImpl, package:supabase_flutter/supabase_flutter.dart, trade_remote_data_source.dart

### Community 58 - "Chart Mock Data"
Cohesion: 0.25
Nodes (7): ChartMockData, _DayProfit, _EquityPoint, _PLBucket, _ReasonCount, _SessionProfit, _SymbolPerf

### Community 59 - "Responsive Breakpoints"
Cohesion: 0.25
Nodes (7): build, builder, Function, LayoutBuilder, mobile, ResponsiveBreakpointBuilder, ResponsiveBuilder

### Community 60 - "Supabase Auth State"
Cohesion: 0.25
Nodes (7): build, dispose, FilterBar, _FilterBarState, Padding, Row, SizedBox

### Community 61 - "Open Position Card Widget"
Cohesion: 0.29
Nodes (8): _, class, _FinanceRecordDto, identical, orElse, StateError, _then, toString

### Community 62 - "Splash Screen"
Cohesion: 0.29
Nodes (8): _, class, identical, orElse, StateError, _then, toString, _UserDto

### Community 63 - "Trade Filters Widget"
Cohesion: 0.25
Nodes (7): build, Container, GestureDetector, SizedBox, ThemeToggle, _ToggleButton, ../providers/theme_provider.dart

### Community 64 - "User Profile Repository"
Cohesion: 0.25
Nodes (7): ResponsiveBorderRadius, ResponsiveBreakpoints, ResponsiveGridColumns, ResponsiveIconSize, ResponsivePadding, ResponsiveScale, ResponsiveSpacing

### Community 65 - "App Constants"
Cohesion: 0.29
Nodes (6): ../../domain/entities/open_position.dart, copyWith, OpenPosition, Exception, OpenPositions, TradeList

### Community 66 - "Responsive Wrapper"
Cohesion: 0.29
Nodes (6): build, Column, IntrinsicHeight, SizedBox, _TimelineEvent, TradeTimeline

### Community 67 - "Theme Colors"
Cohesion: 0.29
Nodes (6): responsiveEdgeInsets, responsiveFontSize, responsiveHeight, responsivePadding, responsiveSpacing, responsiveWidth

### Community 68 - "CSV Export Logic"
Cohesion: 0.33
Nodes (7): connectivityChecker, create, debugGetCreateSourceHash, overrideWithValue, runBuild, syncEngine, _

### Community 69 - "Main Entry Point"
Cohesion: 0.29
Nodes (6): build, GestureDetector, _PageButton, PaginationBar, Row, SizedBox

### Community 70 - "DI Providers Barrel"
Cohesion: 0.29
Nodes (6): build, DateRangePicker, _formatDate, GestureDetector, SizedBox, Theme

### Community 71 - "Finance Record Entity"
Cohesion: 0.29
Nodes (6): build, Container, Function, GestureDetector, PillOption, PillToggle

### Community 72 - "Recommendation Entity"
Cohesion: 0.4
Nodes (6): _, build, create, debugGetCreateSourceHash, overrideWithValue, runBuild

### Community 73 - "Severity Enum"
Cohesion: 0.4
Nodes (6): build, create, debugGetCreateSourceHash, overrideWithValue, runBuild, _

### Community 74 - "Pages Barrel"
Cohesion: 0.4
Nodes (6): create, debugGetCreateSourceHash, hasCompletedOnboarding, overrideWithValue, runBuild, _

### Community 75 - "Widgets Barrel"
Cohesion: 0.4
Nodes (6): build, create, debugGetCreateSourceHash, overrideWithValue, runBuild, _

### Community 76 - "Providers Barrel"
Cohesion: 0.33
Nodes (5): build, Function, GestureDetector, MultiSelectChip, Wrap

### Community 77 - "Repositories Barrel"
Cohesion: 0.33
Nodes (5): build, ChartContainer, Container, SizedBox, ../section_label.dart

### Community 78 - "Use Cases Barrel"
Cohesion: 0.4
Nodes (4): AuthFailure, DatabaseFailure, UserRemoteDataSourceImpl, user_remote_data_source.dart

### Community 79 - "Router Provider"
Cohesion: 0.5
Nodes (3): NoParams, UseCase, result.dart

### Community 80 - "Theme Provider"
Cohesion: 0.67
Nodes (4): create, debugGetCreateSourceHash, runBuild, _

### Community 81 - "Scaffold Key"
Cohesion: 0.67
Nodes (4): create, debugGetCreateSourceHash, runBuild, _

### Community 82 - "Finance Type Enum"
Cohesion: 0.5
Nodes (3): ../datasources/user_remote_data_source.dart, setCurrentUserId, UserProfileRepositoryImpl

### Community 83 - "Trade Side Enum"
Cohesion: 0.5
Nodes (3): build, Padding, SectionLabel

### Community 84 - "User Entity"
Cohesion: 0.5
Nodes (3): build, FormFieldLabel, Padding

### Community 85 - "Logger Utility"
Cohesion: 0.5
Nodes (3): build, PrimaryButton, SizedBox

### Community 86 - "Connectivity Checker"
Cohesion: 0.5
Nodes (3): build, Container, PricingRow

## Knowledge Gaps
- **963 isolated node(s):** `Workmanager`, `ProviderScope`, `_setupGlobalErrorHandling`, `MainShell`, `_GlassBottomNav` (+958 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `package:flutter/material.dart` connect `Form Field & Metric Widgets` to `Equity Curve Charts`, `Profile Edit UI`, `Import/Export UI`, `App Root & Lifecycle`, `Analytics & Recommendations`, `Responsive Layout Helpers`, `Settings UI`, `Add Trade UI`, `Dashboard UI`, `Closed Trades Page`, `Trade Detail UI`, `Add Finance UI`, `Onboarding Flow`, `Typography System`, `Router & Auth Constants`, `Analytics Filter UI`, `PnL Card Widget`, `Onboarding Painters`, `Close Position Sheet`, `Trade Position DTOs`, `Win Rate Card Widget`, `Finance Page UI`, `Theme Configuration`, `Navigation Drawer`, `Animated Card Widget`, `Registration UI`, `Bottom Navigation Shell`, `Navigation Rail Widget`, `Login UI`, `Recent Trades List`, `GoRouter Configuration`, `Responsive Breakpoints`, `Supabase Auth State`, `Trade Filters Widget`, `Responsive Wrapper`, `Theme Colors`, `Main Entry Point`, `DI Providers Barrel`, `Finance Record Entity`, `Providers Barrel`, `Repositories Barrel`, `Trade Side Enum`, `User Entity`, `Logger Utility`, `Connectivity Checker`?**
  _High betweenness centrality (0.329) - this node is a cross-community bridge._
- **Why does `package:flutter_riverpod/flutter_riverpod.dart` connect `Router & Auth Constants` to `Equity Curve Charts`, `Profile Edit UI`, `Import/Export UI`, `App Root & Lifecycle`, `Sync Engine & Connectivity`, `Analytics & Recommendations`, `Settings UI`, `Add Trade UI`, `Dashboard UI`, `Closed Trades Page`, `Trade Detail UI`, `Add Finance UI`, `Onboarding Flow`, `Finance Page UI`, `Navigation Drawer`, `Registration UI`, `Login UI`, `GoRouter Configuration`, `Trade Filters Widget`?**
  _High betweenness centrality (0.065) - this node is a cross-community bridge._
- **Why does `../core/result.dart` connect `Domain Use Cases` to `Trade Repository Implementations`, `CSV Import Parser`?**
  _High betweenness centrality (0.047) - this node is a cross-community bridge._
- **What connects `Workmanager`, `ProviderScope`, `_setupGlobalErrorHandling` to the rest of the system?**
  _963 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Domain Use Cases` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._
- **Should `Equity Curve Charts` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._
- **Should `Profile Edit UI` be split into smaller, more focused modules?**
  _Cohesion score 0.05 - nodes in this community are weakly interconnected._