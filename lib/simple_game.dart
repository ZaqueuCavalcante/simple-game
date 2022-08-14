import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/game_config.dart';
import 'cells/apple_cell.dart';
import 'cells/cell.dart';
import 'cells/cell_stack.dart';
import 'cells/check_cell.dart';
import 'cells/empty_cell.dart';
import 'cells/player_cell.dart';
import 'cells/rock_cell.dart';
import 'grids/cell_index.dart';
import 'grids/lines.dart';
import 'scoreboard.dart';

class SimpleGame extends FlameGame with HasTappables {
  GameConfig configs = GameConfig();

  late List<List<CellStack>> board;

  PlayerCell player = PlayerCell(1, 1);
  late AppleCell apple;

  List<EmptyCell> path = <EmptyCell>[];

  Scoreboard scoreboard = Scoreboard();

  static Lines grid = Lines();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    board = List.generate(GameConfig.rows, (row) {
      return List.generate(GameConfig.columns, (column) {
        return CellStack(EmptyCell(row, column, configs));
      });
    });

    for (int row = 0; row < GameConfig.rows; row++) {
      for (int column = 0; column < GameConfig.columns; column++) {
        add(board[row][column]);
      }
    }

    addCellOnTop(player);
    addRandomApple();

    add(CheckCell(GameConfig.rows + 1, 0, configs));

    add(grid);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Calculate costs
    for (int row = 0; row < GameConfig.rows; row++) {
      for (int column = 0; column < GameConfig.columns; column++) {
        var cell = cellAtBottom(row, column) as EmptyCell;
        cell.resetCostsAndParent();
      }
    }

    int playerRow = player.row;
    int playerColumn = player.column;

    int appleRow = apple.row;
    int appleColumn = apple.column;

    var startCell = cellAtBottom(playerRow, playerColumn) as EmptyCell;
    var endCell = cellAtBottom(appleRow, appleColumn) as EmptyCell;

    var openedList = PriorityQueue<EmptyCell>();
    var closedList = <EmptyCell>[];

    openedList.add(startCell);

    while (true) {
      if (openedList.isEmpty) {
        break;
      }

      var currentCell = openedList.removeFirst();
      closedList.add(currentCell);

      if (currentCell == endCell) {
        break;
      }

      var row = currentCell.row;
      var column = currentCell.column;

      bool upIsOut = row == 0;
      bool leftIsOut = column == 0;
      bool rightIsOut = column == GameConfig.columns - 1;
      bool downIsOut = row == GameConfig.rows - 1;

      var up = upIsOut ? RockCell(-1, -1) : cellAtTop(row - 1, column);
      var left = leftIsOut ? RockCell(-1, -1) : cellAtTop(row, column - 1);
      var right = rightIsOut ? RockCell(-1, -1) : cellAtTop(row, column + 1);
      var down = downIsOut ? RockCell(-1, -1) : cellAtTop(row + 1, column);

      List<EmptyCell> cellsAroundCurrentCell = <EmptyCell>[];
      for (var topCell in [up, down, left, right]) {
        if (topCell is EmptyCell) {
          cellsAroundCurrentCell.add(topCell);
        } else if (topCell is AppleCell) {
          cellsAroundCurrentCell.add(endCell);
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

    startCell.G = 1;

    // Make path
    path.clear();

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

    followPath();

    useCollisionsAvoider();

    updatePlayer(dt);

    updateApple(dt);

    updateRocks();

    sleep(Duration(milliseconds: configs.updateDelayInMilliseconds));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    var cellSize = GameConfig.cellSize;

    // Render path
    Paint pathPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.00;

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

      canvas.drawCircle(Offset(xA, yA), cellSize / 15, pathPaint);
      canvas.drawCircle(Offset(xB, yB), cellSize / 15, pathPaint);
    }

    scoreboard.render(canvas);
  }

  void addCellOnTop(Cell cell) {
    board[cell.row][cell.column].push(cell);
  }

  Cell cellAtTop(int row, int column) {
    return board[row][column].top();
  }

  Cell cellAtBottom(int row, int column) {
    return board[row][column].bottom();
  }

  void addAppleOnTop(int row, int column) {
    apple = AppleCell(row, column);
    addCellOnTop(apple);
  }

  // Calculate for always be find by player
  void addRandomApple() {
    List<CellIndex> emptyCells = <CellIndex>[];
    for (int row = 0; row < GameConfig.rows; row++) {
      for (int column = 0; column < GameConfig.columns; column++) {
        if (cellAtTop(row, column) is EmptyCell) {
          emptyCells.add(CellIndex(row, column));
        }
      }
    }
    var randomIndex = Random().nextInt(emptyCells.length);
    var randomCell = emptyCells[randomIndex];

    addAppleOnTop(randomCell.row, randomCell.column);
  }

  void useCollisionsAvoider() {
    int row = player.row;
    int column = player.column;

    bool upIsOut = row == 0;
    bool leftIsOut = column == 0;
    bool rightIsOut = column == GameConfig.columns - 1;
    bool downIsOut = row == GameConfig.rows - 1;

    var up = upIsOut ? RockCell(-1, -1) : cellAtTop(row - 1, column);
    var left = leftIsOut ? RockCell(-1, -1) : cellAtTop(row, column - 1);
    var right = rightIsOut ? RockCell(-1, -1) : cellAtTop(row, column + 1);
    var down = downIsOut ? RockCell(-1, -1) : cellAtTop(row + 1, column);

    if (player.isGoingToUp()) {
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

    if (cellAtTop(newRow, newColumn) is EmptyCell) {
      board[newRow][newColumn].push(board[oldRow][oldColumn].pop());
    } else if (cellAtTop(newRow, newColumn) is AppleCell) {
      board[newRow][newColumn].pop();

      if (GameConfig.pushObstacleOnEatApple) {
        addCellOnTop(RockCell(newRow, newColumn));
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
    for (int row = 0; row < GameConfig.rows; row++) {
      for (int column = 0; column < GameConfig.columns; column++) {
        var cell = cellAtTop(row, column);

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

  void followPath() {
    if (path.isEmpty) {
      return;
    }

    int playerRow = player.row;
    int playerColumn = player.column;

    int nextRow = path[1].row;
    int nextColumn = path[1].column;

    if (nextRow == playerRow) {
      if (nextColumn > playerColumn) {
        player.goToRight();
      } else if (nextColumn < playerColumn) {
        player.goToLeft();
      }
    } else {
      if (nextRow > playerRow) {
        player.goToDown();
      } else if (nextRow < playerRow) {
        player.goToUp();
      }
    }
  }
}
