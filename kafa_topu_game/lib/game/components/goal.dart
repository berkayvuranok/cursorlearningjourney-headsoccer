import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../kafa_topu_game.dart';
import 'ball.dart';

class GoalComponent extends PositionComponent
    with HasGameReference<KafaTopuGame>, CollisionCallbacks {
  final bool isLeft;

  GoalComponent({required this.isLeft})
      : super(
          position: Vector2(isLeft ? 0 : 750, 180),
          size: Vector2(50, 170),
          anchor: isLeft ? Anchor.centerLeft : Anchor.centerRight,
        );

  @override
  Future<void> onLoad() async {
    await add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is BallComponent) {
      game.onGoalScored(isLeft);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..color = const Color(0x33FFFFFF)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);

    final borderPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRect(rect, borderPaint);
  }
}
