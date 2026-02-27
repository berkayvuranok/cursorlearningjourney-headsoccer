import 'dart:async';
import 'package:flutter/foundation.dart';

import 'supabase_game_sync.dart';

/// Tracks online match state. When one player opens settings, the other sees
/// "Opponent in settings - waiting" with a 10s countdown.
/// Uses Supabase Realtime broadcast when configured.
class OnlineSessionService extends ChangeNotifier {
  OnlineSessionService._();

  static final OnlineSessionService instance = OnlineSessionService._();
  SupabaseGameSync? _sync;

  static const int settingsWaitSeconds = 10;

  bool _opponentInSettings = false;
  int _countdownSeconds = 0;
  Timer? _countdownTimer;

  bool get opponentInSettings => _opponentInSettings;
  int get countdownSeconds => _countdownSeconds;

  /// Join room for online match (call when entering online game).
  Future<void> joinRoom(String roomId, String myPlayerId) async {
    _sync ??= SupabaseGameSync(instance);
    await _sync!.joinRoom(roomId, myPlayerId);
  }

  /// Leave room (call when leaving online game).
  Future<void> leaveRoom() => _sync?.leaveRoom() ?? Future.value();

  /// Call when THIS player opens settings (sends via Supabase; other device sets opponentInSettings).
  void notifyImInSettings() {
    _opponentInSettings = false;
    _countdownSeconds = 0;
    _countdownTimer?.cancel();
    notifyListeners();
    _sync?.sendPlayerEnteredSettings();
  }

  /// Call when the OTHER player opened settings (received from Supabase or test).
  void setOpponentInSettings() {
    if (_opponentInSettings) return;
    _opponentInSettings = true;
    _countdownSeconds = settingsWaitSeconds;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _countdownSeconds--;
      notifyListeners();
      if (_countdownSeconds <= 0) {
        _countdownTimer?.cancel();
        _opponentInSettings = false;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  /// Call when THIS player closed settings (notify peer via Supabase).
  void notifyImBackFromSettings() {
    _sync?.sendPlayerLeftSettings();
  }

  /// Call when WE receive "opponent left settings" from backend.
  void clearOpponentInSettings() {
    _opponentInSettings = false;
    _countdownSeconds = 0;
    _countdownTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
