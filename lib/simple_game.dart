import 'dart:io';

import 'package:flame/game.dart';
import 'package:snake_game/game_config.dart';
import 'grids/grid.dart';

class SimpleGame extends FlameGame with HasTappables {
  Grid grid = Grid();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(grid);
  }

  @override
  void update(double dt) {
    super.update(dt);

    sleep(const Duration(milliseconds: GameConfig.updateDelayInMilliseconds));
  }
}
