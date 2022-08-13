class GameConfig {
  // Never change after start game
  static const int rows = 15;
  static const int columns = 10;
  static const double cellSize = 40.00;
  static const int maxRocks = (rows - 2) * (columns - 2) - 1;
  static const bool addInitialObstacles = true;

  static const int updateDelayInMilliseconds = 1000;

  static const bool followTheSpiderSenseWhenPathIsNotFound = true;
  static const bool pushObstacleOnEatApple = false;



  // Settings for render things or not
  static const bool renderCellsCosts = false;
  static const bool renderVisitedCellsInPathfinding = false;
  static const bool showBordersIndex = true;

  // Apple cell settings
  static const bool appleIsDeadly = true;
  static const double appleLifeDiscount = 0.05;

  // Rock cell settings
  static const bool rockIsDeadly = true;
  static const int rockMaxCollisions = 9;
}
