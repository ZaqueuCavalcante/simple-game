import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_config.dart';
import 'cell.dart';

class EmptyCell extends Cell with Pushable, Comparable {
  int G = 0;
  int H = 0;

  EmptyCell(int row, int column) : super(row, column, Colors.grey);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    var x = (column + 0.35) * GameConfig.cellSize;
    var y = (row + 0.25) * GameConfig.cellSize;
    var delta = 0.20 * GameConfig.cellSize;

    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Awesome Font',
      ),
    );

    textPaint.render(canvas, (G+H).toString(), Vector2(x, y - delta));
    textPaint.render(canvas, G.toString(), Vector2(x - delta, y + delta));
    textPaint.render(canvas, H.toString(), Vector2(x + delta, y + delta));
  }

  @override
  int compareTo(other) {
    var thisF = G+H;
    var otherF = other.G + other.H;

    if (thisF < otherF) {
      return -1;
    }

    if (thisF > otherF) {
      return 1;
    }

    return 0;
  }
}
