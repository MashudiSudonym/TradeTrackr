import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/auth_remote_data_source_impl.dart';
import '../../data/datasources/trade_local_data_source.dart';
import '../../data/datasources/trade_local_data_source_impl.dart';
import '../../data/datasources/trade_remote_data_source.dart';
import '../../data/datasources/trade_remote_data_source_impl.dart';
import '../../data/datasources/user_remote_data_source.dart';
import '../../data/datasources/user_remote_data_source_impl.dart';
import '../../data/datasources/drift/database.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/trade_command_repository.dart';
import '../../domain/repositories/trade_export_repository.dart';
import '../../domain/repositories/trade_import_repository.dart';
import '../../domain/repositories/trade_query_repository.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/trade_command_repository_impl.dart';
import '../../data/repositories/trade_export_repository_impl.dart';
import '../../data/repositories/trade_import_repository_impl.dart';
import '../../data/repositories/trade_query_repository_impl.dart';
import '../../data/repositories/user_profile_repository_impl.dart';

// Re-export sync providers for easy access
export 'sync_provider.dart';

part 'di_providers.g.dart';

// ============================================================================
// Supabase Client
// ============================================================================

/// Provides the Supabase client instance.
///
/// Initialized in main.dart before runApp.
@riverpod
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

// ============================================================================
// Data Sources
// ============================================================================

/// Provides the local Drift database instance.
///
/// KeepAlive: true - database must persist across app lifecycle.
@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

/// Provides the local data source for trade operations.
@riverpod
TradeLocalDataSource tradeLocalDataSource(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TradeLocalDataSourceImpl(db);
}

/// Provides the remote data source for trade operations.
@riverpod
TradeRemoteDataSource tradeRemoteDataSource(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return TradeRemoteDataSourceImpl(client);
}

/// Provides the remote data source for authentication.
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRemoteDataSourceImpl(client);
}

/// Provides the remote data source for user profiles.
@riverpod
UserRemoteDataSource userRemoteDataSource(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return UserRemoteDataSourceImpl(client);
}

// ============================================================================
// Repositories
// ============================================================================

/// Provides the query repository for trade positions.
@riverpod
TradeQueryRepository tradeQueryRepository(Ref ref) {
  final localDataSource = ref.watch(tradeLocalDataSourceProvider);
  return TradeQueryRepositoryImpl(localDataSource);
}

/// Provides the command repository for trade operations.
@riverpod
TradeCommandRepository tradeCommandRepository(Ref ref) {
  final localDataSource = ref.watch(tradeLocalDataSourceProvider);
  return TradeCommandRepositoryImpl(localDataSource);
}

/// Provides the import repository for CSV operations.
@riverpod
TradeImportRepository tradeImportRepository(Ref ref) {
  final localDataSource = ref.watch(tradeLocalDataSourceProvider);
  return TradeImportRepositoryImpl(localDataSource);
}

/// Provides the export repository for CSV operations.
@riverpod
TradeExportRepository tradeExportRepository(Ref ref) {
  return TradeExportRepositoryImpl();
}

/// Provides the authentication repository.
@riverpod
AuthRepository authRepository(Ref ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
}

/// Provides the user profile repository.
@riverpod
UserProfileRepository userProfileRepository(Ref ref) {
  final remoteDataSource = ref.watch(userRemoteDataSourceProvider);
  return UserProfileRepositoryImpl(remoteDataSource);
}
