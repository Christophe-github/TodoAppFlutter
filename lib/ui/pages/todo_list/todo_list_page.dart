import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/ui/pages/todo_list/todo_list_filter.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../../common/todo_app_bar.dart';
import '../../theme/theme.dart';
import 'todo_list_item.dart';
import 'todo_list_viewmodel.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    setStatusAndNavbarTheme(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: TodoAppBar(title: "Todo list flutter", actions: [
          Consumer<TodoListViewModel>(builder: (context, viewmodel, child) {
            return Column(
              children: [
                IconButton(
                    icon: viewmodel.isFilterActive
                        ? const Icon(Icons.filter_alt)
                        : const Icon(Icons.filter_alt_outlined),
                    color: Theme.of(context).colorScheme.primary,
                    tooltip: "Sort and filter",
                    onPressed: () {
                      _scaffoldKey.currentState?.showBottomSheet(
                          // backgroundColor: Theme.of(context).colorScheme.primary,
                          (context) {
                        return Consumer<TodoListViewModel>(
                            builder: (context, viewmodel, child) {
                          return TodoListBottomSheetFilter(
                              query: viewmodel.query,
                              onQueryChanged: (q) {
                                viewmodel.setQuery(q);
                              });
                        });
                      });
                    }),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  height: 3,
                  width: viewmodel.isFilterActive ? 26 : 0,
                  color: Theme.of(context).colorScheme.primary,
                  transform: Matrix4.translation(vector.Vector3(0, -8, 0)),
                )
              ],
            );
          }),

          //This is just to move the real icon button to the left because of the DEBUG banner
          const SizedBox(
            width: 30,
          )
        ]),
        floatingActionButton: FloatingActionButton(
          tooltip: "Create new todo",
          onPressed: () {
            context.push("/todo_create");
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder(),
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        body: Consumer<TodoListViewModel>(builder: (context, viewmodel, child) {
          // if (!viewmodel.isFilterActive && viewmodel.todos.isEmpty) {
          //   return Center(child: Padding(
          //     padding: const EdgeInsets.all(32.0),
          //     child: Text("You don't have any Todo yet",
          //     textAlign: TextAlign.center,
          //     style: Theme.of(context).textTheme.headlineMedium,),
          //   ),);
          // }

          return ListView.separated(
              itemCount: viewmodel.todos.length,
              separatorBuilder: (context, index) => const Divider(height: 2),
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(viewmodel.todos[index].id),
                  background: const DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.red, Colors.deepOrange])),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.delete_outlined,
                          color: Colors.white,
                        ),
                        Expanded(
                            child: SizedBox(
                          width: 20,
                        )),
                        Icon(
                          Icons.delete_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  onDismissed: (direction) {
                    viewmodel.removeTodo(viewmodel.todos[index]);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Todo removed")));
                  },
                  child: TodoListItem(
                    todo: viewmodel.todos[index],
                    onTap: (todo) => context.push('/todo/${todo.id}'),
                    onLongPress: (todo) {
                      viewmodel
                          .updateTodo(todo.copy(completed: !todo.completed));
                    },
                  ),
                );
              });
        }));
  }
}
