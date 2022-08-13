import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/game_config.dart';

import 'cell.dart';

class RockCell extends Cell with Unpushable {
  int collisions = 0;

  RockCell(int row, int column) : super(row, column, Colors.brown);

  bool isDead() {
    return collisions > GameConfig.rockMaxCollisions;
  }

  void saveCollision() {
    if (GameConfig.rockIsDeadly) {
      collisions++;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (GameConfig.rockIsDeadly) {
      var x = (column + 0.35) * sideSize;
      var y = (row + 0.25) * sideSize;

      TextPaint textPaint = TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Awesome Font',
        ),
      );

      textPaint.render(canvas, collisions.toString(), Vector2(x, y));
    }
  }
}
