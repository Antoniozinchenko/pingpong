import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/ping_pong_game.dart';
import 'brick.dart';
import 'paddle.dart';

class Ball extends CircleComponent
    with HasGameReference<PingPongGame>, CollisionCallbacks {
  Vector2 velocity = Vector2.zero();
  final double speed = 400.0;

  Ball()
    : super(
        radius: 20,
        paint: Paint()..color = Colors.white,
        children: [CircleHitbox()],
      );

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isPaused) return;

    position += velocity * dt;

    // Screen collisions
    // Left
    if (position.x <= 0) {
      position.x = 0;
      velocity.x = -velocity.x;
    }
    // Right
    if (position.x + width >= game.size.x) {
      position.x = game.size.x - width;
      velocity.x = -velocity.x;
    }
    // Top
    if (position.y <= 0) {
      position.y = 0;
      velocity.y = -velocity.y;
    }
    // Bottom (Game Over / Reset)
    if (position.y >= game.size.y) {
      game.resetGame();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Brick || other is Paddle) {
      // Basic collision response
      // Determine side of collision

      // Improve collision logic to prevent getting stuck
      // Simple bounce: invert Y if top/bottom hit, invert X if side hit.
      // We can use the intersection points to guess.

      final otherCenter = other.absoluteCenter;
      final ballCenter = absoluteCenter;

      final diff = ballCenter - otherCenter;

      // Normalize diff to see dominant direction
      if (diff.x.abs() * other.size.y > diff.y.abs() * other.size.x) {
        // Side hit
        velocity.x = -velocity.x;
      } else {
        // Top/Bottom hit
        velocity.y = -velocity.y;
      }
    }
  }

  void reset(Vector2 startPosition) {
    position = startPosition
      ..sub(Vector2(radius, radius * 2)); // Position above paddle
    // 45 degrees to top right: x=1, y=-1
    velocity = Vector2(1, -1).normalized() * speed;
  }
}
