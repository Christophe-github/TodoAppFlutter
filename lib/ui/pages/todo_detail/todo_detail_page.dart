import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../common/todo_app_bar.dart';
import 'todo_detail_priority_grid.dart';
import 'todo_detail_text_input.dart';
import 'todo_detail_viewmodel.dart';

class TodoDetailPage extends StatefulWidget {
  const TodoDetailPage({super.key, required this.todoId});

  final String? todoId;

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context, DateTime initial,
      ValueChanged<DateTime> onChanged) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 3650)));
    if (picked != null && picked != initial) {
      onChanged(picked);
    }
  }

  Future<void> _selectTime(BuildContext context, DateTime initial,
      ValueChanged<TimeOfDay> onChanged) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initial.hour, minute: initial.minute),
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: TodoAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary),
              onPressed: () => context.pop(),
            ),
            title: widget.todoId == null ? "Add todo" : "Edit todo"),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Provider.of<TodoDetailViewModel>(context, listen: false)
                  .addOrEditTodo();
              context.pop();
            }
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder(),
          child: Icon(
            Icons.check,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        body: FutureBuilder<void>(
            future: Provider.of<TodoDetailViewModel>(context, listen: false)
                .fetchTodo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              return Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            Consumer<TodoDetailViewModel>(
                                builder: (context, viewmodel, child) {
                              if (viewmodel.isEditMode) {
                                return CheckboxListTile(
                                    title: const Text("Mark as completed"),
                                    value: viewmodel.completed,
                                    onChanged: (value) {
                                      viewmodel.completed = value as bool;
                                    });
                              } else {
                                return const SizedBox();
                              }
                            }),
                            const SizedBox(
                              height: 36,
                            ),
                            Consumer<TodoDetailViewModel>(
                                builder: (context, viewmodel, child) {
                              return TodoDetailTextInput(
                                  controller: TextEditingController(
                                      text: viewmodel.title),
                                  labelText: "Title",
                                  validator: viewmodel.titleValidator,
                                  onChanged: (data) {
                                    viewmodel.title = data;
                                  });
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<TodoDetailViewModel>(
                                builder: (context, viewmodel, child) {
                              return TodoDetailTextInput(
                                  controller: TextEditingController(
                                      text: viewmodel.description),
                                  labelText: "Description",
                                  validator: viewmodel.descriptionValidator,
                                  onChanged: (data) {
                                    viewmodel.description = data;
                                  });
                            }),
                            const SizedBox(
                              height: 36,
                            ),
                            Text(
                              "Priority",
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<TodoDetailViewModel>(
                              builder: (context, viewmodel, child) {
                                return TodoDetailPriorityGrid(
                                  priority: viewmodel.priority,
                                  onPriorityChanged: (priority) {
                                    viewmodel.priority = priority;
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              height: 36,
                            ),
                            Text(
                              "Deadline",
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Consumer<TodoDetailViewModel>(
                              builder: (context, viewmodel, child) {
                                return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        DateFormat('dd MMMM yyyy')
                                            .format(viewmodel.deadline),
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      )),
                                      MaterialButton(
                                        textColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        onPressed: () {
                                          _selectDate(
                                              context, viewmodel.deadline,
                                              (picked) {
                                            viewmodel.deadline =
                                                viewmodel.deadline.copyWith(
                                                    year: picked.year,
                                                    month: picked.month,
                                                    day: picked.day);
                                          });
                                        },
                                        child: const Text(
                                          "CHANGE",
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 30,
                                      ),
                                    ]);
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Consumer<TodoDetailViewModel>(
                                builder: (context, viewmodel, child) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      DateFormat('HH:mm')
                                          .format(viewmodel.deadline),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge,
                                    )),
                                    MaterialButton(
                                      textColor:
                                          Theme.of(context).colorScheme.primary,
                                      onPressed: () {
                                        _selectTime(context, viewmodel.deadline,
                                            (picked) {
                                          viewmodel.deadline =
                                              viewmodel.deadline.copyWith(
                                                  hour: picked.hour,
                                                  minute: picked.minute);
                                        });
                                      },
                                      child: const Text("CHANGE"),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                  ]);
                            }),
                            const SizedBox(
                              height: 100,
                            ),
                            
                          ],
                        ),
                      )));
            }));
  }
}
