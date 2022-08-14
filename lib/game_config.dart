class GameConfig {
  // Never change after start game
  static const int rows = 10;
  static const int columns = 8;
  static const double cellSize = 48.00;
  static const int maxRocks = rows * columns - 1;
  static const bool addInitialObstacles = true;

  int updateDelayInMilliseconds = 0;

  static const bool followTheSpiderSenseWhenPathIsNotFound = true;
  static const bool pushObstacleOnEatApple = true;



  // Settings for render things or not
  bool renderCellsCosts = false;
  bool renderPath = false;
  static const bool renderVisitedCellsInPathfinding = false;

  // Apple cell settings
  static const bool appleIsDeadly = false;
  static const double appleLifeDiscount = 0.05;

  // Rock cell settings
  static const bool rockIsDeadly = true;
  static const int rockMaxCollisions = 1;
}
