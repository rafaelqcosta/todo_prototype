import 'package:flutter/material.dart';
import 'package:todo_prototype/business/model/todo.dart';
import 'package:todo_prototype/core/widgets/taski_checkbox.dart';
import 'package:todo_prototype/ui/todo_list/viewmodel/todo_list_viewmodel.dart';
import 'package:todo_prototype/ui/todo_list/widgets/components/options_todo_component.dart';

class ExpansionTileComponent extends StatefulWidget {
  final TodoListViewModel viewModel;
  final Todo todo;
  final Function()? onDelete;
  final Function()? onEdit;
  final Function()? onIsDone;

  const ExpansionTileComponent({
    super.key,
    required this.todo,
    this.onDelete,
    this.onEdit,
    this.onIsDone,
    required this.viewModel,
  });

  @override
  State<ExpansionTileComponent> createState() => _ExpansionTileComponentState();
}

class _ExpansionTileComponentState extends State<ExpansionTileComponent>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  bool isDone = false;

  late AnimationController _animationController;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    // Sincroniza estado local do checkbox
    isDone = widget.todo.isDone;

    // 1s total de animação
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _blinkAnimation = TweenSequence<double>(List.generate(
            5,
            (int index) => TweenSequenceItem(
                  tween: Tween(begin: 1.0, end: 0.0),
                  weight: 1,
                )).toList())
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleCheckboxChanged(bool? value) {
    setState(() {
      isDone = true; // check local para a UI
    });
    // Inicia animação de "piscar". Ao final, chama onIsDone
    _animationController.forward().then((_) {
      widget.onIsDone?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _blinkAnimation,
      child: Card(
        color: widget.todo.isDone ? const Color(0xFFF5F7F9) : null,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          onTap: () {
            if (!widget.todo.isDone) {
              setState(() {
                isExpanded = !isExpanded;
              });
            }
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Row(
            children: [
              TaskiCheckbox(
                value: isDone,
                color: Colors.blue,
                onChanged: isDone ? null : _handleCheckboxChanged,
              ),
              Expanded(
                child: Text(
                  widget.todo.task,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.todo.isDone ? Colors.grey.shade400 : null,
                      ),
                  maxLines: isExpanded ? null : 1,
                ),
              ),
              widget.todo.isDone
                  ? IconButton(
                      onPressed: widget.onDelete,
                      icon: const Icon(Icons.delete, color: Colors.red),
                    )
                  : OptionsTodoComponent(
                      viewModel: widget.viewModel,
                      todo: widget.todo,
                    ),
            ],
          ),
          subtitle: isExpanded
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 46),
                  child: Text(
                    widget.todo.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
