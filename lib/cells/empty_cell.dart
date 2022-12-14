import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import 'apple_cell.dart';
import 'cell.dart';

class EmptyCell extends Cell with Pushable, Comparable {
  int G = 0;
  int H = 0;
  EmptyCell? parentCell;

  GameConfig configs;

  EmptyCell(int row, int column, this.configs)
      : super(row, column, Colors.grey);

  int get F => G + H;

  void resetCostsAndParent() {
    G = 0;
    H = 0;
    parentCell = null;
  }

  void calculateCosts(AppleCell apple) {
    G = parentCell!.G + 1;
    H = (apple.row - row).abs() + (apple.column - column).abs();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (GameConfig.renderVisitedCellsInPathfinding && F > 0) {
      renderCell(canvas, Colors.blue);
    }

    if (configs.renderCellsCosts) {
      TextPaint textPaint = TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: GameConfig.cellSize / 5,
          fontWeight: FontWeight.bold,
          fontFamily: 'Awesome Font',
        ),
      );

      textPaint.render(
          canvas, F.toString(), Vector2(0.35 * cellSize, 0.20 * cellSize));
      textPaint.render(
          canvas, G.toString(), Vector2(0.10 * cellSize, 0.60 * cellSize));
      textPaint.render(
          canvas, H.toString(), Vector2(0.55 * cellSize, 0.60 * cellSize));
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
