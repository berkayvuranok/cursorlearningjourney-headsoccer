import 'dart:async';
import 'package:flutter/foundation.dart';

/// Tracks online match state. When one player opens settings, the other sees
/// "Opponent in settings - waiting" with a 10s countdown.
/// TODO(backend): Sync via WebSocket/Supabase so the other device receives this.
class OnlineSessionService extends ChangeNotifier {
  OnlineSessionService._();
  static final OnlineSessionService instance = OnlineSessionService._();

  static const int settingsWaitSeconds = 10;

  bool _opponentInSettings = false;
  int _countdownSeconds = 0;
  Timer? _countdownTimer;

  bool get opponentInSettings => _opponentInSettings;
  int get countdownSeconds => _countdownSeconds;

  /// Call when THIS player opens settings (sends to backend; other device sets opponentInSettings).
  void notifyImInSettings() {
    _opponentInSettings = false;
    _countdownSeconds = 0;
    _countdownTimer?.cancel();
    notifyListeners();
    // TODO(backend): Send "player_entered_settings" to peer.
  }

  /// Call when the OTHER player opened settings (received from backend).
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

  /// Call when THIS player closed settings (notify peer to clear waiting).
  void notifyImBackFromSettings() {
    // TODO(backend): Send "player_left_settings" to peer.
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
