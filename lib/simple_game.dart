import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:snake_game/game_config.dart';
import 'cells/apple_cell.dart';
import 'cells/cell.dart';
import 'cells/cell_stack.dart';
import 'cells/drag_cell.dart';
import 'cells/empty_cell.dart';
import 'cells/player_cell.dart';
import 'cells/portal_cell.dart';
import 'cells/rock_cell.dart';
import 'cells_path.dart';
import 'grids/cell_index.dart';
import 'grids/grid.dart';
import 'scoreboard.dart';

class SimpleGame extends FlameGame with HasTappables, HasDraggables {
  GameConfig configs = GameConfig();

  late List<List<CellStack>> board;

  PlayerCell player = PlayerCell(3, 3);
  late AppleCell apple;
  late PortalCell startPortal;
  late PortalCell endPortal;

  late CellsPath path = CellsPath(configs);

  Scoreboard scoreboard = Scoreboard();

  static Grid grid = Grid();

  DragCell dragCell = DragCell(10, 5);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    loadEmptyCellsBoard();

    addCellOnTop(player);

    startPortal = PortalCell(GameConfig.rows - 1, GameConfig.columns - 1);
    endPortal = PortalCell(0, 0);

    // Quando n achar a comida, procurar portal e ir até ele

    addRandomApple();

    add(grid);

    add(path);

    add(scoreboard);

    add(dragCell);

    add(startPortal);
    add(endPortal);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (player.isParked()) {
      return;
    }

    resetEmptyCellsCosts();
    setEmptyCellsParents();
    path.make(startCell, endCell);

    followPath();

    useCollisionsAvoider();

    updatePlayer(dt);

    updateApple(dt);

    updateRocks();

