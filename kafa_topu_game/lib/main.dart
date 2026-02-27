import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cursor_edu_core/cursor_edu_core.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/core/supabase_config.dart';
import 'src/features/home/presentation/home_screen.dart';
import 'src/features/game/presentation/game_screen.dart';
import 'src/features/settings/presentation/settings_screen.dart';
import 'src/features/rank/presentation/rank_screen.dart';
import 'src/features/tournament/presentation/tournament_screen.dart';
import 'src/features/profile/presentation/profile_screen.dart';
import 'src/features/auth/presentation/login_screen.dart';
import 'src/features/auth/presentation/signup_screen.dart';

/// Asset .env dosyasından SUPABASE_URL ve SUPABASE_ANON_KEY okur.
Future<(String?, String?)> _loadEnvFromAsset() async {
  String? envUrl;
  String? envKey;
  try {
    final data = await rootBundle.loadString('.env');
    for (final line in data.split('\n')) {
      final t = line.trim();
      if (t.isEmpty || t.startsWith('#')) continue;
      final idx = t.indexOf('=');
      if (idx <= 0) continue;
      final k = t.substring(0, idx).trim();
      var v = t.substring(idx + 1).trim();
      if (v.length >= 2 && ((v.startsWith('"') && v.endsWith('"')) || (v.startsWith("'") && v.endsWith("'")))) {
        v = v.substring(1, v.length - 1);
      }
      if (k == 'SUPABASE_URL') envUrl = v;
      if (k == 'SUPABASE_ANON_KEY') envKey = v;
    }
  } catch (_) {}
  return (envUrl, envKey);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  configureDependencies();

  final (envUrl, envKey) = await _loadEnvFromAsset();
  SupabaseConfig.init(url: envUrl, key: envKey);

  if (SupabaseConfig.isConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }

  runApp(const KafaTopuApp());
}

class KafaTopuApp extends StatelessWidget {
  const KafaTopuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: AppRoutes.home,
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.game,
          builder: (context, state) => const GameScreen(isOnline: false),
        ),
        GoRoute(
          path: AppRoutes.gameOnline,
          builder: (context, state) => const GameScreen(isOnline: true),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) {
            final extra = state.extra is Map ? state.extra as Map<String, dynamic> : null;
            final fromOnlineGame = extra?['fromOnlineGame'] == true;
            return SettingsScreen(fromOnlineGame: fromOnlineGame);
          },
        ),
        GoRoute(
          path: AppRoutes.rank,
          builder: (context, state) => const RankScreen(),
        ),
        GoRoute(
          path: AppRoutes.tournament,
          builder: (context, state) => const TournamentScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => const SignupScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Head Soccer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade700),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
