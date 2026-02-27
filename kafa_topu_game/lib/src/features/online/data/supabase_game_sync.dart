import 'package:supabase_flutter/supabase_flutter.dart';

import 'online_session_service.dart';

/// Supabase Realtime broadcast for game sync (e.g. "opponent in settings").
/// Channel: head_soccer:room:{roomId}
/// Events: player_entered_settings, player_left_settings (payload: player_id)
class SupabaseGameSync {
  SupabaseGameSync(this._session);

  final OnlineSessionService _session;
  RealtimeChannel? _channel;
  String? _currentRoomId;
  String? _myPlayerId;

  static const String _channelPrefix = 'head_soccer:room:';
  static const String _eventEnteredSettings = 'player_entered_settings';
  static const String _eventLeftSettings = 'player_left_settings';
  static const String _payloadPlayerId = 'player_id';

  bool get isConnected => _channel != null && _currentRoomId != null;

  /// Join a room. Both players must use the same roomId (e.g. match code).
  /// myPlayerId: local player id so we ignore our own broadcast.
  Future<void> joinRoom(String roomId, String myPlayerId) async {
    await leaveRoom();
    _myPlayerId = myPlayerId;
    _currentRoomId = roomId;
    final client = Supabase.instance.client;
    _channel = client.channel('$_channelPrefix$roomId')
      ..onBroadcast(
        event: _eventEnteredSettings,
        callback: (payload) {
          final senderId = payload[_payloadPlayerId] as String?;
          if (senderId != null && senderId != _myPlayerId) {
            _session.setOpponentInSettings();
          }
        },
      )
      ..onBroadcast(
        event: _eventLeftSettings,
        callback: (payload) {
          final senderId = payload[_payloadPlayerId] as String?;
          if (senderId != null && senderId != _myPlayerId) {
            _session.clearOpponentInSettings();
          }
        },
      )
      ..subscribe();
  }

  Future<void> leaveRoom() async {
    if (_channel != null) {
      await _channel!.unsubscribe();
      _channel = null;
    }
    _currentRoomId = null;
    _myPlayerId = null;
  }

  /// Call when this player opens settings.
  Future<void> sendPlayerEnteredSettings() async {
    if (_channel == null || _myPlayerId == null) return;
    await _channel!.sendBroadcastMessage(
      event: _eventEnteredSettings,
      payload: {_payloadPlayerId: _myPlayerId!},
    );
  }

  /// Call when this player closes settings.
  Future<void> sendPlayerLeftSettings() async {
    if (_channel == null || _myPlayerId == null) return;
    await _channel!.sendBroadcastMessage(
      event: _eventLeftSettings,
      payload: {_payloadPlayerId: _myPlayerId!},
    );
  }
}
