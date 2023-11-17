import '../data/models/todo.dart';
import '../data/models/todo_query.dart';

abstract class TodoListener {
  void onTodosUpdate();
}

abstract class TodoRepository {
  final List<TodoListener> _listeners = [];

  void addTodosListener(TodoListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeTodosListener(TodoListener listener) {
    _listeners.remove(listener);
  }

  void notifyListeners() {
    for (final listener in _listeners) {
      listener.onTodosUpdate();
    }
  }

  Future<List<Todo>> getTodos(TodoQuery query);

  Future<Todo> getTodo(String id);

  Future<void> addTodo(Todo todo);

  Future<void> updateTodo(Todo todo);

  Future<void> removeTodo(Todo todo);
}
