import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import '../kafa_topu_game.dart';

class PlayerComponent extends PositionComponent
    with HasGameReference<KafaTopuGame> {
  final int playerId;
  final double startX;
  final bool isLeft;

  double velocityY = 0;
  double velocityX = 0;
  bool onGround = true;

  PlayerComponent({
    required this.playerId,
    required this.startX,
    required this.isLeft,
  }) : super(
          position: Vector2(startX, KafaTopuGame.groundY - KafaTopuGame.playerRadius),
          size: Vector2.all(KafaTopuGame.playerRadius * 2),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await add(CircleHitbox(
      radius: KafaTopuGame.playerRadius,
      position: size / 2,
      anchor: Anchor.center,
    ));
  }

  void jump() {
    if (onGround) {
      velocityY = KafaTopuGame.jumpForce;
      onGround = false;
    }
  }

  void moveLeft() {
    velocityX = -KafaTopuGame.moveSpeed;
  }

  void moveRight() {
    velocityX = KafaTopuGame.moveSpeed;
  }

  void reset() {
    position.x = startX;
    position.y = KafaTopuGame.groundY - KafaTopuGame.playerRadius;
    velocityX = 0;
    velocityY = 0;
    onGround = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    velocityY += KafaTopuGame.gravity;
    position.y += velocityY;
    position.x += velocityX;

    if (isLeft) {
      position.x = position.x.clamp(50.0, 380.0);
    } else {
      position.x = position.x.clamp(420.0, 750.0);
    }

    if (position.y >= KafaTopuGame.groundY - KafaTopuGame.playerRadius) {
      position.y = KafaTopuGame.groundY - KafaTopuGame.playerRadius;
      velocityY = 0;
      onGround = true;
    }

    velocityX *= 0.9;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = playerId == 1 ? const Color(0xFF4CAF50) : const Color(0xFF2196F3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      KafaTopuGame.playerRadius,
      paint,
    );

    final borderPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(
      Offset(size.x / 2, size.y / 2),
      KafaTopuGame.playerRadius,
      borderPaint,
    );

    final eyePaint = Paint()..color = const Color(0xFF000000);
    final eyeOffset = playerId == 1 ? 8.0 : -8.0;
    canvas.drawCircle(
      Offset(size.x / 2 + eyeOffset - 5, size.y / 2 - 5),
      4,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(size.x / 2 + eyeOffset + 5, size.y / 2 - 5),
      4,
      eyePaint,
    );
  }
}
