import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'cell.dart';
import 'styles.dart';

class DragCell extends Cell with Draggable {
  Vector2? dragDeltaPosition;

  DragCell(int row, int column) : super(row, column, Styles.orange);

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
