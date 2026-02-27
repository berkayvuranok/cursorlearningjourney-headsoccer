import 'package:flutter/material.dart';

/// Simple in-memory player profile and cosmetic system.
/// TODO(multiplayer): Persist profiles and sync across devices.

enum PlayerSkin {
  classicGreen,
  classicBlue,
  lava,
  ice,
}

extension PlayerSkinColor on PlayerSkin {
  Color get color {
    switch (this) {
      case PlayerSkin.classicGreen:
        return const Color(0xFF4CAF50);
      case PlayerSkin.classicBlue:
        return const Color(0xFF2196F3);
      case PlayerSkin.lava:
        return const Color(0xFFF44336);
      case PlayerSkin.ice:
        return const Color(0xFF00BCD4);
    }
  }

  String get label {
    switch (this) {
      case PlayerSkin.classicGreen:
        return 'Classic Green';
      case PlayerSkin.classicBlue:
        return 'Classic Blue';
      case PlayerSkin.lava:
        return 'Lava';
      case PlayerSkin.ice:
        return 'Ice';
    }
  }
}

class PlayerProfile {
  PlayerProfile({
    required this.name,
    required this.skin,
  });

  String name;
  PlayerSkin skin;
}

class PlayerProfileManager {
  PlayerProfileManager._();

  static final PlayerProfileManager instance = PlayerProfileManager._();

  // Default local profiles for two players on same device.
  final PlayerProfile player1 =
      PlayerProfile(name: 'Player 1', skin: PlayerSkin.classicGreen);
  final PlayerProfile player2 =
      PlayerProfile(name: 'Player 2', skin: PlayerSkin.classicBlue);

  PlayerProfile profileForId(int id) => id == 1 ? player1 : player2;

  // TODO(multiplayer): Map profiles to remote player IDs / sessions.
}

