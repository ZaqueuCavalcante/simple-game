import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/game_config.dart';
import 'simple_game.dart';

class Scoreboard extends PositionComponent with HasGameRef<SimpleGame> {
  int score = 0;
  int rocks = 0;

  late Timer interval;
  int elapsedSecs = 0;

  Scoreboard() {
    interval = Timer(
      1,
      onTick: () => elapsedSecs += 1,
      repeat: true,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    TextPaint textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
        fontFamily: 'Awesome Font',
      ),
    );

    textPaint.render(canvas, 'Score: $score', Vector2(50, 550));
    textPaint.render(canvas, 'Rocks: $rocks / ${GameConfig.maxRocks}', Vector2(50, 600));
    textPaint.render(canvas, 'Time: $elapsedSecs', Vector2(50, 650));
  }

  @override
  void update(double dt) {
    interval.update(dt);
  }

  void updateScore() {
    score++;
  }

  void updateRocks(int value) {
    rocks = value;
  }
}
