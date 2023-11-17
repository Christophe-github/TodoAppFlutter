import 'package:flutter/material.dart';
import 'package:todo_app/data/models/todo.dart';

import '../../../services/todo_repository.dart';

class TodoDetailViewModel extends ChangeNotifier {
  final TodoRepository repo;

  final String? todoId;
  bool get isAddMode => todoId == null;
  bool get isEditMode => !isAddMode;

  bool loading = false;

  String _title = "";
  String get title => _title;
  set title(String title) {
    _title = title;
    //For text inputs it is better not to call notifyListeners() because the content of the
    //Textfield would be replaced and the cursor would move at the beginning,
  }

  String _description = "";
  String get description => _description;
  set description(String description) {
    _description = description;
    //For text inputs it is better not to call notifyListeners() because the content of the
    //Textfield would be replaced and the cursor would move at the beginning,
  }

  bool _completed = false;
  bool get completed => _completed;
  set completed(bool completed) {
    _completed = completed;
    notifyListeners();
  }

  int _priority = 1;
  int get priority => _priority;
  set priority(int priority) {
    _priority = priority;
    notifyListeners();
  }

  DateTime _deadline = DateTime.now().add(const Duration(hours: 8));
  DateTime get deadline => _deadline;
  set deadline(DateTime deadline) {
    _deadline = deadline;
    notifyListeners();
  }

  TodoDetailViewModel(this.todoId, this.repo);

  Future<void> fetchTodo() async {
    if (isAddMode) return Future.value();

    loading = true;
    var todo = await repo.getTodo(todoId!);
    loading = false;

    _title = todo.title;
    _description = todo.description;
    _completed = todo.completed;
    _priority = todo.priority;
    _deadline = todo.deadline;
  }

  String? titleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }

  String? descriptionValidator(String? value) {
    return null;
  }

  addOrEditTodo() {
    var todo = Todo(
        id: todoId ?? "0",
        title: _title,
        description: _description,
        completed: _completed,
        priority: _priority,
        deadline: _deadline);
    if (isAddMode) {
      repo.addTodo(todo);
    } else {
      repo.updateTodo(todo);
    }
  }
}
