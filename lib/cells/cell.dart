import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import '../main.dart';

class Cell extends PositionComponent with HasGameRef<SnakeGame> {
  int row = 0;
  int column = 0;
  Color color = Colors.white;

  Cell(this.row, this.column, this.color);

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(
          (column + 0.50) * GameConfig.cellSize,
          (row + 0.50) * GameConfig.cellSize,
        ),
        width: GameConfig.cellSize,
        height: GameConfig.cellSize,
      ),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }
}

mixin Pushable {}
