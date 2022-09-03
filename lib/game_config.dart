class GameConfig {
  // Never change after start game
  static const int rows = 10;
  static const int columns = 7;
  static const double cellSize = 50.00;
  static const int maxRocks = rows * columns - 1;
  static const bool addInitialObstacles = true;

  int updateDelayInMilliseconds = 100;

  static const bool followTheSpiderSenseWhenPathIsNotFound = true;
  static const bool pushObstacleOnEatApple = true;



  // Settings for render things or not
  bool renderCellsCosts = false;
  bool renderPath = true;
  static const bool renderVisitedCellsInPathfinding = true;

  // Apple cell settings
  static const bool appleIsDeadly = false;
  static const double appleLifeDiscount = 0.05;

  // Rock cell settings
  static const bool rockIsDeadly = false;
  static const int rockMaxCollisions = 1;
}
