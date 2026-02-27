import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kafa_topu_game/src/app/widgets/app_bar.dart';
import '../data/rank_model.dart';

class RankScreen extends StatelessWidget {
  const RankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO(backend): Load from API. Placeholder data.
    final myRank = RankEntry(
      playerId: 'local',
      displayName: 'Player',
      tier: RankTier.silver,
      points: 1250,
      wins: 12,
      losses: 8,
    );
    final leaderboard = [
      myRank,
      const RankEntry(
        playerId: '2',
        displayName: 'Rival',
        tier: RankTier.gold,
        points: 1800,
        wins: 20,
        losses: 5,
      ),
    ];

    return Scaffold(
      appBar: HeadSoccerAppBar(
        title: 'RANK',
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
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _RankCard(entry: myRank, isMe: true),
              const SizedBox(height: 16),
              Text(
                'Leaderboard',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...leaderboard.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _RankCard(entry: e, isMe: e.playerId == myRank.playerId),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  const _RankCard({required this.entry, this.isMe = false});

  final RankEntry entry;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isMe ? Colors.green.shade800 : Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white24,
          child: Text(
            entry.tier.label[0],
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          entry.displayName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${entry.tier.label} · ${entry.points} pts · ${entry.wins}W / ${entry.losses}L',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
        ),
      ),
    );
  }
}
