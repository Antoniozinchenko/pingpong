import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../actors/ball.dart';
import '../game.dart';

class Brick extends RectangleComponent
    with HasGameReference<PingPongGame>, CollisionCallbacks {
  int strength;

  Brick({required Vector2 position, Vector2? size, required this.strength})
      : super(
          position: position,
          size: size ?? Vector2(40, 10),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _updateColor();
    add(RectangleHitbox());
  }

  void _updateColor() {
    if (strength == 3) {
      paint.color = Colors.red;
    } else if (strength == 2) {
      paint.color = const Color(0xFFFFD700); // Gold
    } else {
      paint.color = Colors.grey;
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Ball) {
      strength--;
      if (strength <= 0) {
        removeFromParent();
        game.increaseScore();
      } else {
        _updateColor();
      }
    }
  }
}
