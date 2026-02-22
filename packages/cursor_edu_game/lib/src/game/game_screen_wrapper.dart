import 'package:flame/game.dart';
import 'package:flutter/material.dart';

/// Wraps the game widget in a Material screen.
class GameScreenWrapper<T extends FlameGame> extends StatelessWidget {
  const GameScreenWrapper({
    super.key,
    required this.game,
  });

  final T game;

  @override
  Widget build(BuildContext context) {
    return GameWidget<T>(game: game);
  }
}
