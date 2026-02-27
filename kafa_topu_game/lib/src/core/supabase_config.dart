import 'package:flutter/foundation.dart' show kIsWeb;

import 'supabase_env_stub.dart'
    if (dart.library.io) 'supabase_env_io.dart' as env_loader;

/// Supabase connection config.
/// Sıra: .env asset → ortam değişkeni → --dart-define → bu proje için yedek değerler.
class SupabaseConfig {
  SupabaseConfig._();

  static const String _defaultUrl = 'https://avfnjvgjppayuxufqmfz.supabase.co';
  static const String _defaultAnonKey = 'sb_publishable_6FultBnyBW6tl6TQj2XvQg_qP94oV-a';

  static String supabaseUrl = '';
  static String supabaseAnonKey = '';

  /// main() içinde .env yüklendikten sonra çağrılmalı.
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
    // Ortam değişkeni yedeği (export veya IDE .env)
    if (!kIsWeb) {
      try {
        final env = env_loader.getSupabaseEnv();
        if (supabaseUrl.isEmpty && env['SUPABASE_URL'] != null) {
          supabaseUrl = env['SUPABASE_URL']!.trim();
        }
        if (supabaseAnonKey.isEmpty && env['SUPABASE_ANON_KEY'] != null) {
          supabaseAnonKey = env['SUPABASE_ANON_KEY']!.trim();
        }
      } catch (_) {}
    }
    // Bu proje için yedek: hiçbir kaynaktan gelmediyse varsayılanları kullan
    if (supabaseUrl.isEmpty) supabaseUrl = _defaultUrl;
    if (supabaseAnonKey.isEmpty) supabaseAnonKey = _defaultAnonKey;
  }

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