    //sleep(Duration(milliseconds: configs.updateDelayInMilliseconds));
  }

  void resetEmptyCellsCosts() {
    for (int row = 0; row < GameConfig.rows; row++) {
      for (int column = 0; column < GameConfig.columns; column++) {
        var cell = cellAtBottom(row, column) as EmptyCell;
        cell.resetCostsAndParent();
      }
    }
  }

  EmptyCell get startCell =>
      cellAtBottom(player.row, player.column) as EmptyCell;

  EmptyCell get endCell => cellAtBottom(apple.row, apple.column) as EmptyCell;

  void setEmptyCellsParents() {
    var openedList = PriorityQueue<EmptyCell>();
    var closedList = <EmptyCell>[];
    openedList.add(startCell);

    while (true) {
      if (openedList.isEmpty) { break; }

      var currentCell = openedList.removeFirst();
      closedList.add(currentCell);

      if (currentCell == endCell) { break; }

      var cellsAround = <EmptyCell>[];
      for (var cell in cellsAroundThe(currentCell)) {
        if (cell is EmptyCell) {
          cellsAround.add(cell);
        }
        if (cell is AppleCell) {
          cellsAround.add(endCell);
        }
      }

      for (var cell in cellsAround) {
        if (!closedList.contains(cell)) {
          if (!openedList.contains(cell)) {
            cell.parentCell = currentCell;
            cell.calculateCosts(apple);
            openedList.add(cell);
          } else if (openedList.contains(cell) && currentCell.G + 1 < cell.G) {
            cell.parentCell = currentCell;
            cell.calculateCosts(apple);
          }
        }
      }
    }

    startCell.G = 1; // Only for render as visited cell
  }

  void loadEmptyCellsBoard() {
    board = List.generate(GameConfig.rows, (row) =>
        List.generate(GameConfig.columns, (column) =>
            CellStack(EmptyCell(row, column, configs))
      ),
    );

    for (int row = 0; row < GameConfig.rows; row++) {
      for (int column = 0; column < GameConfig.columns; column++) {
        add(board[row][column]);
      }
    }
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

  // TODO: Calculate for always be find by player
  void addRandomApple() {
    List<CellIndex> emptyCells = <CellIndex>[];
    for (int row = 0; row < GameConfig.rows; row++) {
      for (int column = 0; column < GameConfig.columns; column++) {
        if (cellAtTop(row, column) is EmptyCell) {
          emptyCells.add(CellIndex(row, column));
        }
      }
    }
    if (emptyCells.isNotEmpty) {
      var randomIndex = Random().nextInt(emptyCells.length);
      var randomCell = emptyCells[randomIndex];

      addAppleOnTop(randomCell.row, randomCell.column);
    } else {
      player.park();
    }
  }

  Cell cellAtUpOf(Cell cell) {
    bool upIsOut = cell.row == 0;
    return upIsOut ? RockCell(-1, -1) : cellAtTop(cell.row - 1, cell.column);
  }

  Cell cellAtLeftOf(Cell cell) {
    bool leftIsOut = cell.column == 0;
    return leftIsOut ? RockCell(-1, -1) : cellAtTop(cell.row, cell.column - 1);
  }

  Cell cellAtRightOf(Cell cell) {
    bool rightIsOut = cell.column == GameConfig.columns - 1;
    return rightIsOut ? RockCell(-1, -1) : cellAtTop(cell.row, cell.column + 1);
  }

  Cell cellAtDownOf(Cell cell) {
    bool downIsOut = cell.row == GameConfig.rows - 1;
    return downIsOut ? RockCell(-1, -1) : cellAtTop(cell.row + 1, cell.column);
  }

  List<Cell> cellsAroundThe(Cell cell) {
    var up = cellAtUpOf(cell);
    var left = cellAtLeftOf(cell);
    var right = cellAtRightOf(cell);
    var down = cellAtDownOf(cell);
    return [up, left, right, down];
  }

  void useCollisionsAvoider() {
    var up = cellAtUpOf(player);
    var left = cellAtLeftOf(player);
    var right = cellAtRightOf(player);
    var down = cellAtDownOf(player);

    if (player.isGoingToUp() && up is Unpushable) {
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
    } else if (player.isGoingToDown() && down is Unpushable) {
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
    } else if (player.isGoingToLeft() && left is Unpushable) {
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
    } else if (player.isGoingToRight() && right is Unpushable) {
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

  void updatePlayer(double dt) {
    int oldRow = player.row;
    int oldColumn = player.column;

    player.update(dt);

    var newRow = player.row;
    var newColumn = player.column;
    var isStartPortal = newRow == startPortal.row && newColumn == startPortal.column;
    var isEndPortal = newRow == endPortal.row && newColumn == endPortal.column;

    if (isStartPortal) {
      player.row = endPortal.row;
      player.column = endPortal.column;
      board[endPortal.row][endPortal.column].push(board[oldRow][oldColumn].pop());
      return;
    } else if (isEndPortal) {
      player.row = startPortal.row;
      player.column = startPortal.column;
      board[startPortal.row][startPortal.column].push(board[oldRow][oldColumn].pop());
      return;
    }


    var newCell = cellAtTop(newRow, newColumn);

    if (newCell is EmptyCell) {
      if (isStartPortal) {
        player.row = endPortal.row;
        player.column = endPortal.column;
        board[endPortal.row][endPortal.column].push(board[oldRow][oldColumn].pop());
        return;
      }
      if (isEndPortal) {
        player.row = startPortal.row;
        player.column = startPortal.column;
        board[startPortal.row][startPortal.column].push(board[oldRow][oldColumn].pop());
        return;
      }

      board[newRow][newColumn].push(board[oldRow][oldColumn].pop());
    }
    else if (newCell is AppleCell) {
      board[newRow][newColumn].pop();

      if (GameConfig.pushObstacleOnEatApple) {
        addCellOnTop(RockCell(newRow, newColumn));
      }

      if (isStartPortal) {
        player.row = endPortal.row;
        player.column = endPortal.column;
        board[endPortal.row][endPortal.column].push(board[oldRow][oldColumn].pop());
      }
      if (isEndPortal) {
        player.row = startPortal.row;
        player.column = startPortal.column;
        board[startPortal.row][startPortal.column].push(board[oldRow][oldColumn].pop());
      }
      if (!isStartPortal && !isEndPortal) {
        board[newRow][newColumn].push(board[oldRow][oldColumn].pop());
      }

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
    if (path.isEmpty()) {
      return;
    }

    player.goToNeighbor(path.cells[1]);
  }
}
