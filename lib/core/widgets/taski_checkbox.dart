import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskiCheckbox extends StatelessWidget {
  final bool value;
  final double? scale;
  final Color? color;
  final void Function(bool?)? onChanged;
  const TaskiCheckbox({
    super.key,
    this.value = false,
    this.onChanged,
    this.scale = 1.4,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: CupertinoCheckbox(
        value: value,
        onChanged: onChanged,
        checkColor: value ? Colors.grey.shade300 : Colors.white,
        fillColor: value
            ? WidgetStateProperty.all(color ?? Colors.grey.shade400)
            : WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }
}
