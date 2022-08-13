import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import '../simple_game.dart';

class Cell extends PositionComponent with HasGameRef<SimpleGame> {
  int row = 0;
  int column = 0;
  Color color = Colors.white;

  Cell(this.row, this.column, this.color);

  @override
  double get x => (column + 0.50) * GameConfig.cellSize;

  @override
  double get y => (row + 0.50) * GameConfig.cellSize;

  double get sideSize => GameConfig.cellSize;

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(x, y),
        width: sideSize,
        height: sideSize,
      ),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }
}

mixin Pushable {}

mixin Unpushable {}
