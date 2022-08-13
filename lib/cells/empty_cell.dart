import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_config.dart';
import 'cell.dart';

class EmptyCell extends Cell with Pushable, Comparable {
  int G = 0;
  int H = 0;
  EmptyCell? parentCell;

  EmptyCell(int row, int column) : super(row, column, Colors.grey);

  int get F => G + H;

  void resetCostsAndParent() {
    G = 0;
    H = 0;
    parentCell = null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (GameConfig.renderVisitedCellsInPathfinding && F > 0) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, y),
          width: sideSize,
          height: sideSize,
        ),
        Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.fill,
      );
    }

    if (GameConfig.renderCellsCosts) {
      var delta = 0.20 * sideSize;

      TextPaint textPaint = TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Awesome Font',
        ),
      );

      textPaint.render(
          canvas, F.toString(), Vector2(x - delta / 2, y - 1.50 * delta));
      textPaint.render(
          canvas, G.toString(), Vector2(x - 2 * delta, y + 0.50 * delta));
      textPaint.render(
          canvas, H.toString(), Vector2(x + 0.50 * delta, y + 0.50 * delta));
    }
  }

  @override
  int compareTo(other) {
    if (F < other.F) {
      return -1;
    }

    if (F > other.F) {
      return 1;
    }

    return 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is EmptyCell && other.row == row && other.column == column;
  }

  @override
  int get hashCode => row * row + column * column + row;
}
