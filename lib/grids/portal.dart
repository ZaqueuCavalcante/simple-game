import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/cells/portal_cell.dart';
import '../simple_game.dart';

class Portal extends PositionComponent with HasGameRef<SimpleGame>, Tappable {
  PortalCell start;
  PortalCell end;

  Portal(this.start, this.end);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    start.render(canvas);
    end.render(canvas);
  }
}
