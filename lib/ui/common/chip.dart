import 'package:flutter/material.dart';
import 'package:todo_app/ui/common/utils.dart';


class TodoChip extends StatelessWidget {
  const TodoChip({
    super.key,
    required this.title,
    this.leading,
    required this.checked,
    required this.onTap,
  });

  final String title;
  final Widget? leading;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: checked
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            splashColor: Theme.of(context).colorScheme.primaryContainer,
            onTap: onTap,
            child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                reverseDuration: const Duration(milliseconds: 300),
                curve: Curves.ease,
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          leading ?? const SizedBox(),
                          const SizedBox(width: 12),
                          Text(title,style: Theme.of(context).textTheme.bodyMedium,),
                          const SizedBox(width: 12),
                          _checkmark(context, checked)
                        ])))));
  }
}

Widget _checkmark(BuildContext context, bool checked) {
  if (checked) {
    return Icon(
      Icons.check,
      color: Theme.of(context).colorScheme.primary,
      size: 20,
    );
  } else {
    return const SizedBox();
  }
}

class PriorityChip extends StatelessWidget {
  const PriorityChip({
    super.key,
    required this.title,
    required this.priority,
    required this.checked,
    required this.onTap,
  });

  final String title;
  final int priority;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TodoChip(
      title: title,
      checked: checked,
      onTap: onTap,
      leading: _coloredCircle(priority),
    );
  }
}

Widget _coloredCircle(int priority) {
  Color color;

  color = getColorFromPriority(priority);

  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color,
    ),
    width: 20,
    height: 20,
  );
}
