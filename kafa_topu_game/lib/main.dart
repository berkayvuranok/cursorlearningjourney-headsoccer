import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cursor_edu_core/cursor_edu_core.dart';
import 'package:go_router/go_router.dart';

import 'src/features/home/presentation/home_screen.dart';
import 'src/features/game/presentation/game_screen.dart';
import 'src/features/settings/presentation/settings_screen.dart';
import 'src/features/rank/presentation/rank_screen.dart';
import 'src/features/tournament/presentation/tournament_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  configureDependencies();
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
