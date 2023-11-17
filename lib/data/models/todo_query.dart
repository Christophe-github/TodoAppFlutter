import 'package:flutter/foundation.dart';

enum TodoSortBy { defaultValue, priority, deadline }

@immutable
class TodoFilter {
  final int? priority;
  final bool? completed;

  const TodoFilter(this.priority, this.completed);
}

@immutable
class TodoQuery {
  final TodoSortBy sortBy;
  final TodoFilter filter;

  const TodoQuery(this.sortBy, this.filter);

  TodoQuery copy({
    TodoSortBy? sortBy,
    TodoFilter? filter,
  }) {
    return TodoQuery(
      sortBy ?? this.sortBy,
      filter ?? this.filter,
    );
  }

  static const TodoQuery defaultValue =
      TodoQuery(TodoSortBy.defaultValue, TodoFilter(null, null));

  @override
  String toString() {
    return "$sortBy $filter";
  }
}
