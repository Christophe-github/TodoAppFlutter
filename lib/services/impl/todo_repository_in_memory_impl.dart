import '../../data/models/todo.dart';
import '../../data/models/todo_query.dart';
import '../todo_repository.dart';


class TodoRepositoryInMemoryImpl implements TodoRepository {
  TodoRepositoryInMemoryImpl._privateConstructor();

  static final TodoRepositoryInMemoryImpl instance =
      TodoRepositoryInMemoryImpl._privateConstructor();

  final List<Todo> todos = [
    Todo(
        id: "0",
        title: "Do laundry",
        description: "For jeans and sweat shirts",
        completed: false,
        priority: 3,
        deadline: DateTime.now().add(const Duration(hours: 6))),
    Todo(
        id: "1",
        title: "Shopping",
        description: "Need new shoes",
        completed: false,
        priority: 2,
        deadline: DateTime.now().add(const Duration(hours: 6))),
    Todo(
        id: "2",
        title: "Buy groceries",
        description: "Pasta, vegetables, meat and fish",
        completed: true,
        priority: 1,
        deadline: DateTime.now().add(const Duration(hours: 6))),
    Todo(
        id: "3",
        title: "Exercise",
        description: "Go for a 30min walk",
        completed: false,
        priority: 4,
        deadline: DateTime.now().add(const Duration(hours: 6)))
  ];

  final List<TodoListener> listeners = [];

  @override
  void addTodosListener(TodoListener listener) {
    if (!listeners.contains(listener)) {
      listeners.add(listener);
    }
  }

  @override
  void removeTodosListener(TodoListener listener) {
    listeners.remove(listener);
  }

  @override
  void notifyListeners() {
    for (final listener in listeners) {
      listener.onTodosUpdate();
    }
  }

  @override
  Future<List<Todo>> getTodos(TodoQuery query) {
    return Future<List<Todo>>.microtask(() {
      var result = todos;
      if (query.filter.priority != null) {
        result = result
            .where((element) => element.priority == query.filter.priority)
            .toList();
      }
      if (query.filter.completed != null) {
        result = result
            .where((element) => element.completed == query.filter.completed)
            .toList();
      }
      if (query.sortBy == TodoSortBy.priority) {
        result.sort((a, b) => a.priority - b.priority);
      } else if (query.sortBy == TodoSortBy.deadline) {
        result.sort((a, b) => a.deadline.compareTo(b.deadline));
      } else if (query.sortBy == TodoSortBy.defaultValue) {
        result.sort((a, b) => a.id.compareTo(b.id));
      }
      return result;
    });
  }

  @override
  Future<Todo> getTodo(String id) {
    return Future<Todo>.microtask(
        () async => todos.firstWhere((element) => element.id == id));
  }

  @override
  Future<void> addTodo(Todo todo) {
    var toAdd = todo.copy(id: todos.length.toString());
    todos.add(toAdd);
    notifyListeners();
    return Future.value();
  }

  @override
  Future<void> updateTodo(Todo todo) {
    final index = todos.indexWhere((element) => element.id == todo.id);
    if (index != -1) {
      todos.removeAt(index);
      todos.insert(index, todo);
      notifyListeners();
    }
    return Future.value();
  }

  @override
  Future<void> removeTodo(Todo todo) {
    todos.removeWhere((element) => element.id == todo.id);
    notifyListeners();
    return Future.value();
  }
}
