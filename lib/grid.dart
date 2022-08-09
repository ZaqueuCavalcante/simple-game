import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'cell.dart';
import 'game_config.dart';
import 'main.dart';

class Grid extends PositionComponent with HasGameRef<SnakeGame> {
  List<List<Cell>> board = List.generate(GameConfig.rows, (_) {
    return List.generate(GameConfig.columns, (_) => EmptyCell(0, 0));
  });

  Grid();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Vertical borders
    for (int row = 0; row < GameConfig.rows; row++) {
      board[row][0] = BorderCell(row, 0, row);
      board[row][GameConfig.columns - 1] =
          BorderCell(row, GameConfig.columns - 1, row);
    }
    // Horizontal borders
    for (int column = 1; column < GameConfig.columns - 1; column++) {
      board[0][column] = BorderCell(0, column, column);
      board[GameConfig.rows - 1][column] =
          BorderCell(GameConfig.rows - 1, column, column);
    }

    // Empty cells
    for (int row = 1; row < GameConfig.rows - 1; row++) {
      for (int column = 1; column < GameConfig.columns - 1; column++) {
        board[row][column] = EmptyCell(row, column);
      }
    }

    // Snake
    List<Cell> snake = <Cell>[];
    snake.add(SnakeHeadCell(5, 5));
    addCell(snake[0]);

    // Random apple
    var random = Random();
    var randomRow = 1 + random.nextInt(GameConfig.rows - 2);
    var randomColumn = 1 + random.nextInt(GameConfig.columns - 2);
    board[randomRow][randomColumn] = AppleCell(randomRow, randomColumn);

    // Obstacles
    addCell(BorderCell(2, 6, 0));
    addCell(BorderCell(3, 5, 0));
    addCell(BorderCell(2, 2, 0));
    addCell(BorderCell(1, 8, 0));
    addCell(BorderCell(4, 7, 0));
    addCell(BorderCell(5, 4, 0));
    addCell(BorderCell(4, 2, 0));
    addCell(BorderCell(4, 6, 0));
  }

  void addCell(Cell cell) {
    board[cell.row][cell.column] = cell;
  }

  @override
  void update(double dt) {
    super.update(dt);

    int snakeHeadRow = 0;
    int snakeHeadColumn = 0;

    for (int row = 1; row < GameConfig.rows - 1; row++) {
      for (int column = 1; column < GameConfig.columns - 1; column++) {
        if (board[row][column] is SnakeHeadCell) {
          snakeHeadRow = row;
          snakeHeadColumn = column;
        }
      }
    }

    // Smart snake logic
    var snake = board[snakeHeadRow][snakeHeadColumn] as SnakeHeadCell;

    var random = Random();

    if (snake.isGoingToUp()) {
      var up = board[snakeHeadRow - 1][snakeHeadColumn];
      var left = board[snakeHeadRow][snakeHeadColumn - 1];
      var right = board[snakeHeadRow][snakeHeadColumn + 1];
      if (up is BorderCell) {
        if (left is EmptyCell && right is EmptyCell) {
          if (random.nextBool()) {
            snake.goToLeft();
          } else {
            snake.goToRight();
          }
        } else {
          if (left is EmptyCell) {
            snake.goToLeft();
          } else if (right is EmptyCell) {
            snake.goToRight();
          } else {
            snake.goToDown();
          }
        }
      }
    } else if (snake.isGoingToDown()) {
      var down = board[snakeHeadRow + 1][snakeHeadColumn];
      var left = board[snakeHeadRow][snakeHeadColumn - 1];
      var right = board[snakeHeadRow][snakeHeadColumn + 1];
      if (down is BorderCell) {
        if (left is EmptyCell && right is EmptyCell) {
          if (random.nextBool()) {
            snake.goToLeft();
          } else {
            snake.goToRight();
          }
        } else {
          if (left is EmptyCell) {
            snake.goToLeft();
          } else if (right is EmptyCell) {
            snake.goToRight();
          } else {
            snake.goToUp();
          }
        }
      }
    } else if (snake.isGoingToLeft()) {
      var left = board[snakeHeadRow][snakeHeadColumn - 1];
      var up = board[snakeHeadRow - 1][snakeHeadColumn];
      var down = board[snakeHeadRow + 1][snakeHeadColumn];
      if (left is BorderCell) {
        if (up is EmptyCell && down is EmptyCell) {
          if (random.nextBool()) {
            snake.goToUp();
          } else {
            snake.goToDown();
          }
        } else {
          if (up is EmptyCell) {
            snake.goToUp();
          } else if (down is EmptyCell) {
            snake.goToDown();
          } else {
            snake.goToRight();
          }
        }
      }
    } else if (snake.isGoingToRight()) {
      var right = board[snakeHeadRow][snakeHeadColumn + 1];
      var up = board[snakeHeadRow - 1][snakeHeadColumn];
      var down = board[snakeHeadRow + 1][snakeHeadColumn];
      if (right is BorderCell) {
        if (up is EmptyCell && down is EmptyCell) {
          if (random.nextBool()) {
            snake.goToUp();
          } else {
            snake.goToDown();
          }
        } else {
          if (up is EmptyCell) {
            snake.goToUp();
          } else if (down is EmptyCell) {
            snake.goToDown();
          } else {
            snake.goToLeft();
          }
        }
      }
    }

    // Smart snake logic

    board[snakeHeadRow][snakeHeadColumn].update(dt);
    var newRow = board[snakeHeadRow][snakeHeadColumn].row;
    var newColumn = board[snakeHeadRow][snakeHeadColumn].column;

    if (board[newRow][newColumn] is EmptyCell) {

    }


    board[newRow][newColumn] = board[snakeHeadRow][snakeHeadColumn];
    board[snakeHeadRow][snakeHeadColumn] =
        EmptyCell(snakeHeadRow, snakeHeadColumn);
  }

  @override
  void render(Canvas canvas) {
    for (int row = 0; row < GameConfig.rows; row++) {
      for (int column = 0; column < GameConfig.columns; column++) {
        board[row][column].render(canvas);
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
