import 'package:flutter/material.dart';
import 'package:todo_prototype/ui/todo_list/viewmodel/todo_list_viewmodel.dart';

import '../../../../business/model/todo.dart';

class DeleteTodoBottomSheet extends StatefulWidget {
  const DeleteTodoBottomSheet({super.key, required this.viewModel, required this.todo});
  final TodoListViewModel viewModel;
  final Todo todo;

  @override
  State<DeleteTodoBottomSheet> createState() => _DeleteTodoBottomSheetState();
}

class _DeleteTodoBottomSheetState extends State<DeleteTodoBottomSheet> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.delete.addListener(_onDelete);
  }

  @override
  void dispose() {
    widget.viewModel.delete.removeListener(_onDelete);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Are you sure you want to delete this task?',
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.viewModel.delete.execute(
                      widget.todo.id,
                    );
                  },
                  child: Text(
                    'Yes, delete!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _onDelete() {
    if (widget.viewModel.delete.completed) {
      widget.viewModel.delete.clearResult();
    }
  }
}
