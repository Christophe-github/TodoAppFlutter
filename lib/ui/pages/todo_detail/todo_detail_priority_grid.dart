import 'package:flutter/material.dart';

import '../../common/chip.dart';

class TodoDetailPriorityGrid extends StatelessWidget {
  const TodoDetailPriorityGrid(
      {super.key, required this.priority, required this.onPriorityChanged});

  final int priority;
  final ValueChanged<int> onPriorityChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          PriorityChip(
            title: "High",
            priority: 1,
            checked: priority == 1,
            onTap: () {
              onPriorityChanged(1);
            },
          ),
          const SizedBox(width: 12),
          PriorityChip(
              title: "Medium",
              priority: 2,
              checked: priority == 2,
              onTap: () {
                onPriorityChanged(2);
              }),
        ]),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          PriorityChip(
              title: "Low",
              priority: 3,
              checked: priority == 3,
              onTap: () {
                onPriorityChanged(3);
              }),
          const SizedBox(width: 12),
          PriorityChip(
            title: "None",
            priority: 4,
            checked: priority == 4,
            onTap: () {
              onPriorityChanged(4);
            },
          )
        ])
      ],
    );
  }
}