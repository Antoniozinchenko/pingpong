import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game.dart';
import '../components/brick.dart';
import 'player.dart';

class Ball extends CircleComponent
    with HasGameReference<PingPongGame>, CollisionCallbacks {
  final Vector2 velocity = Vector2.all(400); // 45 degrees, speed 400

  Ball()
      : super(
            paint: Paint()..color = Colors.white,
            radius: 10,
            anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(CircleHitbox());

    // Find player to set initial position
    final player = game.findByKeyName<Player>('player') ??
        game.children.whereType<Player>().first;

    // Position on top of player (centered horizontally on player)
    position = Vector2(
        player.position.x, player.position.y - player.size.y / 2 - radius - 10);
    // Ensure starting velocity is upwards
    velocity.y = -velocity.y.abs();
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    // Screen bouncing
    if (position.x - radius <= 0 && velocity.x < 0) {
      velocity.x = -velocity.x;
    } else if (position.x + radius >= game.size.x && velocity.x > 0) {
      velocity.x = -velocity.x;
    }

    if (position.y - radius <= 0 && velocity.y < 0) {
      velocity.y = -velocity.y;
    } else if (position.y + radius >= game.size.y && velocity.y > 0) {
      game.resetGame();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player || other is Brick) {
      final dx = (position.x - other.position.x).abs();
      final dy = (position.y - other.position.y).abs();

      final overlapX = (radius + other.size.x / 2) - dx;
      final overlapY = (radius + other.size.y / 2) - dy;

      if (overlapX < overlapY) {
        // Horizontal collision (Side)
        velocity.x = -velocity.x;
        // Bump out to prevent sticking
        if (position.x < other.position.x) {
          position.x -= overlapX;
        } else {
          position.x += overlapX;
        }
      } else {
        // Vertical collision
        velocity.y = -velocity.y;
        // Bump out
        if (position.y < other.position.y) {
          position.y -= overlapY;
        } else {
          position.y += overlapY;
        }
      }
    }
  }
}
