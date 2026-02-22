import 'dart:ui';
import 'package:flame/components.dart';
import '../kafa_topu_game.dart';

class GroundComponent extends PositionComponent
    with HasGameReference<KafaTopuGame> {
  GroundComponent()
      : super(
          position: Vector2(0, KafaTopuGame.groundY),
          size: Vector2(800, 100),
          anchor: Anchor.topLeft,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, paint);

    final linePaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, 0), Offset(800, 0), linePaint);
    canvas.drawLine(Offset(400, 0), Offset(400, 100), linePaint);

    final circlePaint = Paint()
      ..color = const Color(0x33FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(const Offset(400, 50), 40, circlePaint);
  }
}
