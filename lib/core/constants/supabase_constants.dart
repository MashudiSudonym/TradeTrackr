import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Supabase configuration constants.
///
/// Loads credentials from .env file.
/// Copy .env.example to .env and fill in your Supabase credentials.
class SupabaseConstants {
  /// Supabase project ref
  static const String projectId = 'bheohnfxjnwdkqvftbnc';

  /// Supabase project URL
  /// Can be overridden via .env file
  static String get projectUrl =>
      dotenv.get('SUPABASE_URL', fallback: 'https://$projectId.supabase.co');

  /// Supabase anon/public key for client-side access.
  ///
  /// This key is safe to expose in client code as it's restricted by RLS policies.
  /// MUST be set in .env file for the app to work properly.
  ///
  /// Get your anon key at:
  /// https://supabase.com/dashboard/project/$projectId/settings/api
  static String get anonKey => dotenv.get('SUPABASE_ANON_KEY');

  /// Check if Supabase is properly configured.
  static bool get isConfigured => anonKey.isNotEmpty;

  /// Load environment variables from .env file
  ///
  /// Call this in main() before Supabase.initialize()
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
