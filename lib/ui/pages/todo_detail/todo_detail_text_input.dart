import 'package:flutter/material.dart';

class TodoDetailTextInput extends StatelessWidget {
  const TodoDetailTextInput({
    super.key,
    required this.controller,
    required this.labelText,
    required this.validator,
    required this.onChanged, 
  });

  final TextEditingController controller;
  final String labelText;
  final String? Function(String?) validator;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
   
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), labelText: labelText),
          validator: validator ,
      onChanged: (data) {
        onChanged(data);
      },
    );
  }

  
}
