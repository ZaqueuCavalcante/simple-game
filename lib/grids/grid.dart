import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import '../simple_game.dart';

class Grid extends PositionComponent with HasGameRef<SimpleGame> {
  static Paint paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.00;

  static double cellSize = GameConfig.cellSize;
  static int rows = GameConfig.rows;
  static int columns = GameConfig.columns;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (int row = 0; row < rows + 1; row++) {
      canvas.drawLine(Offset(0, row * cellSize),
          Offset(columns * cellSize, row * cellSize), paint);
    }

    for (int column = 0; column < columns + 1; column++) {
      canvas.drawLine(Offset(column * cellSize, 0),
          Offset(column * cellSize, rows * cellSize), paint);
    }
  }
}
