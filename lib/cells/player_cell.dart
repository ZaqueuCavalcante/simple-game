import 'dart:math';

import 'package:flutter/material.dart';

import 'cell.dart';

class PlayerCell extends Cell with Unpushable {
  int vx = 1;
  int vy = 0;

  PlayerCell(int row, int column) : super(row, column, Colors.greenAccent);

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

    if (isParked()) {
      path.moveTo(x + sideSize / 3, y);
      path.lineTo(x, y + sideSize / 3);
      path.lineTo(x - sideSize / 3, y);
      path.lineTo(x, y - sideSize / 3);
      path.close();
    } else {
      path.moveTo(x + vx * sideSize / 2, y + vy * sideSize / 2);
      path.lineTo(x + vy * sideSize / 4, y + vx * sideSize / 4);
      path.lineTo(x - vy * sideSize / 4, y - vx * sideSize / 4);
      path.close();
    }

    canvas.drawPath(path, Paint()..color = Colors.black);
  }
}
