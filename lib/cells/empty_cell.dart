import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game_config.dart';
import 'cell.dart';

class EmptyCell extends Cell with Pushable, Comparable {
  int G = 0;
  int H = 0;
  EmptyCell? parentCell;

  EmptyCell(int row, int column) : super(row, column, Colors.grey);

  int getF() => G + H;

  void resetCosts() {
    G = 0;
    H = 0;
    parentCell = null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    var x = (column + 0.35) * GameConfig.cellSize;
    var y = (row + 0.25) * GameConfig.cellSize;
    var delta = 0.20 * GameConfig.cellSize;

    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Awesome Font',
      ),
    );

    textPaint.render(canvas, getF().toString(), Vector2(x, y - delta));
    textPaint.render(canvas, G.toString(), Vector2(x - delta, y + delta));
    textPaint.render(canvas, H.toString(), Vector2(x + delta, y + delta));

    // if (parentCell != null) {
    //   var cellSize = GameConfig.cellSize;
    //   var x = (column + 0.50) * cellSize;
    //   var y = (row + 0.50) * cellSize;
    //
    //   int vx = 0;
    //   int vy = 0;
    //
    //   if (parentCell!.column == column) {
    //     vx = 0;
    //     if (parentCell!.row < row) {
    //       vy = -1;
    //     } else {
    //       vy = 1;
    //     }
    //   }
    //
    //   if (parentCell!.row == row) {
    //     vy = 0;
    //     if (parentCell!.column < column) {
    //       vx = -1;
    //     } else {
    //       vx = 1;
    //     }
    //   }
    //
    //   Paint paint = Paint()
    //     ..color = Colors.black
    //     ..style = PaintingStyle.stroke
    //     ..strokeWidth = 5.00;
    //
    //   var path = Path();
    //   path.moveTo(x + vx * cellSize / 4, y + vy * cellSize / 4);
    //   path.lineTo(x + vx * cellSize / 2, y + vy * cellSize / 2);
    //   path.close();
    //   canvas.drawPath(path, paint);
    // }
  }

  @override
  int compareTo(other) {
    var thisF = getF();
    var otherF = other.getF();

    if (thisF < otherF) {
      return -1;
    }

    if (thisF > otherF) {
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
  int get hashCode => row * row + column * column;
}
