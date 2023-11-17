import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TodoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TodoAppBar(
      {super.key, required this.title, this.leading, this.actions});

  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title),
      ),
      leading: leading,
      actions: actions,
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      titleTextStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
      iconTheme: Theme.of(context).iconTheme,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
