import 'package:flutter/material.dart';

class TaskiButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Function() onPressed;

  const TaskiButton({super.key, required this.title, this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE8F2FF),
        foregroundColor: const Color(0xFF4285F4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      icon: icon != null ? Icon(icon) : null,
      label: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
