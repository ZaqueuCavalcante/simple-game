import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import 'cell.dart';

class CheckCell extends Cell with Tappable {
  bool check = false;

  GameConfig configs;

  CheckCell(int row, int column, this.configs) : super(row, column, Colors.orange);

  @override
  bool onTapUp(TapUpInfo info) {
    check = !check;
    configs.renderCellsCosts = !configs.renderCellsCosts;
    return true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    var text = check ? '[X]' : '[  ]';

    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Awesome Font',
      ),
    );

    textPaint.render(canvas, text, Vector2(0.20 * sideSize, 0.20 * sideSize));

    textPaint.render(canvas, 'Render cells costs', Vector2(1.20 * sideSize, 0.20 * sideSize));
  }
}
