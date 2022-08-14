import 'package:flutter/material.dart';
import '../game_config.dart';
import 'cell.dart';

class AppleCell extends Cell with Pushable {
  double life = 1.00;

  static double cellSize = GameConfig.cellSize;

  AppleCell(int row, int column) : super(row, column, Colors.red);

  @override
  void update(double dt) {
    super.update(dt);

    if (GameConfig.appleIsDeadly) {
      life = life - GameConfig.appleLifeDiscount;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (GameConfig.appleIsDeadly) {
      renderCell(canvas, Colors.grey);

      canvas.drawRect(
        Rect.fromLTWH(0, 0, life * cellSize, life * cellSize),
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }
  }

  bool isDead() {
    return life < 0.00;
  }
}
