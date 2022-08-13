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

    if (GameConfig.appleIsDeadly) {
      life = life - GameConfig.appleLifeDiscount;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (GameConfig.appleIsDeadly) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, y),
          width: sideSize,
          height: sideSize,
        ),
        Paint()
          ..color = Colors.grey
          ..style = PaintingStyle.fill,
      );

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, y),
          width: life * sideSize,
          height: life * sideSize,
        ),
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );
    }
  }
}
