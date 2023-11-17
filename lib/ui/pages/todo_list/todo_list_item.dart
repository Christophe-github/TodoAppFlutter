import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/ui/common/utils.dart';
import 'dart:math';

import '../../../data/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem(
      {super.key,
      required this.todo,
      required this.onTap,
      required this.onLongPress});

  final Todo todo;
  final ValueChanged<Todo> onTap;
  final ValueChanged<Todo> onLongPress;

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('dd MMM').format(todo.deadline);
    final timeFormatted = DateFormat('HH:mm').format(todo.deadline);

    return InkWell(
      onTap: () {
        onTap(todo);
      },
      onLongPress: () {
        onLongPress(todo);
      },
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(children: [
          _animatedRotatingCircleWithCheckmark(todo.completed, todo.priority),
          SizedBox(width: 12,),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                todo.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(todo.description)
            ]),
          )),
          Column(
            children: [
              Text(dateFormatted.toString()),
              Text(timeFormatted.toString(),
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          )
        ]),
      ),
    );
  }
}

Widget _circleWithCheckmark(int priority, bool showCheckMark) {
  return Stack(alignment: Alignment.center, children: [
    Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getColorFromPriority(priority),
      ),
      width: 48,
      height: 48,
    ),
    if (showCheckMark) const Icon(Icons.check, color: Colors.white,size: 32,)
  ]);
}

Widget _animatedRotatingCircleWithCheckmark(bool flip, int priority) {
  return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: flip ? pi : 0.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
      builder: (context, value, widget) {
        return Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(value),
            child: Transform.flip(
                flipX: true,
                //The checkmark becomes visible when half a flip has been made
                child: _circleWithCheckmark(priority, value > pi / 2)));
      });
}

