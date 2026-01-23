import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Player extends RectangleComponent
    with HasGameReference<FlameGame>, KeyboardHandler {
  static const double _speed = 800.0;
  int _horizontalDirection = 0;
  double _sensorInput = 0.0;
  StreamSubscription? _subscription;

  Player()
      : super(
          paint: Paint()..color = Colors.white,
          size: Vector2(200, 20),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());

    position = Vector2(
      game.size.x / 2,
      game.size.y - 50 - (size.y / 2),
    );

    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      // Use accelerometer as requested by user.
      // Detecting gravity on Y axis.
      _subscription =
          accelerometerEventStream().listen((AccelerometerEvent event) {
        _sensorInput = event.y;
      });
    }
  }

  @override
  void onRemove() {
    _subscription?.cancel();
    super.onRemove();
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

    double input = _horizontalDirection.toDouble();

    // Add sensor input
    // Accelerometer values allow for position control based on tilt
    if (_sensorInput.abs() > 0.5) {
      // Divide by a factor to normalize range (e.g. 10 -> 2)
      input += _sensorInput * 0.2;
    }

    if (input != 0) {
      position.x += input * _speed * dt;
    }

    position.x = position.x.clamp(size.x / 2, game.size.x - (size.x / 2));
  }
}
