import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../cells/apple_cell.dart';
import '../cells/border_cell.dart';
import '../cells/cell.dart';
import '../cells/empty_cell.dart';
import '../cells/player_cell.dart';
import '../cells/rock_cell.dart';
import '../game_config.dart';
import '../my_stack.dart';
import '../main.dart';
import '../scoreboard.dart';
import 'cell_index.dart';
import 'package:collection/collection.dart';

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

  PlayerCell player = PlayerCell(3, 3);
  AppleCell apple = AppleCell(0, 0);

  List<EmptyCell> path = <EmptyCell>[];

  Scoreboard scoreboard = Scoreboard();

  Grid();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    addVerticalBorders();
    addHorizontalBorders();

    addCell(player);

    addInitialObstacles();

   addRandomApple();
//     apple = AppleCell(1, 7);
//     addCell(apple);
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
    board[row][column].push(RockCell(row, column));
  }

  void addInitialObstacles() {
    if (GameConfig.addInitialObstacles) {
      addObstacle(2, 6);
      addObstacle(1, 6);
      addObstacle(3, 5);
      addObstacle(4, 4);
      addObstacle(5, 3);
      addObstacle(6, 2);
      //addObstacle(6, 1);
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

  Cell cellAtFirst(int row, int column) {
    return board[row][column].first();
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

  void followPath() {
    if (path.isEmpty) {
      return;
    }

    int playerRow = player.row;
    int playerColumn = player.column;

    int nextRow = path[1].row;
    int nextColumn = path[1].column;

    if (nextRow > playerRow) {
      player.goToDown();
    } else if (nextRow < playerRow) {
      player.goToUp();
    } else if (nextColumn > playerColumn) {
      player.goToRight();
    } else if (nextColumn < playerColumn) {
      player.goToLeft();
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
      if (up is Unpushable) {
        if (up is RockCell) {
          up.saveCollision();
        }

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
      if (down is Unpushable) {
        if (down is RockCell) {
          down.saveCollision();
        }

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
      if (left is Unpushable) {
        if (left is RockCell) {
          left.saveCollision();
        }

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
      if (right is Unpushable) {
        if (right is RockCell) {
          right.saveCollision();
        }

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
        addCell(RockCell(newRow, newColumn));
      }

      board[newRow][newColumn].push(board[oldRow][oldColumn].pop());
      addRandomApple();

      scoreboard.updateScore();
    }
  }

  void updateApple(double dt) {
    apple.update(dt);
    if (apple.isDead()) {
      board[apple.row][apple.column].pop();
      addRandomApple();
    }
  }

  void updateRocks() {
    int totalRocks = 0;
    for (int row = 1; row < GameConfig.rows - 1; row++) {
      for (int column = 1; column < GameConfig.columns - 1; column++) {
        var cell = cellAt(row, column);

        if (cell is RockCell) {
          totalRocks++;
        }

        if (cell is RockCell && cell.isDead()) {
          board[row][column].pop();
        }
      }
    }

    scoreboard.updateRocks(totalRocks);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Calculate costs
    for (int row = 1; row < GameConfig.rows - 1; row++) {
      for (int column = 1; column < GameConfig.columns - 1; column++) {
        var cell = cellAtFirst(row, column) as EmptyCell;
        cell.resetCosts();
      }
    }

    int playerRow = player.row;
    int playerColumn = player.column;

    int appleRow = apple.row;
    int appleColumn = apple.column;

    var startCell = board[playerRow][playerColumn].first() as EmptyCell;
    var endCell = board[appleRow][appleColumn].first() as EmptyCell;

    var openedList = PriorityQueue<EmptyCell>();
    var closedList = PriorityQueue<EmptyCell>();

    openedList.add(startCell);

    while (true) {
      if (openedList.isEmpty) {
        var x = 10;
        break;
      }

      var currentCell = openedList.removeFirst();
      closedList.add(currentCell);

      if (currentCell == endCell) {
        var x = 10;
        break;
      }

      var up = cellAt(currentCell.row - 1, currentCell.column);
      var down = cellAt(currentCell.row + 1, currentCell.column);
      var left = cellAt(currentCell.row, currentCell.column - 1);
      var right = cellAt(currentCell.row, currentCell.column + 1);

      List<EmptyCell> cellsAroundCurrentCell = <EmptyCell>[];
      for (var topCell in [up, down, left, right]) {
        if (topCell is EmptyCell) {
          cellsAroundCurrentCell.add(topCell);
        } else if (topCell is AppleCell) {
          cellsAroundCurrentCell
              .add(cellAtFirst(topCell.row, topCell.column) as EmptyCell);
        }
      }

      for (var cell in cellsAroundCurrentCell) {
        if (!closedList.contains(cell)) {
          if (!openedList.contains(cell)) {
            cell.parentCell = currentCell;

            cell.G = cell.parentCell!.G + 1;
            cell.H =
                (appleRow - cell.row).abs() + (appleColumn - cell.column).abs();

            openedList.add(cell);
          } else if (openedList.contains(cell) && currentCell.G + 1 < cell.G) {
            cell.parentCell = currentCell;

            cell.G = cell.parentCell!.G + 1;
            cell.H =
                (appleRow - cell.row).abs() + (appleColumn - cell.column).abs();
          }
        }
      }
    }

    path.clear();

    // Make path
    if (endCell.parentCell != null) {
      EmptyCell? pathCell = endCell;
      while (pathCell != startCell) {
        path.add(pathCell!);
        pathCell = pathCell.parentCell;
      }
      path.add(startCell);
      path = path.reversed.toList();
    }

    if (player.isParked()) {
      return;
    }

    // Trackers
    //useSimpleAppleTracker();
    followPath();

    // Collisions avoider
    useCollisionsAvoider();

    // Update player
    updatePlayer(dt);

    // Update apple
    updateApple(dt);

    // Update rocks
    updateRocks();
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

    var cellSize = GameConfig.cellSize;

    for (int row = 0; row < GameConfig.rows + 1; row++) {
      canvas.drawLine(Offset(0, row * cellSize),
          Offset((GameConfig.columns) * cellSize, row * cellSize), paint);
    }

    for (int column = 0; column < GameConfig.columns + 1; column++) {
      canvas.drawLine(Offset(column * cellSize, 0),
          Offset(column * cellSize, (GameConfig.rows) * cellSize), paint);
    }

    // Render path
    Paint pathPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.00;

    for (var index = 1; index < path.length - 1; index++) {
      var cellA = path[index];
      var cellB = path[index + 1];

      var xA = (cellA.column + 0.50) * cellSize;
      var yA = (cellA.row + 0.50) * cellSize;

      var xB = (cellB.column + 0.50) * cellSize;
      var yB = (cellB.row + 0.50) * cellSize;

      canvas.drawLine(
        Offset(xA, yA),
        Offset(xB, yB),
        pathPaint,
      );

      canvas.drawCircle(Offset(xA, yA), cellSize/12, pathPaint);
      canvas.drawCircle(Offset(xB, yB), cellSize/12, pathPaint);
    }

    scoreboard.render(canvas);
  }
}
