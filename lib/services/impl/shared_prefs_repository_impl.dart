import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/todo_query.dart';
import '../shared_prefs_repository.dart';

class SharedPrefsRepositoryImpl implements SharedPrefsRepository {
  SharedPrefsRepositoryImpl._privateConstructor();

  static final SharedPrefsRepositoryImpl instance =
      SharedPrefsRepositoryImpl._privateConstructor();

  @override
  Future<void> saveQuery(TodoQuery query) async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setInt("sortBy", query.sortBy.index).then((success) {
      if (!success) {
        throw Exception("Could not add sortBy preference");
      }
    });

    if (query.filter.completed == null) {
      prefs.remove("filterCompleted");
    } else {
      prefs.setBool("filterCompleted", query.filter.completed ?? false);
    }
    if (query.filter.priority == null) {
      prefs.remove("filterPriority");
    } else {
      prefs.setInt("filterPriority", query.filter.priority ?? 1);
    }
  }

  @override
  Future<TodoQuery> getQuery() async {
    var prefs = await SharedPreferences.getInstance();

    var sortBy = TodoSortBy.values[prefs.getInt("sortBy") ?? 0];

    var filterCompleted = prefs.getBool("filterCompleted");
    var filterPriority = prefs.getInt("filterPriority");

    return TodoQuery(sortBy, TodoFilter(filterPriority, filterCompleted));
  }
}
