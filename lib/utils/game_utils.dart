import 'package:flame/components.dart';
import '../game.dart';
import '../components/brick.dart';

class GameUtils {
  static void buildLevel(PingPongGame game, List<List<int>> levelData) {
    game.children.whereType<Brick>().forEach((b) => b.removeFromParent());

    const double margin = 4.0;
    const double topOffset = 50.0;

    if (levelData.isEmpty) return;

    final int rows = levelData.length;
    final int cols = levelData[0].length;

    final double totalMargins = (cols + 1) * margin;
    final double availableWidth = game.size.x - totalMargins;
    final double brickWidth = availableWidth / cols;
    const double brickHeight = 15.0;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final strength = (c < levelData[r].length) ? levelData[r][c] : 0;
        if (strength > 0) {
          final x = margin + c * (brickWidth + margin) + brickWidth / 2;
          final y = topOffset + r * (brickHeight + margin) + brickHeight / 2;

          game.add(Brick(
            position: Vector2(x, y),
            size: Vector2(brickWidth, brickHeight),
            strength: strength,
          ));
        }
      }
    }
  }
}
