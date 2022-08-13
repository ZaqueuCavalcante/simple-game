import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_config.dart';
import 'cell.dart';

class BorderCell extends Cell with Unpushable {
  int index;

  BorderCell(int row, int column, this.index)
      : super(row, column, Colors.yellow);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (GameConfig.showBordersIndex &&
        index != 0 &&
        index != GameConfig.rows - 1) {
      var deltaX = index > 9 ? 0.30 * sideSize : 0.15 * sideSize;
      var deltaY = 0.25 * sideSize;

      TextPaint textPaint = TextPaint(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Awesome Font',
        ),
      );

      textPaint.render(
          canvas, index.toString(), Vector2(x - deltaX, y - deltaY));
    }
  }
}
