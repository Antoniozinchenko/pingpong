import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game/ping_pong_game.dart';

class Paddle extends PositionComponent
    with HasGameReference<PingPongGame>, KeyboardHandler, CollisionCallbacks {
  final double _speed = 400.0;
  int _moveDirection = 0;

  Paddle()
    : super(
        size: Vector2(200, 40),
        anchor: Anchor.topCenter,
        children: [RectangleHitbox()],
      );

  @override
  void onLoad() {
    // 20 pixels bottom margin.
    // We set position in the game class or here.
  }

  // We can just render a rect.
  // Custom render for visual if needed, but debug mode shows hitboxes.
  // Let's add a rectangle component as child or just render.
  // Actually PositionComponent doesn't render by default.
  // Let's extend RectangleComponent or add render.
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      size.toRect(),
      Paint()..color = const Color(0xFF4287f5),
    ); // Blue-ish
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _moveDirection = 0;
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _moveDirection = -1;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _moveDirection = 1;
    }
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.isPaused) return;

    if (_moveDirection != 0) {
      position.x += _moveDirection * _speed * dt;
    }

    // Clamp to screen
    position.x = position.x.clamp(size.x / 2, game.size.x - size.x / 2);
  }
}
