import "dart:collection" show Queue;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:snake_game/cells/empty_cell.dart';
import 'package:snake_game/cells/rock_cell.dart';
import '../game_config.dart';
import '../simple_game.dart';
import 'cell.dart';
import 'player_cell.dart';

class CellStack extends PositionComponent
    with HasGameRef<SimpleGame>, Tappable {
  final Queue<Cell> _queue;

  static double cellSize = GameConfig.cellSize;

  CellStack(Cell cell) : _queue = Queue<Cell>() {
    position = Vector2(cell.column * cellSize, cell.row * cellSize);
    size = Vector2(cellSize, cellSize);
    _queue.addLast(cell);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    var topCell = top();

    if (topCell is EmptyCell) {
      push(RockCell(topCell.row, topCell.column));
      return true;
    }

    if (topCell is RockCell) {
      topCell.saveCollision();
      if (topCell.isDead()) {
        pop();
      }
      return true;
    }

    if (topCell is PlayerCell) {
      topCell.isParked() ? topCell.goToRandomly() : topCell.park();
      return true;
    }

    return true;
  }

  @override
  void render(Canvas canvas) {
    for (Cell cell in _queue) {
      cell.render(canvas);
    }
  }

  void push(final Cell cell) => _queue.addLast(cell);

  Cell top() => _queue.last;

  Cell pop() => _queue.removeLast();

  Cell bottom() => _queue.first;
}
