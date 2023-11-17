import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/ui/pages/todo_detail/todo_detail_page.dart';
import 'package:todo_app/ui/pages/todo_list/todo_list_page.dart';

import '../services/impl/shared_prefs_repository_impl.dart';
import '../services/impl/todo_repository_impl.dart';
import '../ui/pages/todo_detail/todo_detail_viewmodel.dart';
import '../ui/pages/todo_list/todo_list_viewmodel.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => ChangeNotifierProvider(
              create: (context) => TodoListViewModel(
                  TodoRepositoryImpl.instance, SharedPrefsRepositoryImpl.instance),
              child: const TodoListPage(),
            )),
    GoRoute(
        path: '/todo_create',
        builder: (context, state) => ChangeNotifierProvider(
            create: (context) =>
                TodoDetailViewModel(null, TodoRepositoryImpl.instance),
            child: const TodoDetailPage(todoId: null))),
    GoRoute(
      path: '/todo/:id',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChangeNotifierProvider(
              create: (context) => TodoDetailViewModel(
                  state.pathParameters['id'], TodoRepositoryImpl.instance),
              child: TodoDetailPage(todoId: state.pathParameters['id'])),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(1.5, 0.0), end: Offset.zero)
                      .animate(CurvedAnimation(
                          parent: animation, curve: Curves.easeOut)),
              child: child,
            );
          },
        );
      },
    ),
  ],
);
