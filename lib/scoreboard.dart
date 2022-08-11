import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class Scoreboard extends PositionComponent with HasGameRef<SnakeGame> {
  int score = 0;

  Scoreboard();

  void updateScore() {
    score++;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 50.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Awesome Font',
      ),
    );

    textPaint.render(canvas, 'Score: $score', Vector2(50, 600));
  }
}
