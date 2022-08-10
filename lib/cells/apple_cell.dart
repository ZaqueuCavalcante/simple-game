import 'package:flutter/material.dart';

import '../game_config.dart';
import 'cell.dart';

class AppleCell extends Cell with Pushable {
  double life = 1.00;

  AppleCell(int row, int column) : super(row, column, Colors.red);

  bool isDead() {
    return life < 0.00;
  }

  @override
  void update(double dt) {
    super.update(dt);

    life = life - 0.05;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

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
        ..color = Colors.grey
        ..style = PaintingStyle.fill,
    );

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(
          (column + 0.50) * GameConfig.cellSize,
          (row + 0.50) * GameConfig.cellSize,
        ),
        width: life * GameConfig.cellSize,
        height: life * GameConfig.cellSize,
      ),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }
}
