import 'package:flutter/material.dart';
import 'package:todo_prototype/core/widgets/taski_checkbox.dart';
import 'package:todo_prototype/core/widgets/taski_text_field.dart';
import 'package:todo_prototype/ui/todo_list/viewmodel/args/add_todo_args.dart';
import 'package:todo_prototype/ui/todo_list/viewmodel/todo_list_viewmodel.dart';

import '../../../../business/model/todo.dart';

class AddOrUpdateTodoBottomSheet extends StatefulWidget {
  const AddOrUpdateTodoBottomSheet({super.key, required this.viewModel, this.todo});
  final TodoListViewModel viewModel;
  final Todo? todo;

  @override
  State<AddOrUpdateTodoBottomSheet> createState() => _AddOrUpdateTodoBottomSheetState();
}

class _AddOrUpdateTodoBottomSheetState extends State<AddOrUpdateTodoBottomSheet> {
  late TextEditingController _taskController;
  late TextEditingController _descController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _taskController = TextEditingController(text: widget.todo?.task);
    _descController = TextEditingController(text: widget.todo?.description);
    super.initState();
    widget.viewModel.add.addListener(_onAddOrUpdate);
    widget.viewModel.update.addListener(_onAddOrUpdate);
  }

  @override
  void dispose() {
    _taskController.dispose();
    _descController.dispose();
    widget.viewModel.add.removeListener(_onAddOrUpdate);
    widget.viewModel.update.removeListener(_onAddOrUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    TaskiCheckbox(
                      value: false,
                      onChanged: (p0) {},
                      scale: 1.5,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TaskiTextField(
                        controller: _taskController,
                        hintText: "What's in your mind?",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.edit, color: Colors.grey),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TaskiTextField(
                        controller: _descController,
                        hintText: "Add a note...",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() == false) return;
                    Navigator.pop(context);
                    if (widget.todo == null) {
                      widget.viewModel.add.execute(
                        AddTodoArgs(
                          task: _taskController.text.trim(),
                          description: _descController.text.trim(),
                        ),
                      );
                    } else {
                      widget.viewModel.update.execute(
                        Todo(
                          id: widget.todo!.id,
                          task: _taskController.text.trim(),
                          description: _descController.text.trim(),
                          isDone: widget.todo!.isDone,
                        ),
                      );
                    }
                  },
                  child: Text(
                    widget.todo == null ? 'Create' : 'Update',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onAddOrUpdate() {
    if (widget.viewModel.add.completed || widget.viewModel.update.completed) {
      widget.viewModel.add.clearResult();
      widget.viewModel.update.clearResult();
      _taskController.clear();
      _descController.clear();
    }
  }
}
