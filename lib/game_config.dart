class GameConfig {
  static const int rows = 15;
  static const int columns = 10;
  static const double cellSize = 40.00;

  static const bool useSimpleAppleTracker = true;
  static const bool pushObstacleOnEatApple = false;

  static const bool showBordersIndex = true;
  static const bool addInitialObstacles = true;

  static const int rockMaxCollisions = 9;
  static const int maxRocks = (rows - 2) * (columns - 2) - 1;
}
