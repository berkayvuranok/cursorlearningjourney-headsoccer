import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../kafa_topu_game.dart';
import 'player.dart';

class BallComponent extends PositionComponent
    with HasGameReference<KafaTopuGame>, CollisionCallbacks {
  double velocityX = 0;
  double velocityY = 0;
  static const double bounceDamping = 0.7;
  static const double kickMultiplier = 1.2;

  BallComponent()
      : super(
          position: Vector2(400, 200),
          size: Vector2.all(KafaTopuGame.ballRadius * 2),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await add(CircleHitbox(
      radius: KafaTopuGame.ballRadius,
      position: size / 2,
      anchor: Anchor.center,
    ));
  }

  void reset() {
    position.setValues(400, 200);
    velocityX = 0;
    velocityY = 0;
  }

  void kick(double dx, double dy) {
    velocityX += dx * kickMultiplier;
    velocityY += dy * kickMultiplier;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is PlayerComponent) {
      final player = other;
      final dx = position.x - player.position.x;
      final dy = position.y - player.position.y;
      final len = (dx * dx + dy * dy).abs();
      if (len > 0) {
        final norm = math.sqrt(len);
        kick(dx / norm * 8, dy / norm * 8 - 3);
      }
    }
  }

  static double get goalBottom => KafaTopuGame.groundY;
  static double get goalTop => goalBottom - KafaTopuGame.goalHeight;

  @override
  void update(double dt) {
    super.update(dt);

    velocityY += 0.5;
    position.x += velocityX;
    position.y += velocityY;

    final inGoalZoneY = position.y >= goalTop && position.y <= goalBottom;
    const goalWidth = 50.0;
    final fullyInLeftGoal = inGoalZoneY && position.x >= 0 && position.x <= goalWidth;
    final fullyInRightGoal = inGoalZoneY &&
        position.x >= KafaTopuGame.fieldWidth - goalWidth &&
        position.x <= KafaTopuGame.fieldWidth;
    if (fullyInLeftGoal) {
      game.onGoalScored(true);
      return;
    }
    if (fullyInRightGoal) {
      game.onGoalScored(false);
      return;
    }
    if (position.x <= KafaTopuGame.ballRadius) {
      if (!inGoalZoneY) {
        velocityX *= -bounceDamping;
        position.x = KafaTopuGame.ballRadius;
      }
    } else if (position.x >= KafaTopuGame.fieldWidth - KafaTopuGame.ballRadius) {
      if (!inGoalZoneY) {
        velocityX *= -bounceDamping;
        position.x = KafaTopuGame.fieldWidth - KafaTopuGame.ballRadius;
      }
    }

    if (position.y >= KafaTopuGame.groundY - KafaTopuGame.ballRadius) {
      position.y = KafaTopuGame.groundY - KafaTopuGame.ballRadius;
      velocityY *= -bounceDamping;
      velocityX *= 0.98;
    }

    if (position.y <= KafaTopuGame.ballRadius) {
      position.y = KafaTopuGame.ballRadius;
      velocityY *= -bounceDamping;
    }

    velocityX *= 0.995;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      KafaTopuGame.ballRadius,
      paint,
    );

    final stripePaint = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      KafaTopuGame.ballRadius,
      stripePaint,
    );
  }
}
