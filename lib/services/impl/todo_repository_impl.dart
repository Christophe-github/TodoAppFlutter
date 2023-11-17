import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/services/todo_repository.dart';
import 'package:todo_app/data/models/todo_query.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/todo.dart';

class TodoRepositoryImpl implements TodoRepository {
  static const databaseName = 'todo_database.db';
  static const todosTableName = 'todos';
  static const idColumn = 'id';
  static const titleColumn = 'title';
  static const descriptionColumn = 'description';
  static const priorityColumn = 'priority';
  static const completedColumn = 'completed';
  static const deadlineColumn = 'deadline';

  final List<TodoListener> _listeners = [];

  static final TodoRepositoryImpl instance =
      TodoRepositoryImpl._privateConstructor();

  TodoRepositoryImpl._privateConstructor();

  @override
  void addTodosListener(TodoListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  @override
  void removeTodosListener(TodoListener listener) {
    _listeners.remove(listener);
  }

  @override
  void notifyListeners() {
    for (final listener in _listeners) {
      listener.onTodosUpdate();
    }
  }

  Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $todosTableName($idColumn TEXT PRIMARY KEY, $titleColumn TEXT, $descriptionColumn TEXT, $completedColumn INTEGER, $priorityColumn INTEGER, $deadlineColumn INTEGER)',
        );
      },
      version: 1,
    );
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final database = await getDatabase();

    await database.insert(
      todosTableName,
      todo.copy(id: const Uuid().v4()).toDatabaseMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    notifyListeners();
  }

  @override
  Future<List<Todo>> getTodos(TodoQuery query) async {
    final database = await getDatabase();

    var rawQuery = "SELECT * FROM $todosTableName ";

    if (query.filter.priority != null || query.filter.completed != null) {
      rawQuery += " WHERE ";
    }
    if (query.filter.priority != null) rawQuery += " $priorityColumn = ? ";
    if (query.filter.priority != null && query.filter.completed != null) {
      rawQuery += " AND ";
    }
    if (query.filter.completed != null) rawQuery += " $completedColumn = ? ";

    var whereArgs = [];
    if (query.filter.priority != null) whereArgs.add(query.filter.priority);

    if (query.filter.completed == true) {
      whereArgs.add(1);
    } else if (query.filter.completed == false) {
      whereArgs.add(0);
    }

    rawQuery += " ORDER BY ";
    if (query.sortBy == TodoSortBy.defaultValue) rawQuery += " $idColumn ";
    if (query.sortBy == TodoSortBy.deadline) rawQuery += " $deadlineColumn ";
    if (query.sortBy == TodoSortBy.priority) rawQuery += " $priorityColumn ";

    // final List<Map<String, dynamic>> maps = await database.query(todosTableName,
    //     where: where, whereArgs: whereArgs, orderBy: orderBy);

    final List<Map<String, dynamic>> maps =
        await database.rawQuery(rawQuery, whereArgs);

    return List.generate(maps.length, (i) {
      return Todo.fromDatabaseEntry(maps[i]);
    });
  }

  @override
  Future<Todo> getTodo(String id) async {
    final database = await getDatabase();

    var result = await database.query(todosTableName,
        where: '$idColumn = ?', whereArgs: [id], limit: 1);
    return Todo.fromDatabaseEntry(result[0]);
  }

  @override
  Future<void> removeTodo(Todo todo) async {
    final database = await getDatabase();

    await database
        .delete(todosTableName, where: '$idColumn = ?', whereArgs: [todo.id]);
    notifyListeners();
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final database = await getDatabase();

    await database.update(todosTableName, todo.toDatabaseMap(),
        where: '$idColumn = ?', whereArgs: [todo.id]);
    notifyListeners();
  }
}
