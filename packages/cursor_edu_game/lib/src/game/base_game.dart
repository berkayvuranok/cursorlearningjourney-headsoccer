import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

/// 🌟
/// BaseGame is the base class for Flame games.
/// Includes collision and keyboard support.
abstract class BaseGame extends FlameGame
    with HasCollisionDetection, TapCallbacks, KeyboardEvents {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    camera.viewport = FixedResolutionViewport(resolution: Vector2(800, 450));
  }
}
