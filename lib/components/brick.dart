import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/ping_pong_game.dart';
import 'ball.dart';

class Brick extends RectangleComponent
    with CollisionCallbacks, HasGameReference<PingPongGame> {
  int strength;

  Brick({required Vector2 position, required this.strength})
    : super(
        position: position,
        size: Vector2(80, 30),
        children: [RectangleHitbox()],
      );

  @override
  void onLoad() {
    _updateColor();
    super.onLoad();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Ball) {
      hit();
    }
  }

  void hit() {
    strength--;
    if (strength <= 0) {
      removeFromParent();
    } else {
      _updateColor();
    }
  }

  void _updateColor() {
    switch (strength) {
      case 1:
        paint = Paint()..color = Colors.grey;
        break;
      case 2:
        paint = Paint()..color = const Color(0xFFFFD700); // Gold
        break;
      case 3:
        paint = Paint()..color = Colors.red;
        break;
      default:
        paint = Paint()..color = Colors.white;
    }
  }
}
