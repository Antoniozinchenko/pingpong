import 'package:flame/components.dart';
import 'package:flutter/services.dart';

import '../game/ping_pong_game.dart';

class GameInputHandler extends Component
    with HasGameReference<PingPongGame>, KeyboardHandler {
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        game.isPaused = !game.isPaused;
        return true;
      }
    }
    return true;
  }
}
