class GameConfig {
  // Never change after start game
  static const int rows = 20;
  static const int columns = 13;
  static const double cellSize = 30.00;
  static const int maxRocks = (rows - 2) * (columns - 2) - 1;
  static const bool addInitialObstacles = true;

  int updateDelayInMilliseconds = 5;

  static const bool followTheSpiderSenseWhenPathIsNotFound = true;
  static const bool pushObstacleOnEatApple = true;



  // Settings for render things or not
  bool renderCellsCosts = false;
  static const bool renderVisitedCellsInPathfinding = true;
  static const bool showBordersIndex = true;

  // Apple cell settings
  static const bool appleIsDeadly = false;
  static const double appleLifeDiscount = 0.05;

  // Rock cell settings
  static const bool rockIsDeadly = true;
  static const int rockMaxCollisions = 0;
}
