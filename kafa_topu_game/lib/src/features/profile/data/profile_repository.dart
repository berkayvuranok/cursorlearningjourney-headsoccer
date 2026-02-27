import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase_config.dart';
import '../../../shared/player_profile.dart';

class ProfileRow {
  const ProfileRow({
    required this.id,
    required this.deviceId,
    required this.displayName,
    required this.skin,
    this.wins,
    this.losses,
    this.points,
  });

  final String id;
  final String deviceId;
  final String displayName;
  final String skin;
  final int? wins;
  final int? losses;
  final int? points;

  PlayerSkin get skinEnum {
    switch (skin) {
      case 'classicBlue':
        return PlayerSkin.classicBlue;
      case 'lava':
        return PlayerSkin.lava;
      case 'ice':
        return PlayerSkin.ice;
      default:
        return PlayerSkin.classicGreen;
    }
  }

  static String skinToString(PlayerSkin s) {
    switch (s) {
      case PlayerSkin.classicBlue:
        return 'classicBlue';
      case PlayerSkin.lava:
        return 'lava';
      case PlayerSkin.ice:
        return 'ice';
      default:
        return 'classicGreen';
    }
  }
}

class MatchRow {
  const MatchRow({
    required this.id,
    required this.score1,
    required this.score2,
    this.player1Name,
    this.player2Name,
    this.winnerDeviceId,
    required this.createdAt,
  });

  final String id;
  final int score1;
  final int score2;
  final String? player1Name;
  final String? player2Name;
  final String? winnerDeviceId;
  final DateTime createdAt;
}

class ProfileRepository {
  ProfileRepository._();
  static final ProfileRepository instance = ProfileRepository._();

  SupabaseClient? get _client =>
      SupabaseConfig.isConfigured ? Supabase.instance.client : null;

  Future<ProfileRow?> getProfileByDeviceId(String deviceId) async {
    final client = _client;
    if (client == null) return null;
    try {
      final res = await client
          .from('profiles')
          .select()
          .eq('device_id', deviceId)
          .maybeSingle();
      if (res == null) return null;
      return ProfileRow(
        id: res['id'] as String,
        deviceId: res['device_id'] as String,
        displayName: res['display_name'] as String? ?? 'Player',
        skin: res['skin'] as String? ?? 'classicGreen',
      );
    } catch (_) {
      return null;
    }
  }

  Future<ProfileRow?> upsertProfile(String deviceId, String displayName, String skin) async {
    final client = _client;
    if (client == null) return null;
    try {
      final res = await client.from('profiles').upsert(
            {
              'device_id': deviceId,
              'display_name': displayName,
              'skin': skin,
              'updated_at': DateTime.now().toIso8601String(),
            },
            onConflict: 'device_id',
          ).select().maybeSingle();
      if (res == null) return null;
      return ProfileRow(
        id: res['id'] as String,
        deviceId: res['device_id'] as String,
        displayName: res['display_name'] as String? ?? 'Player',
        skin: res['skin'] as String? ?? 'classicGreen',
      );
    } catch (_) {
      return null;
    }
  }

  Future<List<ProfileRow>> getLeaderboard({int limit = 20}) async {
    final client = _client;
    if (client == null) return [];
    try {
      final res = await client.from('leaderboard').select().limit(limit);
      return (res as List)
          .map((e) => ProfileRow(
                id: e['id'] as String,
                deviceId: e['device_id'] as String,
                displayName: e['display_name'] as String? ?? 'Player',
                skin: e['skin'] as String? ?? 'classicGreen',
                wins: e['wins'] as int?,
                losses: e['losses'] as int?,
                points: e['points'] as int?,
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<MatchRow>> getMatchesForDevice(String deviceId, {int limit = 20}) async {
    final client = _client;
    if (client == null) return [];
    try {
      final res = await client
          .from('matches')
          .select('id, score1, score2, player1_device_id, player2_device_id, winner_device_id, created_at')
          .or('player1_device_id.eq.$deviceId,player2_device_id.eq.$deviceId')
          .order('created_at', ascending: false)
          .limit(limit);
      return (res as List)
          .map((e) => MatchRow(
                id: e['id'] as String,
                score1: e['score1'] as int? ?? 0,
                score2: e['score2'] as int? ?? 0,
                winnerDeviceId: e['winner_device_id'] as String?,
                createdAt: DateTime.parse(e['created_at'] as String),
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> insertMatch({
    required String player1DeviceId,
    required String player2DeviceId,
    required int score1,
    required int score2,
    String? winnerDeviceId,
    bool isOnline = false,
  }) async {
    final client = _client;
    if (client == null) return;
    try {
      await client.from('matches').insert({
        'player1_device_id': player1DeviceId,
        'player2_device_id': player2DeviceId,
        'score1': score1,
        'score2': score2,
        'winner_device_id': winnerDeviceId,
        'is_online': isOnline,
      });
    } catch (_) {}
  }
}
