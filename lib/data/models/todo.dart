import 'package:flutter/material.dart';

@immutable
class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.priority,
    required this.deadline,
  });

  final String id;
  final String title;
  final String description;
  final bool completed;
  final int priority;
  final DateTime deadline;

  Todo copy(
      {String? id,
      String? title,
      String? description,
      bool? completed,
      int? priority,
      DateTime? deadline}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
    );
  }

  @override
  String toString() {
    return "$id $title ";
  }

  Map<String, dynamic> toDatabaseMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
      'priority': priority,
      'deadline': deadline.millisecondsSinceEpoch
    };
  }

  static Todo fromDatabaseEntry(Map<String, dynamic> entry) {
    return Todo(
      id: entry['id'],
      title: entry['title'],
      description: entry['description'],
      completed: entry['completed'] > 0 ? true : false,
      priority: entry['priority'],
      deadline: DateTime.fromMillisecondsSinceEpoch(entry['deadline']),
    );
  }
}
