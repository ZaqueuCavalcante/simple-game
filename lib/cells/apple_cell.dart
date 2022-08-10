import 'package:flutter/material.dart';

import 'cell.dart';

class AppleCell extends Cell with Pushable {
  AppleCell(int row, int column) : super(row, column, Colors.red);
}
