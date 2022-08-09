import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'cell.dart';
import 'game_config.dart';
import 'my_stack.dart';
import 'main.dart';

class GridIndex {
  int row = 0;
  int column = 0;

  GridIndex(this.row, this.column);
}

class Grid extends PositionComponent with HasGameRef<SnakeGame> {
  List<List<MyStack<Cell>>> board = List.generate(GameConfig.rows, (row) {
    return List.generate(GameConfig.columns, (column) {
      {
        var stack = MyStack<Cell>();
        stack.push(EmptyCell(row, column));
        return stack;
      }
    });
  });

  Grid();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Vertical borders
    for (int row = 0; row < GameConfig.rows; row++) {
      addCell(BorderCell(row, 0, row));
      addCell(BorderCell(row, GameConfig.columns - 1, row));
    }
    // Horizontal borders
    for (int column = 1; column < GameConfig.columns - 1; column++) {
      addCell(BorderCell(0, column, column));
      addCell(BorderCell(GameConfig.rows - 1, column, column));
    }

    // Snake
    addCell(SnakeHeadCell(5, 5));

    // Obstacles
    // addObstacles();

    // Random apple
    addRandomApple();
  }

  void addCell(Cell cell) {
    board[cell.row][cell.column].push(cell);
  }

  void addObstacles() {
    addCell(BorderCell(2, 6, 0));
    addCell(BorderCell(3, 5, 0));
    addCell(BorderCell(2, 2, 0));
    addCell(BorderCell(1, 8, 0));
    addCell(BorderCell(4, 7, 0));
    addCell(BorderCell(5, 4, 0));
    addCell(BorderCell(4, 2, 0));
    addCell(BorderCell(4, 6, 0));
  }

  void addRandomApple() {
    List<GridIndex> places = <GridIndex>[];
    for (int row = 1; row < GameConfig.rows - 1; row++) {
      for (int column = 1; column < GameConfig.columns - 1; column++) {
        if (board[row][column].peek() is EmptyCell) {
          places.add(GridIndex(row, column));
        }
      }
    }
    var random = Random();
    var randomIndex = random.nextInt(places.length);
    var randomPlace = places[randomIndex];
    addCell(AppleCell(randomPlace.row, randomPlace.column));
  }

  @override
  void update(double dt) {
    super.update(dt);

    int snakeHeadRow = 0;
    int snakeHeadColumn = 0;

    int foodRow = 0;
    int foodColumn = 0;

    for (int row = 1; row < GameConfig.rows - 1; row++) {
      for (int column = 1; column < GameConfig.columns - 1; column++) {
        if (board[row][column].peek() is SnakeHeadCell) {
          snakeHeadRow = row;
          snakeHeadColumn = column;
        } else if (board[row][column].peek() is AppleCell) {
          foodRow = row;
          foodColumn = column;
        }
      }
    }

    // Smart snake logic
    var snake = board[snakeHeadRow][snakeHeadColumn].peek() as SnakeHeadCell;

    // Track food logic
    if (GameConfig.trackFood) {
      if (foodRow > snakeHeadRow) {
        snake.goToDown();
      } else if (foodRow < snakeHeadRow) {
        snake.goToUp();
      } else if (foodColumn > snakeHeadColumn) {
        snake.goToRight();
      } else if (foodColumn < snakeHeadColumn) {
        snake.goToLeft();
      }
    }
    // Track food logic

    var random = Random();

    if (snake.isGoingToUp()) {
      var up = board[snakeHeadRow - 1][snakeHeadColumn].peek();
      var left = board[snakeHeadRow][snakeHeadColumn - 1].peek();
      var right = board[snakeHeadRow][snakeHeadColumn + 1].peek();
      if (up is BorderCell) {
        if (left is SnakePushable && right is SnakePushable) {
          if (random.nextBool()) {
            snake.goToLeft();
          } else {
            snake.goToRight();
          }
        } else {
          if (left is SnakePushable) {
            snake.goToLeft();
          } else if (right is SnakePushable) {
            snake.goToRight();
          } else {
            snake.goToDown();
          }
        }
      }
    } else if (snake.isGoingToDown()) {
      var down = board[snakeHeadRow + 1][snakeHeadColumn].peek();
      var left = board[snakeHeadRow][snakeHeadColumn - 1].peek();
      var right = board[snakeHeadRow][snakeHeadColumn + 1].peek();
      if (down is BorderCell) {
        if (left is SnakePushable && right is SnakePushable) {
          if (random.nextBool()) {
            snake.goToLeft();
          } else {
            snake.goToRight();
          }
        } else {
          if (left is SnakePushable) {
            snake.goToLeft();
          } else if (right is SnakePushable) {
            snake.goToRight();
          } else {
            snake.goToUp();
          }
        }
      }
    } else if (snake.isGoingToLeft()) {
      var left = board[snakeHeadRow][snakeHeadColumn - 1].peek();
      var up = board[snakeHeadRow - 1][snakeHeadColumn].peek();
      var down = board[snakeHeadRow + 1][snakeHeadColumn].peek();
      if (left is BorderCell) {
        if (up is SnakePushable && down is SnakePushable) {
          if (random.nextBool()) {
            snake.goToUp();
          } else {
            snake.goToDown();
          }
        } else {
          if (up is SnakePushable) {
            snake.goToUp();
          } else if (down is SnakePushable) {
            snake.goToDown();
          } else {
            snake.goToRight();
          }
        }
      }
    } else if (snake.isGoingToRight()) {
      var right = board[snakeHeadRow][snakeHeadColumn + 1].peek();
      var up = board[snakeHeadRow - 1][snakeHeadColumn].peek();
      var down = board[snakeHeadRow + 1][snakeHeadColumn].peek();
      if (right is BorderCell) {
        if (up is SnakePushable && down is SnakePushable) {
          if (random.nextBool()) {
            snake.goToUp();
          } else {
            snake.goToDown();
          }
        } else {
          if (up is SnakePushable) {
            snake.goToUp();
          } else if (down is SnakePushable) {
            snake.goToDown();
          } else {
            snake.goToLeft();
          }
        }
      }
    }
    // Smart snake logic

    board[snakeHeadRow][snakeHeadColumn].peek().update(dt);
    var newRow = board[snakeHeadRow][snakeHeadColumn].peek().row;
    var newColumn = board[snakeHeadRow][snakeHeadColumn].peek().column;

    if (board[newRow][newColumn].peek() is EmptyCell) {
      board[newRow][newColumn].push(board[snakeHeadRow][snakeHeadColumn].pop());
    } else if (board[newRow][newColumn].peek() is AppleCell) {
      board[newRow][newColumn].pop();

      if (GameConfig.pushObstacleOnEatFood) {
        addCell(BorderCell(newRow, newColumn, 1));
      }

      board[newRow][newColumn].push(board[snakeHeadRow][snakeHeadColumn].pop());
      addRandomApple();
    }
  }

  @override
  void render(Canvas canvas) {
    for (int row = 0; row < GameConfig.rows; row++) {
      for (int column = 0; column < GameConfig.columns; column++) {
        board[row][column].peek().render(canvas);
      }
    }

    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.00;

    for (int row = 0; row < GameConfig.rows + 1; row++) {
      canvas.drawLine(
          Offset(0, row * GameConfig.cellSize),
          Offset((GameConfig.columns) * GameConfig.cellSize,
              row * GameConfig.cellSize),
          paint);
    }

    for (int column = 0; column < GameConfig.columns + 1; column++) {
      canvas.drawLine(
          Offset(column * GameConfig.cellSize, 0),
          Offset(column * GameConfig.cellSize,
              (GameConfig.rows) * GameConfig.cellSize),
          paint);
    }
  }
}
