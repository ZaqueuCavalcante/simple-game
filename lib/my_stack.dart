import "dart:collection" show Queue;

class MyStack<T> {
  final Queue<T> _underlyingQueue;

  MyStack() : _underlyingQueue = Queue<T>();

  int get length => _underlyingQueue.length;
  bool get isEmpty => _underlyingQueue.isEmpty;
  bool get isNotEmpty => _underlyingQueue.isNotEmpty;

  void clear() => _underlyingQueue.clear();

  T peek() {
    if (isEmpty) {
      throw StateError("Cannot peek() on empty stack.");
    }
    return _underlyingQueue.last;
  }

  T pop() {
    if (isEmpty) {
      throw StateError("Cannot pop() on empty stack.");
    }
    return _underlyingQueue.removeLast();
  }

  void push(final T element) => _underlyingQueue.addLast(element);
}
