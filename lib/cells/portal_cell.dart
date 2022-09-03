import 'package:flame/components.dart' as draggable;
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import '../game_config.dart';
import 'cell.dart';

class PortalCell extends Cell with Pushable, draggable.Draggable {
  PortalCell(int row, int column) : super(row, column, Colors.black);

  @override
  void render(Canvas canvas) {
    Paint borderPaint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.00;

    canvas.drawLine(const Offset(0.00, 0.00), Offset(cellSize, 0.00), borderPaint);
    canvas.drawLine(Offset(cellSize, 0.00), Offset(cellSize, cellSize), borderPaint);
    canvas.drawLine(Offset(cellSize, cellSize), Offset(0.00, cellSize), borderPaint);
    canvas.drawLine(Offset(0.00, cellSize), const Offset(0.00, 0.00), borderPaint);
  }

  Vector2? dragDeltaPosition;

  @override
  bool onDragStart(DragStartInfo info) {
    dragDeltaPosition = info.eventPosition.game - position;
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    final dragDeltaPosition = this.dragDeltaPosition;
    if (dragDeltaPosition == null) {
      return false;
    }

    position.setFrom(info.eventPosition.game - dragDeltaPosition);

    var tempX = position.x + cellSize/2;
    var tempY = position.y + cellSize/2;

    row = tempY ~/ cellSize;
    column = tempX ~/ cellSize;

    if (row < 0) { row = 0; }
    else if (row > GameConfig.rows - 1) { row = GameConfig.rows - 1; }

    if (column < 0) { column = 0; }
    else if (column > GameConfig.columns - 1) { column = GameConfig.columns - 1; }

    position.x = column * cellSize;
    position.y = row * cellSize;

    return false;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    dragDeltaPosition = null;
    return false;
  }

  @override
  bool onDragCancel() {
    dragDeltaPosition = null;
    return false;
  }
}
