import '../data/models/todo_query.dart';

abstract class SharedPrefsRepository {
  Future<void> saveQuery(TodoQuery query);

  Future<TodoQuery> getQuery();
}
