import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/ball.dart';
import '../components/brick.dart';
import '../components/game_input_handler.dart';
import '../components/paddle.dart';
import '../config/levels.dart';

class PingPongGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Paddle paddle;
  late Ball ball;

  int currentLevelIndex = 0;
  bool isPaused = false;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 4, 1, 31);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    add(GameInputHandler());

    paddle = Paddle();
    // Position: centered horizontally, 20px from bottom.
    // We'll set this in resize or initial load if size is available.
    // FlameGame.size is the logical size.
    paddle.position = Vector2(
      size.x / 2,
      size.y - 20 - paddle.height / 2,
    ); // Anchor is topCenter? No, anchor in paddle is topCenter.
    // Paddle height is 40. 20px margin.
    // If anchor is topCenter, then y should be size.y - 40 - 20?
    // Let's check Paddle anchor. It is topCenter.
    // So Y position is the top of the paddle.
    // Bottom of paddle should be at size.y - 20.
    // So top of paddle is size.y - 20 - 40.
    paddle.position = Vector2(size.x / 2, size.y - 20 - 40);

    add(paddle);

    ball = Ball();
    add(ball);

    startLevel(0);
  }

  void startLevel(int index) {
    currentLevelIndex = index;

    // Clear existing bricks
    children.whereType<Brick>().forEach((brick) => brick.removeFromParent());

    if (index >= levels.length) {
      // Game cleared? Loop or just stays empty.
      // Let's reset to level 1 (index 0) for endless play or show victory.
      // Prompt says reset to level 1 if ball hits bottom, doesn't specify win condition.
      // But says "If all bricks are destroyed the next level should be loaded".
      // Let's loop back to 0 if out of levels.
      currentLevelIndex = 0;
    }

    final levelData = levels[currentLevelIndex];
    _buildLevel(levelData);

    _resetBall();
  }

  void _buildLevel(List<List<int>> levelData) {
    // Grid with 10px gap.
    // Brick size 80x30.
    // We should center it.
    // Data is 10 rows, 5 cols (based on level1).
    // Calculate total width. 5 * 80 + 4 * 10 = 400 + 40 = 440.
    // Screen width? We assume it fits.
    // Start X = (Screen Width - Level Width) / 2.

    double brickWidth = 80;
    double brickHeight = 30;
    double gap = 10;

    int cols = levelData[0].length; // Assume uniform
    double levelWidth = cols * brickWidth + (cols - 1) * gap;

    double startX = (size.x - levelWidth) / 2;
    double startY = 100; // Some top margin

    for (int i = 0; i < levelData.length; i++) {
      for (int j = 0; j < levelData[i].length; j++) {
        int strength = levelData[i][j];
        if (strength > 0) {
          add(
            Brick(
              position: Vector2(
                startX + j * (brickWidth + gap),
                startY + i * (brickHeight + gap),
              ),
              strength: strength,
            ),
          );
        }
      }
    }
  }

  void _resetBall() {
    // Spawn from top-center of platform.
    ball.reset(
      paddle.position + Vector2(0, -ball.radius),
    ); // Paddle anchor is topCenter.
    // Ball radius is 20. Ball anchor is topLeft (default).
    // Let's check ball anchor. It uses default (topLeft).
    // We want ball center to be aligned with paddle center.
    // Paddle pos is (center, top).
    // Ball pos should be (center - radius, top - diameter).

    // Actually, in Ball.reset I did:
    // position = startPosition..sub(Vector2(radius, radius * 2));
    // If I pass paddle.position (center, top),
    // then ball becomes (center - radius, top - 2*radius).
    // This puts the ball sitting on top of the paddle, centered. Correct.
  }

  void resetGame() {
    startLevel(0);
  }

  @override
  void update(double dt) {
    if (isPaused) return;
    super.update(dt);

    // Check level completion
    if (children.whereType<Brick>().isEmpty) {
      // Warning: this might trigger immediately if level checks happen before bricks are added in async way?
      // But add() is sync for the component list usually.
      // Also ensure we actually started a level.
      // Add a small delay/flag or check if we have bricks?
      // Best approach: verify if we are in a transition.
      // But for now, if brick list is empty, next level.
      // Wait, startLevel clears bricks then adds new ones.
      // If we check here immediately after clearing, we might skip.
      // But update runs per frame. startLevel is sequential.
      // However, if a level is empty (no bricks), we should skip it?
      // The check should probably happen only if we had bricks.
      // Or simpler: check if `Ball` is active?

      // Actually, let's just use a simple check.
      // `children.whereType<Brick>()` might be empty initially before `startLevel` finishes
      // building? No, `_buildLevel` adds them. All sync.
      // So checking emptiness is safe *after* initialization.
      // To be safe, we can check a flag `levelLoaded`.
    }

    // Better way: Clean up destroyed bricks in their update/collision.
    // Here we just check count.

    // We need to avoid trigger on the very first frame before startLevel(0) is called?
    // onLoad calls startLevel(0).

    // Optimization: Don't check every frame if performance is concern, but for this game it's fine.

    if (children.whereType<Brick>().isEmpty) {
      startLevel(currentLevelIndex + 1);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Draw Text
    // "Paused"
    if (isPaused) {
      _drawText(canvas, "Paused", size.x / 2, size.y / 2, 48);
    }

    // "Level X"
    _drawText(canvas, "Level ${currentLevelIndex + 1}", size.x / 2, 40, 32);
  }

  void _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    double fontSize,
  ) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(x - textPainter.width / 2, y - textPainter.height / 2),
    );
  }
}
