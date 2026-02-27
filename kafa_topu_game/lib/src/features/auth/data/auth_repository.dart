import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase_config.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  SupabaseClient? get _client =>
      SupabaseConfig.isConfigured ? Supabase.instance.client : null;

  User? get currentUser => _client?.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client?.auth.onAuthStateChange ?? const Stream.empty();

  Future<AuthResult> signUp(String email, String password) async {
    final client = _client;
    if (client == null) {
      return AuthResult(success: false, error: 'Supabase yapılandırılmamış');
    }
    try {
      await client.auth.signUp(email: email, password: password);
      return const AuthResult(success: true);
    } on AuthException catch (e) {
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  Future<AuthResult> signIn(String email, String password) async {
    final client = _client;
    if (client == null) {
      return AuthResult(success: false, error: 'Supabase yapılandırılmamış');
    }
    try {
      await client.auth.signInWithPassword(email: email, password: password);
      return const AuthResult(success: true);
    } on AuthException catch (e) {
      return AuthResult(success: false, error: e.message);
    } catch (e) {
      return AuthResult(success: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    await _client?.auth.signOut();
  }
}

class AuthResult {
  const AuthResult({required this.success, this.error});
  final bool success;
  final String? error;
}
