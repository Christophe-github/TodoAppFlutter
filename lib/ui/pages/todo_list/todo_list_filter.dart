import 'package:flutter/material.dart';
import 'package:todo_app/ui/common/chip.dart';
import 'package:todo_app/data/models/todo_query.dart';

class TodoListBottomSheetFilter extends StatelessWidget {
  const TodoListBottomSheetFilter({
    super.key,
    required this.query,
    required this.onQueryChanged,
  });

  final TodoQuery query;
  final ValueChanged<TodoQuery> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical:20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 20,),
                Text(
                  "Sort by",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(
                  width: 12,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.5,
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: DropdownButton(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      underline: const SizedBox(),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      value: query.sortBy,
                      items: const [
                        DropdownMenuItem(
                          value: TodoSortBy.defaultValue,
                          child: Text("Default"),
                        ),
                        DropdownMenuItem(
                          value: TodoSortBy.priority,
                          child: Text("Priority"),
                        ),
                        DropdownMenuItem(
                          value: TodoSortBy.deadline,
                          child: Text("Deadline"),
                        ),
                      ],
                      onChanged: (value) {
                        onQueryChanged(query.copy(sortBy: value));
                      }),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                const SizedBox(width: 20,),
                TodoChip(
                    title: "All",
                    checked: query.filter.priority == null,
                    onTap: () {
                      onQueryChanged(query.copy(
                          filter: TodoFilter(null, query.filter.completed)));
                    }),
                    const SizedBox(width: 12,),
                PriorityChip(
                    title: "High",
                    priority: 1,
                    checked: query.filter.priority == 1,
                    onTap: () {
                      onQueryChanged(query.copy(
                          filter: TodoFilter(1, query.filter.completed)));
                    }),
                    const SizedBox(width: 12,),
                PriorityChip(
                    title: "Medium",
                    priority: 2,
                    checked: query.filter.priority == 2,
                    onTap: () {
                      onQueryChanged(query.copy(
                          filter: TodoFilter(2, query.filter.completed)));
                    }),
                    const SizedBox(width: 12,),
                PriorityChip(
                    title: "Low",
                    priority: 3,
                    checked: query.filter.priority == 3,
                    onTap: () {
                      onQueryChanged(query.copy(
                          filter: TodoFilter(3, query.filter.completed)));
                    }),
                    const SizedBox(width: 12,),
                PriorityChip(
                    title: "None",
                    priority: 4,
                    checked: query.filter.priority == 4,
                    onTap: () {
                      onQueryChanged(query.copy(
                          filter: TodoFilter(4, query.filter.completed)));
                    }),
                    const SizedBox(width: 20,),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 20,),
                  TodoChip(
                      title: "All",
                      checked: query.filter.completed == null,
                      onTap: () {
                        onQueryChanged(query.copy(
                            filter: TodoFilter(query.filter.priority, null)));
                      }),
                      const SizedBox(width: 12,),
                  TodoChip(
                      title: "Completed",
                      leading: const Icon(Icons.check),
                      checked: query.filter.completed == true,
                      onTap: () {
                        onQueryChanged(query.copy(
                            filter: TodoFilter(query.filter.priority, true)));
                      }),
                      const SizedBox(width: 12,),
                  TodoChip(
                      title: "Pending",
                      leading: const Icon(Icons.pending_outlined),
                      checked: query.filter.completed == false,
                      onTap: () {
                        onQueryChanged(query.copy(
                            filter: TodoFilter(query.filter.priority, false)));
                      }),
                      const SizedBox(width: 20,),
                ],
              ),
            )
          ],
        ));
  }
}
