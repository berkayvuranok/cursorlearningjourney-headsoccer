import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import 'package:cursor_edu_core/cursor_edu_core.dart';

import '../data/kafa_topu_game.dart';
import '../../online/data/online_session_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.isOnline = false});

  final bool isOnline;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _session = OnlineSessionService.instance;

  @override
  void dispose() {
    _session.clearOpponentInSettings();
    super.dispose();
  }

  void _openSettings() {
    if (widget.isOnline) {
      _session.notifyImInSettings();
      // Other device would get setOpponentInSettings() via backend.
    }
    context.push(AppRoutes.settings, extra: {'fromOnlineGame': widget.isOnline});
  }

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
              onTap: _openSettings,
            ),
          ),
          if (widget.isOnline)
            ListenableBuilder(
              listenable: _session,
              builder: (context, _) {
                if (!_session.opponentInSettings) return const SizedBox.shrink();
                return _OpponentInSettingsOverlay(
                  countdownSeconds: _session.countdownSeconds,
                );
              },
            ),
        ],
      ),
    );
  }
}

class _OpponentInSettingsOverlay extends StatelessWidget {
  const _OpponentInSettingsOverlay({required this.countdownSeconds});

  final int countdownSeconds;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      alignment: Alignment.center,
      child: Card(
        margin: const EdgeInsets.all(32),
        color: Colors.green.shade900,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.settings, size: 48, color: Colors.white54),
              const SizedBox(height: 16),
              const Text(
                'Rakip ayarlarda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Bekleme: $countdownSeconds saniye',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
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
