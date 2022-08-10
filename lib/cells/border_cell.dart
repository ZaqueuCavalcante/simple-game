import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_config.dart';
import 'cell.dart';

class BorderCell extends Cell {
  String text;

  BorderCell(int row, int column, {this.text = ''})
      : super(row, column, Colors.yellow);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    var x = (column + 0.35) * GameConfig.cellSize;
    var y = (row + 0.25) * GameConfig.cellSize;

    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Awesome Font',
      ),
    );

    textPaint.render(canvas, text, Vector2(x, y));
  }
}
