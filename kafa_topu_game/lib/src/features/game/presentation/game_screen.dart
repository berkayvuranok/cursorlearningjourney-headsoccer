import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import 'package:cursor_edu_core/cursor_edu_core.dart';

import '../data/kafa_topu_game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget<KafaTopuGame>(game: KafaTopuGame()),
          Positioned(
            top: 12,
            left: 12,
            child: _GameOverlayButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () => context.pop(),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: _GameOverlayButton(
              icon: Icons.settings,
              onTap: () => context.push(AppRoutes.settings),
            ),
          ),
        ],
      ),
    );
  }
}

class _GameOverlayButton extends StatelessWidget {
  const _GameOverlayButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
