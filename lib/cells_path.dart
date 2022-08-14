import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/game_config.dart';
import 'cells/empty_cell.dart';
import 'simple_game.dart';

class CellsPath extends PositionComponent with HasGameRef<SimpleGame> {
  List<EmptyCell> cells = <EmptyCell>[];
  GameConfig configs;

  CellsPath(this.configs);

  void make(EmptyCell startCell, EmptyCell endCell) {
    cells.clear();

    if (endCell.parentCell != null) {
      EmptyCell? pathCell = endCell;
      while (pathCell != startCell) {
        cells.add(pathCell!);
        pathCell = pathCell.parentCell;
      }
      cells.add(startCell);
      cells = cells.reversed.toList();
    }
  }

  bool isEmpty() {
    return cells.isEmpty;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (configs.renderPath) {
      var cellSize = GameConfig.cellSize;

      Paint pathPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.00;

      for (var index = 1; index < cells.length - 1; index++) {
        var cellA = cells[index];
        var cellB = cells[index + 1];

        var xA = (cellA.column + 0.50) * cellSize;
        var yA = (cellA.row + 0.50) * cellSize;

        var xB = (cellB.column + 0.50) * cellSize;
        var yB = (cellB.row + 0.50) * cellSize;

        canvas.drawLine(Offset(xA, yA), Offset(xB, yB), pathPaint);

        canvas.drawCircle(Offset(xA, yA), cellSize / 15, pathPaint);
        canvas.drawCircle(Offset(xB, yB), cellSize / 15, pathPaint);
      }
    }
  }
}
