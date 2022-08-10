import 'package:flutter/material.dart';

import 'cell.dart';

class EmptyCell extends Cell with Pushable {
  EmptyCell(int row, int column) : super(row, column, Colors.grey);
}
