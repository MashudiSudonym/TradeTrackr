/// Supabase configuration constants.
///
/// TODO: Move anonKey to environment variables for production.
/// For development, this uses the default anon key from Supabase dashboard.
class SupabaseConstants {
  /// Supabase project URL.
  /// Generated from project ref: bheohnfxjnwdkqvftbnc
  static const String projectId = 'bheohnfxjnwdkqvftbnc';
  static const String projectUrl = 'https://$projectId.supabase.co';

  /// Supabase anon key for client-side access.
  ///
  /// This key is safe to expose in client code as it's restricted by RLS policies.
  /// Replace with your actual anon key from Supabase dashboard > Settings > API.
  ///
  /// Get your anon key at: https://supabase.com/dashboard/project/$projectId/settings/api
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY_HERE',
  );

  /// Check if Supabase is properly configured.
  static bool get isConfigured => anonKey != 'YOUR_SUPABASE_ANON_KEY_HERE';
}
