import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Player extends RectangleComponent
    with HasGameReference<FlameGame>, KeyboardHandler {
  static const double _speed = 800.0;
  int _horizontalDirection = 0;

  Player()
      : super(
          paint: Paint()..color = Colors.white,
          size: Vector2(300, 20),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());
    // Position at bottom center with 50px margin from bottom.
    // Since anchor is center, we need to account for half height.
    position = Vector2(
      game.size.x / 2,
      game.size.y - 50 - (size.y / 2),
    );
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _horizontalDirection = 0;
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _horizontalDirection -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _horizontalDirection += 1;
    }
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_horizontalDirection != 0) {
      position.x += _horizontalDirection * _speed * dt;
    }

    // Clamp position within screen boundaries
    // Since anchor is center, the x position represents the center of the paddle.
    // Min x = half width, Max x = screen width - half width
    position.x = position.x.clamp(size.x / 2, game.size.x - (size.x / 2));
  }
}
