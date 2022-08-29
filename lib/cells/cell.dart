import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import '../simple_game.dart';

class Cell extends PositionComponent with HasGameRef<SimpleGame> {
  int row = 0;
  int column = 0;
  Color color = Colors.white;

  double cellSize = GameConfig.cellSize;

  Cell(this.row, this.column, this.color) {
    position = Vector2(column * cellSize, row * cellSize);
    size = Vector2(cellSize, cellSize);
  }

  void renderCell(Canvas canvas, Color color) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, cellSize, cellSize),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  void render(Canvas canvas) {
    renderCell(canvas, color);
  }
}

mixin Pushable {}

mixin Unpushable {}
