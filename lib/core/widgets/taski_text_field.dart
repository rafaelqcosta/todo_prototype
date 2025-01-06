import 'package:flutter/material.dart';

class TaskiTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool isRequired;

  const TaskiTextField(
      {super.key, required this.controller, this.hintText, this.isRequired = true});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      validator: (p0) {
        if (isRequired && (p0 == null || p0.isEmpty)) {
          return 'Required';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
      ),
    );
  }
}
