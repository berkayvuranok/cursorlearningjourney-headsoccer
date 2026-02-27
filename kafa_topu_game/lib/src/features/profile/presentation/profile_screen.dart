import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:cursor_edu_core/cursor_edu_core.dart';

import 'package:kafa_topu_game/src/app/widgets/app_bar.dart';
import 'package:kafa_topu_game/src/features/profile/data/profile_repository.dart';
import 'package:kafa_topu_game/src/features/auth/data/auth_repository.dart';
import 'package:kafa_topu_game/src/shared/shared.dart';

import 'profile_cubit.dart';
import 'profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..load(),
      child: Scaffold(
        appBar: HeadSoccerAppBar(
          title: 'PROFİL',
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
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state.status == ProfileStatus.loading) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              if (state.status == ProfileStatus.error) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.errorMessage ?? '', style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.read<ProfileCubit>().load(),
                        child: const Text('Tekrar dene', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              }
              return SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => context.read<ProfileCubit>().load(),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const _AuthCard(),
                      const SizedBox(height: 16),
                      _ProfileCard(
                        profile: state.profile,
                        stats: state.myLeaderboardEntry,
                        deviceId: state.deviceId ?? '',
                        onSave: (name, skin) => context.read<ProfileCubit>().saveProfile(name, skin),
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'Son maçlar'),
                      const SizedBox(height: 8),
                      if (state.matches.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(
                            child: Text('Henüz maç yok', style: TextStyle(color: Colors.white54)),
                          ),
                        )
                      else
                        ...state.matches.map((m) => _MatchTile(match: m, myDeviceId: state.deviceId)),
                      const SizedBox(height: 24),
                      _SectionTitle(title: 'Sıralama'),
                      const SizedBox(height: 8),
                      ...state.leaderboard.take(10).toList().asMap().entries.map((e) {
                        return _LeaderboardTile(rank: e.key + 1, profile: e.value);
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: AuthRepository.instance.authStateChanges,
      builder: (context, snapshot) {
        final user = AuthRepository.instance.currentUser ?? snapshot.data?.session?.user;
        if (user != null) {
          return Card(
            color: Colors.black.withValues(alpha: 0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white70),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      user.email ?? 'Giriş yapıldı',
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await AuthRepository.instance.signOut();
                      if (context.mounted) {
                        context.read<ProfileCubit>().load();
                      }
                    },
                    child: const Text('Çıkış yap'),
                  ),
                ],
              ),
            ),
          );
        }
        return Card(
          color: Colors.black.withValues(alpha: 0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.icon(
                  onPressed: () => context.push(AppRoutes.login),
                  icon: const Icon(Icons.login),
                  label: const Text('Giriş yap'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.signup),
                  icon: const Icon(Icons.person_add),
                  label: const Text('Kayıt ol'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class _ProfileCard extends StatefulWidget {
  const _ProfileCard({
    required this.profile,
    this.stats,
    required this.deviceId,
    required this.onSave,
  });

  final ProfileRow? profile;
  final ProfileRow? stats;
  final String deviceId;
  final Future<void> Function(String displayName, PlayerSkin skin) onSave;

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  late TextEditingController _nameController;
  late PlayerSkin _skin;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile?.displayName ?? 'Player');
    _skin = widget.profile?.skinEnum ?? PlayerSkin.classicGreen;
  }

  @override
  void didUpdateWidget(covariant _ProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profile != null && widget.profile != oldWidget.profile) {
      _nameController.text = widget.profile!.displayName;
      _skin = widget.profile!.skinEnum;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.stats;
    final wins = stats?.wins ?? 0;
    final losses = stats?.losses ?? 0;
    final points = stats?.points ?? 0;

    return Card(
      color: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: _skin.color,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: const InputDecoration(
                      labelText: 'İsim',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PlayerSkin>(
              key: ValueKey<PlayerSkin>(_skin),
              value: _skin,
              dropdownColor: Colors.black87,
              decoration: const InputDecoration(labelText: 'Kostüm'),
              items: PlayerSkin.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
              onChanged: (v) => setState(() => _skin = v ?? _skin),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatChip(label: 'Galibiyet', value: '$wins'),
                _StatChip(label: 'Mağlubiyet', value: '$losses'),
                _StatChip(label: 'Puan', value: '$points'),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              child: FilledButton(
                onPressed: () => widget.onSave(_nameController.text, _skin),
                child: const Text('Kaydet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
      ],
    );
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({required this.match, required this.myDeviceId});
  final MatchRow match;
  final String? myDeviceId;

  @override
  Widget build(BuildContext context) {
    final isWin = match.winnerDeviceId == myDeviceId;
    return Card(
      color: Colors.black26,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          '${match.score1} - ${match.score2}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          match.createdAt.toIso8601String().substring(0, 16).replaceAll('T', ' '),
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        ),
        trailing: isWin
            ? const Icon(Icons.emoji_events, color: Colors.amber)
            : match.winnerDeviceId != null
                ? const Icon(Icons.close, color: Colors.redAccent)
                : null,
      ),
    );
  }
}

class _LeaderboardTile extends StatelessWidget {
  const _LeaderboardTile({required this.rank, required this.profile});
  final int rank;
  final ProfileRow profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black26,
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white24,
          child: Text('$rank', style: const TextStyle(color: Colors.white)),
        ),
        title: Text(profile.displayName, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          '${profile.points ?? 0} puan · ${profile.wins ?? 0}G / ${profile.losses ?? 0}M',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
        ),
      ),
    );
  }
}
