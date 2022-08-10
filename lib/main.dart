import 'dart:io';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'grids/grid.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(
    GameWidget(
      game: SnakeGame(),
    ),
  );
}

class SnakeGame extends FlameGame with HasTappables {

  Grid grid = Grid();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(grid);
  }

  @override
  void update(double dt) {
    super.update(dt);

    sleep(const Duration(milliseconds: 100));
  }
}
