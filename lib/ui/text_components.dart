import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../game.dart';

class PausedText extends TextComponent with HasGameReference<PingPongGame> {
  PausedText()
      : super(
          text: 'Paused',
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.red,
              fontSize: 48,
            ),
          ),
          anchor: Anchor.center,
          priority: 100,
        );

  @override
  void onLoad() {
    super.onLoad();
    position = game.size / 2;
  }
}

class ScoreText extends TextComponent with HasGameReference<PingPongGame> {
  ScoreText()
      : super(
          text: 'Score: 0',
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          anchor: Anchor.topRight,
          priority: 100,
        );

  @override
  void onLoad() {
    super.onLoad();
    position = Vector2(game.size.x - 20, 20);
  }

  void updateScore(int score) {
    text = 'Score: $score';
  }
}

class RecordText extends TextComponent with HasGameReference<PingPongGame> {
  RecordText()
      : super(
          text: 'Record: 0',
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          anchor: Anchor.topRight,
          priority: 100,
        );

  @override
  void onLoad() {
    super.onLoad();
    position = Vector2(game.size.x - 20, 50);
  }

  void updateRecord(int record) {
    text = 'Record: $record';
  }
}

class InstructionsText extends TextComponent
    with HasGameReference<PingPongGame> {
  InstructionsText()
      : super(
          text: _getInstructions(),
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              height: 1.5,
            ),
          ),
          anchor: Anchor.center,
          priority: 100,
        );

  static String _getInstructions() {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      return 'Controls:\nTilt to Move\nTap to Start/Pause';
    }
    return 'Controls:\nLeft/Right Arrows to Move\nSpace to Start/Pause';
  }

  @override
  void onLoad() {
    super.onLoad();
    position = game.size / 2;
  }
}
