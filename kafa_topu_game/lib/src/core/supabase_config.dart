/// Supabase connection config.
/// URL ve anon key .env dosyasından (SUPABASE_URL, SUPABASE_ANON_KEY) veya
/// --dart-define ile verilir. Önce .env, yoksa dart-define kullanılır.
class SupabaseConfig {
  SupabaseConfig._();

  static late String supabaseUrl;
  static late String supabaseAnonKey;

  /// main() içinde dotenv yüklendikten sonra çağrılmalı.
  static void init({
    String? url,
    String? key,
  }) {
    supabaseUrl = url?.trim() ?? '';
    supabaseAnonKey = key?.trim() ?? '';
    if (supabaseUrl.isEmpty) {
      supabaseUrl = const String.fromEnvironment(
        'SUPABASE_URL',
        defaultValue: '',
      );
    }
    if (supabaseAnonKey.isEmpty) {
      supabaseAnonKey = const String.fromEnvironment(
        'SUPABASE_ANON_KEY',
        defaultValue: '',
      );
    }
  }

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      supabaseAnonKey != 'your-anon-key-here';
}
