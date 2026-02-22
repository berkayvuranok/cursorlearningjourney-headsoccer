import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cursor_edu_game/cursor_edu_game.dart';

import 'components/ball.dart';
import 'components/player.dart';
import 'components/goal.dart';
import 'components/ground.dart';

class KafaTopuGame extends BaseGame {
  late PlayerComponent player1;
  late PlayerComponent player2;
  late BallComponent ball;
  late GoalComponent goalLeft;
  late GoalComponent goalRight;
  late TextComponent scoreText;
  int score1 = 0;
  int score2 = 0;

  static const double groundY = 350;
  static const double playerRadius = 35;
  static const double ballRadius = 25;
  static const double jumpForce = -15;
  static const double gravity = 0.8;
  static const double moveSpeed = 5;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(GroundComponent());
    goalLeft = GoalComponent(isLeft: true);
    goalRight = GoalComponent(isLeft: false);
    add(goalLeft);
    add(goalRight);

    player1 = PlayerComponent(
      playerId: 1,
      startX: 120,
      isLeft: true,
    );
    player2 = PlayerComponent(
      playerId: 2,
      startX: 680,
      isLeft: false,
    );
    add(player1);
    add(player2);

    ball = BallComponent();
    add(ball);

    scoreText = TextComponent(
      text: '0 - 0',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
      ),
    )
      ..anchor = Anchor.topCenter
      ..position = Vector2(400, 20);
    add(scoreText);
  }

  int _goalCooldownFrames = 0;

  void onGoalScored(bool isLeftGoal) {
    if (_goalCooldownFrames > 0) return;
    _goalCooldownFrames = 30;

    if (isLeftGoal) {
      score2++;
    } else {
      score1++;
    }
    scoreText.text = '$score1 - $score2';
    resetPositions();
  }

  void resetPositions() {
    player1.reset();
    player2.reset();
    ball.reset();
  }

  final Set<LogicalKeyboardKey> _keysPressed = {};

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    _keysPressed.clear();
    _keysPressed.addAll(keysPressed);

    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyW:
          player1.jump();
          break;
        case LogicalKeyboardKey.keyA:
          player1.moveLeft();
          break;
        case LogicalKeyboardKey.keyD:
          player1.moveRight();
          break;
        case LogicalKeyboardKey.arrowUp:
          player2.jump();
          break;
        case LogicalKeyboardKey.arrowLeft:
          player2.moveLeft();
          break;
        case LogicalKeyboardKey.arrowRight:
          player2.moveRight();
          break;
        default:
          break;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_goalCooldownFrames > 0) _goalCooldownFrames--;
    if (_keysPressed.contains(LogicalKeyboardKey.keyA)) {
      player1.moveLeft();
    }
    if (_keysPressed.contains(LogicalKeyboardKey.keyD)) {
      player1.moveRight();
    }
    if (_keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      player2.moveLeft();
    }
    if (_keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      player2.moveRight();
    }
  }
}
