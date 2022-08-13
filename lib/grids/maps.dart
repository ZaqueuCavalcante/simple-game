import 'dart:math';

import '../game_config.dart';

class Maps {
  Maps();

  List<List<bool>> get randomMap {
    return List.generate(GameConfig.rows - 2, (row) {
      return List.generate(
          GameConfig.columns - 2, (column) => Random().nextBool());
    });
  }

  List<List<bool>> get firstMap {
    var map = List.generate(GameConfig.rows - 2, (row) {
      return List.generate(GameConfig.columns - 2, (column) => false);
    });

    map[0][0] = true;
    map[1][1] = true;
    map[2][2] = true;
    map[3][3] = true;

    return map;
  }
}
