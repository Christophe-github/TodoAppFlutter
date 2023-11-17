// import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:todo_app/data/models/todo_query.dart';

import '../../../services/impl/shared_prefs_repository_impl.dart';
import '../../../services/todo_repository.dart';
import '../../../data/models/todo.dart';

class TodoListViewModel extends ChangeNotifier implements TodoListener {
  final TodoRepository repo;
  final SharedPrefsRepositoryImpl prefsRepo;

  List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  // todos could be done as a Stream implementation,
  // and in the UI we would use StreamBuilder
  // final _controller = StreamController<List<Todo>>();
  // late Stream<List<Todo>> todosStream;

  TodoQuery query = TodoQuery.defaultValue;
  bool isFilterActive = false;

  TodoListViewModel(this.repo, this.prefsRepo) {
    // todosStream = (() {
    //   return _controller.stream;
    // })();
    // _controller.add([]);

    repo.addTodosListener(this);

    prefsRepo.getQuery().then((query) {
      setQuery(query, save: false);
    }).catchError((error, stackTrace) {
      print("$error");
      fetchTodos();
    });
  }

  @override
  void dispose() {
    repo.removeTodosListener(this);
    super.dispose();
  }

  @override
  void onTodosUpdate() {
    fetchTodos();
    // _controller.add(todos);
  }

  void fetchTodos() async {
    _todos = await repo.getTodos(query);
    notifyListeners();
    // _controller.add(_todos);
  }

  void addTodo(Todo todo) async => repo.addTodo(todo);

  void updateTodo(Todo todo) async => repo.updateTodo(todo);

  void removeTodo(Todo todo) async => repo.removeTodo(todo);

  void setQuery(TodoQuery query, {bool save = true}) {
    this.query = query;
    if (query.filter.priority != null || query.filter.completed != null) {
      isFilterActive = true;
    } else {
      isFilterActive = false;
    }
    if (save) {
      prefsRepo.saveQuery(query);
    }
    fetchTodos();
  }
}
