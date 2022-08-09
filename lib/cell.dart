import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'game_config.dart';
import 'main.dart';

mixin SnakePushable {}

class Cell extends PositionComponent with HasGameRef<SnakeGame> {
  int row = 0;
  int column = 0;
  Color color = Colors.white;

  Cell(this.row, this.column, this.color);

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(
          (column + 0.50) * GameConfig.cellSize,
          (row + 0.50) * GameConfig.cellSize,
        ),
        width: GameConfig.cellSize,
        height: GameConfig.cellSize,
      ),
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
  }
}

class BorderCell extends Cell {
  int index;

  BorderCell(int row, int column, this.index) : super(row, column, Colors.yellow);

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

    textPaint.render(canvas, index.toString(), Vector2(x, y));
  }
}

class EmptyCell extends Cell with SnakePushable {
  EmptyCell(int row, int column) : super(row, column, Colors.grey);
}

class AppleCell extends Cell with SnakePushable {
  AppleCell(int row, int column) : super(row, column, Colors.red);
}

class SnakeHeadCell extends Cell {
  int vx = 0;
  int vy = 1;

  SnakeHeadCell(int row, int column) : super(row, column, Colors.greenAccent);

  bool isOn(int row, int column) {
    return this.row == row && this.column == column;
  }

  bool isParked() => vx == 0 && vy == 0;
  bool isGoingToLeft() => vx == -1;
  bool isGoingToRight() => vx == 1;
  bool isGoingToUp() => vy == -1;
  bool isGoingToDown() => vy == 1;

  void goToLeft() { vx = -1; vy = 0; }
  void goToRight() { vx = 1; vy = 0; }
  void goToUp() { vx = 0; vy = -1; }
  void goToDown() { vx = 0; vy = 1; }

  @override
  void update(double dt) {
    super.update(dt);

    print('row=$row, column=$column --- vx=$vx, vy=$vy');

    row = row + vy;
    column = column + vx;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    var x = (column + 0.50) * GameConfig.cellSize;
    var y = (row + 0.50) * GameConfig.cellSize;

    if (isParked()) {
      var path = Path();
      path.moveTo(x + GameConfig.cellSize/3, y);

      path.lineTo(x, y + GameConfig.cellSize/3);
      path.lineTo(x - GameConfig.cellSize/3, y);
      path.lineTo(x, y - GameConfig.cellSize/3);

      path.close();
      canvas.drawPath(path, Paint()..color = Colors.black);
    } else {
      var path = Path();
      path.moveTo(x + vx*GameConfig.cellSize/2, y + vy*GameConfig.cellSize/2);
      path.lineTo(x + vy*GameConfig.cellSize/4, y + vx*GameConfig.cellSize/4);
      path.lineTo(x - vy*GameConfig.cellSize/4, y - vx*GameConfig.cellSize/4);
      path.close();
      canvas.drawPath(path, Paint()..color = Colors.black);
    }
  }
}

class SnakeBodyCell extends Cell {
  SnakeBodyCell(int row, int column) : super(row, column, Colors.green);
}
