import "dart:collection" show Queue;

class MyStack<T> {
  final Queue<T> _queue;

  MyStack() : _queue = Queue<T>();

  int get length => _queue.length;
  bool get isEmpty => _queue.isEmpty;
  bool get isNotEmpty => _queue.isNotEmpty;

  void push(final T element) => _queue.addLast(element);

  T peek() {
    if (isEmpty) {
      throw StateError("Cannot peek() on empty stack.");
    }
    return _queue.last;
  }

  T pop() {
    if (isEmpty) {
      throw StateError("Cannot pop() on empty stack.");
    }
    return _queue.removeLast();
  }

  T first() {
    if (isEmpty) {
      throw StateError("Cannot first() on empty stack.");
    }
    return _queue.first;
  }
}
