import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'actors/ball.dart';
import 'actors/player.dart';
import 'components/brick.dart';
import 'ui/text_components.dart';
import 'utils/game_utils.dart';
import 'levels/levels.dart';

class PingPongGame extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  bool isPaused = false;
  late final PausedText pausedText;

  int score = 0;
  int record = 0;
  late final ScoreText scoreText;
  late final RecordText recordText;
  late final LevelText levelText;

  int currentLevelIndex = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // UI Components
    pausedText = PausedText();
    scoreText = ScoreText();
    recordText = RecordText();
    levelText = LevelText();

    add(scoreText);
    add(recordText);
    add(levelText);

    _loadLevel(0);
  }

  void _loadLevel(int index) {
    if (index >= GameLevels.allLevels.length) {
      index = 0;
    }
    currentLevelIndex = index;
    levelText.updateLevel(currentLevelIndex + 1);

    // Clear existing level cleanup
    children.whereType<Brick>().forEach((b) => b.removeFromParent());
    children.whereType<Ball>().forEach((b) => b.removeFromParent());
    children.whereType<Player>().forEach((p) => p.removeFromParent());

    // Add actors
    add(Player());
    add(Ball());

    // Build Bricks
    GameUtils.buildLevel(this, GameLevels.allLevels[currentLevelIndex]);
  }

  void resetGame() {
    if (score > record) {
      record = score;
      recordText.updateRecord(record);
    }
    score = 0;
    scoreText.updateScore(score);

    if (isPaused) {
      isPaused = false;
      if (pausedText.parent != null) remove(pausedText);
    }

    _loadLevel(0);
  }

  void increaseScore() {
    score++;
    scoreText.updateScore(score);
  }

  @override
  void update(double dt) {
    if (isPaused) {
      super.update(0);
    } else {
      super.update(dt);

      // Check for level completion
      // We check if we have initialized the level (ball exists) but ran out of bricks
      if (children.whereType<Ball>().isNotEmpty &&
          children.whereType<Brick>().isEmpty) {
        _loadLevel(currentLevelIndex + 1);
      }
    }
  }

  @override
  KeyEventResult onKeyEvent(
      KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.space) {
      isPaused = !isPaused;
      if (isPaused) {
        add(pausedText);
      } else {
        remove(pausedText);
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
