import 'dart:math';
import 'package:flutter/material.dart';
import '../game_config.dart';
import 'cell.dart';

class PlayerCell extends Cell with Unpushable {
  int vx = 1;
  int vy = 0;

  static double cellSize = GameConfig.cellSize;

  PlayerCell(int row, int column) : super(row, column, Colors.greenAccent);

  @override
  void update(double dt) {
    super.update(dt);

    row = row + vy;
    column = column + vx;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    var path = Path();

    var x = cellSize/2;
    var y = cellSize/2;

    if (isParked()) {
      path.moveTo(x + cellSize / 3, y);
      path.lineTo(x, y + cellSize / 3);
      path.lineTo(x - cellSize / 3, y);
      path.lineTo(x, y - cellSize / 3);
      path.close();
    } else {
      path.moveTo(x + vx * cellSize / 2, y + vy * cellSize / 2);
      path.lineTo(x + vy * cellSize / 4, y + vx * cellSize / 4);
      path.lineTo(x - vy * cellSize / 4, y - vx * cellSize / 4);
      path.close();
    }

    canvas.drawPath(path, Paint()..color = Colors.black);
  }

  bool isOn(int row, int column) {
    return this.row == row && this.column == column;
  }

  bool isParked() => vx == 0 && vy == 0;

  bool isNotParked() => !isParked();

  bool isGoingToLeft() => vx == -1;

  bool isGoingToRight() => vx == 1;

  bool isGoingToUp() => vy == -1;

  bool isGoingToDown() => vy == 1;

  void park() {
    vx = 0;
    vy = 0;
  }

  void goToLeft() {
    vx = -1;
    vy = 0;
  }

  void goToRight() {
    vx = 1;
    vy = 0;
  }

  void goToUp() {
    vx = 0;
    vy = -1;
  }

  void goToDown() {
    vx = 0;
    vy = 1;
  }

  void goToLeftOrRightRandomly() {
    if (Random().nextBool()) {
      goToLeft();
    } else {
      goToRight();
    }
  }

  void goToUpOrDownRandomly() {
    if (Random().nextBool()) {
      goToUp();
    } else {
      goToDown();
    }
  }

  void goToRandomly() {
    if (Random().nextBool()) {
      goToLeftOrRightRandomly();
    } else {
      goToUpOrDownRandomly();
    }
  }

  void goToNeighbor(Cell cell) {
    int nextRow = cell.row;
    int nextColumn = cell.column;

    if (nextRow == row) {
      if (nextColumn > column) {
        goToRight();
      } else if (nextColumn < column) {
        goToLeft();
      }
    } else {
      if (nextRow > row) {
        goToDown();
      } else if (nextRow < row) {
        goToUp();
      }
    }
  }
}
