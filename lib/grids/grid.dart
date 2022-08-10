import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../cells/apple_cell.dart';
import '../cells/border_cell.dart';
import '../cells/cell.dart';
import '../cells/empty_cell.dart';
import '../cells/player_cell.dart';
import '../game_config.dart';
import '../my_stack.dart';
import '../main.dart';
import 'cell_index.dart';

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

  PlayerCell player = PlayerCell(5, 5);
  AppleCell apple = AppleCell(0, 0);

  Grid();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    addVerticalBorders();
    addHorizontalBorders();

    addCell(player);

    addInitialObstacles();

    addRandomApple();
  }

  void addVerticalBorders() {
    for (int row = 0; row < GameConfig.rows; row++) {
      var text =
          (row == 0 || row == (GameConfig.rows - 1)) ? '' : row.toString();
      text = (GameConfig.showBordersIndex) ? text : '';

      addCell(BorderCell(row, 0, text: text));
      addCell(BorderCell(row, GameConfig.columns - 1, text: text));
    }
  }

  void addHorizontalBorders() {
    for (int column = 1; column < GameConfig.columns - 1; column++) {
      var text = (GameConfig.showBordersIndex) ? column.toString() : '';

      addCell(BorderCell(0, column, text: text));
      addCell(BorderCell(GameConfig.rows - 1, column, text: text));
    }
  }

  void addCell(Cell cell) {
    board[cell.row][cell.column].push(cell);
  }

  void addObstacle(int row, int column) {
    board[row][column].push(BorderCell(row, column));
  }

  void addInitialObstacles() {
    if (GameConfig.addInitialObstacles) {
      addObstacle(2, 6);
      addObstacle(3, 5);
      addObstacle(2, 2);
      addObstacle(1, 8);
      addObstacle(4, 7);
      addObstacle(5, 4);
      addObstacle(4, 2);
      addObstacle(4, 6);
    }
  }

  void addRandomApple() {
    List<CellIndex> emptyCells = <CellIndex>[];
    for (int row = 1; row < GameConfig.rows - 1; row++) {
      for (int column = 1; column < GameConfig.columns - 1; column++) {
        if (cellAt(row, column) is EmptyCell) {
          emptyCells.add(CellIndex(row, column));
        }
      }
    }
    var randomIndex = Random().nextInt(emptyCells.length);
    var randomCell = emptyCells[randomIndex];
    apple = AppleCell(randomCell.row, randomCell.column);
    addCell(apple);
  }

  Cell cellAt(int row, int column) {
    return board[row][column].peek();
  }

  void useSimpleAppleTracker() {
    int playerRow = player.row;
    int playerColumn = player.column;

    int appleRow = apple.row;
    int appleColumn = apple.column;

    if (GameConfig.useSimpleAppleTracker) {
      if (Random().nextBool()) {
        if (appleRow > playerRow) {
          player.goToDown();
        } else if (appleRow < playerRow) {
          player.goToUp();
        } else if (appleColumn > playerColumn) {
          player.goToRight();
        } else if (appleColumn < playerColumn) {
          player.goToLeft();
        }
      } else {
        if (appleColumn > playerColumn) {
          player.goToRight();
        } else if (appleColumn < playerColumn) {
          player.goToLeft();
        } else if (appleRow > playerRow) {
          player.goToDown();
        } else if (appleRow < playerRow) {
          player.goToUp();
        }
      }
    }
  }

  void useCollisionsAvoider() {
    int playerRow = player.row;
    int playerColumn = player.column;

    if (player.isGoingToUp()) {
      var up = cellAt(playerRow - 1, playerColumn);
      var left = cellAt(playerRow, playerColumn - 1);
      var right = cellAt(playerRow, playerColumn + 1);
      var down = cellAt(playerRow + 1, playerColumn);
      if (up is BorderCell) {
        if (left is Pushable && right is Pushable) {
          player.goToLeftOrRightRandomly();
        } else {
          if (left is Pushable) {
            player.goToLeft();
          } else if (right is Pushable) {
            player.goToRight();
          } else if (down is Pushable) {
            player.goToDown();
          } else {
            player.park();
          }
        }
      }
    } else if (player.isGoingToDown()) {
      var down = cellAt(playerRow + 1, playerColumn);
      var left = cellAt(playerRow, playerColumn - 1);
      var right = cellAt(playerRow, playerColumn + 1);
      var up = cellAt(playerRow - 1, playerColumn);
      if (down is BorderCell) {
        if (left is Pushable && right is Pushable) {
          player.goToLeftOrRightRandomly();
        } else {
          if (left is Pushable) {
            player.goToLeft();
          } else if (right is Pushable) {
            player.goToRight();
          } else if (up is Pushable) {
            player.goToUp();
          } else {
            player.park();
          }
        }
      }
    } else if (player.isGoingToLeft()) {
      var left = cellAt(playerRow, playerColumn - 1);
      var up = cellAt(playerRow - 1, playerColumn);
      var down = cellAt(playerRow + 1, playerColumn);
      var right = cellAt(playerRow, playerColumn + 1);
      if (left is BorderCell) {
        if (up is Pushable && down is Pushable) {
          player.goToUpOrDownRandomly();
        } else {
          if (up is Pushable) {
            player.goToUp();
          } else if (down is Pushable) {
            player.goToDown();
          } else if (right is Pushable) {
            player.goToRight();
          } else {
            player.park();
          }
        }
      }
    } else if (player.isGoingToRight()) {
      var right = cellAt(playerRow, playerColumn + 1);
      var up = cellAt(playerRow - 1, playerColumn);
      var down = cellAt(playerRow + 1, playerColumn);
      var left = cellAt(playerRow, playerColumn - 1);
      if (right is BorderCell) {
        if (up is Pushable && down is Pushable) {
          player.goToUpOrDownRandomly();
        } else {
          if (up is Pushable) {
            player.goToUp();
          } else if (down is Pushable) {
            player.goToDown();
          } else if (left is Pushable) {
            player.goToLeft();
          } else {
            player.park();
          }
        }
      }
    }
  }

  void updatePlayer(double dt) {
    int oldRow = player.row;
    int oldColumn = player.column;

    player.update(dt);

    var newRow = player.row;
    var newColumn = player.column;

    if (cellAt(newRow, newColumn) is EmptyCell) {
      board[newRow][newColumn].push(board[oldRow][oldColumn].pop());
    } else if (cellAt(newRow, newColumn) is AppleCell) {
      board[newRow][newColumn].pop();

      if (GameConfig.pushObstacleOnEatApple) {
        addCell(BorderCell(newRow, newColumn, text: 'X'));
      }

      board[newRow][newColumn].push(board[oldRow][oldColumn].pop());
      addRandomApple();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Trackers
    useSimpleAppleTracker();

    // Collisions avoider
    useCollisionsAvoider();

    // Update player
    updatePlayer(dt);

    // Update apple
    apple.update(dt);
    if (apple.isDead()) {
      board[apple.row][apple.column].pop();
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
