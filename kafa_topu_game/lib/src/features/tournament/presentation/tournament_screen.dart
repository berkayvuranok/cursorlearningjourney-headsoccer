import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kafa_topu_game/src/app/widgets/app_bar.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeadSoccerAppBar(
        title: 'TURNAVA',
        showBack: true,
        onBack: () => context.pop(),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade900,
              Colors.green.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, size: 64, color: Colors.amber.shade200),
                const SizedBox(height: 16),
                Text(
                  'Turnuva sonuçlarına göre rank hesaplanır.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'TODO: Turnuva listesi ve bracket',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
