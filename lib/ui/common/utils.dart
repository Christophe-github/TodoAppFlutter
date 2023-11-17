import 'package:flutter/material.dart';

Color getColorFromPriority(int priority) {
  switch (priority) {
    case 1:
      return Colors.red.shade600;
    case 2:
      return Colors.orange.shade600;
    case 3:
      return Colors.green.shade600;
    default:
      return Colors.blue.shade600;
  }
}
