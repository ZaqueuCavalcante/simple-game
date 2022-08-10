import 'dart:math';

import 'package:flutter/material.dart';
import '../game_config.dart';

import 'cell.dart';

class PlayerCell extends Cell {
  int vx = 0;
  int vy = 1;

  PlayerCell(int row, int column) : super(row, column, Colors.greenAccent);

  bool isOn(int row, int column) {
    return this.row == row && this.column == column;
  }

  bool isParked() => vx == 0 && vy == 0;

  bool isGoingToLeft() => vx == -1;

  bool isGoingToRight() => vx == 1;

  bool isGoingToUp() => vy == -1;

  bool isGoingToDown() => vy == 1;

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

  @override
  void update(double dt) {
    super.update(dt);

    row = row + vy;
    column = column + vx;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    var cellSize = GameConfig.cellSize;
    var x = (column + 0.50) * cellSize;
    var y = (row + 0.50) * cellSize;

    if (isParked()) {
      var path = Path();
      path.moveTo(x + cellSize / 3, y);
      path.lineTo(x, y + cellSize / 3);
      path.lineTo(x - cellSize / 3, y);
      path.lineTo(x, y - cellSize / 3);
      path.close();
      canvas.drawPath(path, Paint()..color = Colors.black);
    } else {
      var path = Path();
      path.moveTo(x + vx * cellSize / 2, y + vy * cellSize / 2);
      path.lineTo(x + vy * cellSize / 4, y + vx * cellSize / 4);
      path.lineTo(x - vy * cellSize / 4, y - vx * cellSize / 4);
      path.close();
      canvas.drawPath(path, Paint()..color = Colors.black);
    }
  }
}
