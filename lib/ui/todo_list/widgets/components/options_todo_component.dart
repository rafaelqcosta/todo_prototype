import 'package:flutter/material.dart';
import 'package:todo_prototype/business/model/todo.dart';
import 'package:todo_prototype/ui/todo_list/viewmodel/todo_list_viewmodel.dart';
import 'package:todo_prototype/ui/todo_list/widgets/components/add_or_update_todo_bottom_sheet.dart';
import 'package:todo_prototype/ui/todo_list/widgets/components/delete_todo_bottom_sheet.dart';

enum SampleItem { edit, delete }

class OptionsTodoComponent extends StatefulWidget {
  final TodoListViewModel viewModel;
  final Todo todo;
  const OptionsTodoComponent({super.key, required this.viewModel, required this.todo});

  @override
  State<OptionsTodoComponent> createState() => _OptionsTodoComponentState();
}

class _OptionsTodoComponentState extends State<OptionsTodoComponent> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SampleItem>(
      iconColor: Colors.grey,
      onSelected: (SampleItem item) {
        switch (item) {
          case SampleItem.edit:
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return AddOrUpdateTodoBottomSheet(
                  viewModel: widget.viewModel,
                  todo: widget.todo,
                );
              },
            );
            break;
          case SampleItem.delete:
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return DeleteTodoBottomSheet(
                  viewModel: widget.viewModel,
                  todo: widget.todo,
                );
              },
            );
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          value: SampleItem.edit,
          child: Text('Edit'),
        ),
        const PopupMenuItem<SampleItem>(
          value: SampleItem.delete,
          child: Text('Delete'),
        ),
      ],
    );
  }
}
