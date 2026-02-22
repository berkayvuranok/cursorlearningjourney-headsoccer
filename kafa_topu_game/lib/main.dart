import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cursor_edu_core/cursor_edu_core.dart';
import 'package:go_router/go_router.dart';

import 'src/features/home/presentation/home_screen.dart';
import 'src/features/game/presentation/game_screen.dart';

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
          builder: (context, state) => const GameScreen(),
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
