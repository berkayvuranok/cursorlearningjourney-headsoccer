import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cursor_edu_core/cursor_edu_core.dart';

import '../../../app/widgets/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const HeadSoccerAppBar(title: 'HEAD SOCCER'),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade900,
              Colors.green.shade800,
              Colors.green.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Kendini Geliştir',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SectionCard(
                    title: 'Tek / Lokal',
                    subtitle: 'Kendi başına veya aynı cihazda 2 kişi',
                    icon: Icons.sports_soccer,
                    onTap: () => context.go(AppRoutes.game),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Online Oyna',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SectionCard(
                    title: 'Online Maç',
                    subtitle: 'Farklı cihazdan rakip ile oyna',
                    icon: Icons.wifi,
                    onTap: () => context.go(AppRoutes.gameOnline),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () => context.push(AppRoutes.rank),
                      icon: const Icon(Icons.leaderboard, color: Colors.white70),
                      label: const Text('Rank', style: TextStyle(color: Colors.white70)),
                    ),
                    const SizedBox(width: 24),
                    TextButton.icon(
                      onPressed: () => context.push(AppRoutes.tournament),
                      icon: const Icon(Icons.emoji_events, color: Colors.white70),
                      label: const Text('Turnuva', style: TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person, color: Colors.white70),
                      onPressed: () => context.push(AppRoutes.profile),
                      tooltip: 'Profil',
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white70),
                      onPressed: () => context.push(AppRoutes.settings),
                      tooltip: 'Settings',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white24,
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
