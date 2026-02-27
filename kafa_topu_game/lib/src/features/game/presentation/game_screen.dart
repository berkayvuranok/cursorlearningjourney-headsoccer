import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:go_router/go_router.dart';
import 'package:cursor_edu_core/cursor_edu_core.dart';

import '../data/kafa_topu_game.dart';
import '../../online/data/online_session_service.dart';
import '../../profile/data/profile_repository.dart';
import '../../../core/device_id.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, this.isOnline = false});

  final bool isOnline;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _session = OnlineSessionService.instance;
  late final KafaTopuGame _game;
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    getOrCreateDeviceId().then((id) {
      if (mounted) setState(() => _deviceId = id);
    });
    _game = KafaTopuGame(onGameOver: _onGameOver);
    if (widget.isOnline) {
      final playerId = 'p_${DateTime.now().millisecondsSinceEpoch}';
      _session.joinRoom('default', playerId);
    }
  }

  void _onGameOver(int score1, int score2) {
    final deviceId = _deviceId ?? '';
    final winnerId = score1 > score2 ? deviceId : 'local_guest';
    ProfileRepository.instance.insertMatch(
      player1DeviceId: deviceId,
      player2DeviceId: 'local_guest',
      score1: score1,
      score2: score2,
      winnerDeviceId: score1 != score2 ? winnerId : null,
      isOnline: widget.isOnline,
    );
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(score1 >= KafaTopuGame.goalLimit ? 'Sol kazandı!' : 'Sağ kazandı!'),
        content: Text('Skor: $score1 - $score2'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (widget.isOnline) _session.leaveRoom();
    _session.clearOpponentInSettings();
    super.dispose();
  }

  void _openSettings() {
    if (widget.isOnline) _session.notifyImInSettings();
    context.push(AppRoutes.settings, extra: {'fromOnlineGame': widget.isOnline});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          IgnorePointer(
            child: GameWidget<KafaTopuGame>(game: _game),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: _GameOverlayButton(
              icon: Icons.arrow_back_ios_new,
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.home);
                }
              },
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
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}
