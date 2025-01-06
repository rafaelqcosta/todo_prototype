import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todo_prototype/core/icons/taski_icons.dart';
import 'package:todo_prototype/core/widgets/taski_button.dart';
import 'package:todo_prototype/ui/todo_list/widgets/components/expansion_tile_component.dart';

import '../viewmodel/todo_list_viewmodel.dart';
import 'components/add_or_update_todo_bottom_sheet.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({
    super.key,
    required this.viewModel,
    required this.isSearching,
    required this.isDone,
  });

  final TodoListViewModel viewModel;
  final bool isSearching;
  final bool isDone;

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.update.addListener(_onUpdate);
    widget.viewModel.delete.addListener(_onDelete);
    widget.viewModel.deleteAllDone.addListener(_onDeleteAllDone);
  }

  @override
  void dispose() {
    widget.viewModel.update.removeListener(_onUpdate);
    widget.viewModel.delete.removeListener(_onDelete);
    widget.viewModel.deleteAllDone.removeListener(_onDeleteAllDone);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Visibility(
            visible: !widget.isDone,
            replacement: Row(
              children: [
                Expanded(
                  child: Text(
                    'Completed Tasks',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.viewModel.deleteAllDone.execute();
                  },
                  child: Text(
                    'Delete all',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            child: widget.isSearching
                ? TextField(
                    controller: widget.viewModel.searchController,
                    onChanged: (value) => setState(() {}),
                    onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      suffixIconConstraints: BoxConstraints(maxHeight: 15, maxWidth: 40),
                      suffixIcon: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: const CircleBorder(),
                          fixedSize: Size(15, 15),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
                        ),
                        iconSize: 12,
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(
                          () => widget.viewModel.searchController.clear(),
                        ),
                      ),
                      hintText: 'Type to search',
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 1.5,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                    ),
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Text.rich(
                            textAlign: TextAlign.left,
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Welcome, ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: 'John',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      ListenableBuilder(
                        listenable: widget.viewModel,
                        builder: (context, snapshot) {
                          final todos = widget.viewModel.todos
                              .where((todo) => todo.isDone == widget.isDone)
                              .toList();
                          return Row(
                            children: [
                              Text(
                                todos.isEmpty
                                    ? 'Create tasks to achieve more.'
                                    : "You've got ${todos.length} tasks to do",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, child) {
                final todos =
                    widget.viewModel.todos.where((todo) => todo.isDone == widget.isDone).toList();
                if (todos.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        TaskiIcons.empty,
                      ),
                      SizedBox(height: 16),
                      Text(
                        widget.isDone
                            ? 'You have no done task listed.'
                            : widget.viewModel.searchController.text.isEmpty
                                ? 'You have no task listed.'
                                : 'No result found.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      if (widget.viewModel.searchController.text.isEmpty && !widget.isDone)
                        TaskiButton(
                          onPressed: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return AddOrUpdateTodoBottomSheet(viewModel: widget.viewModel);
                            },
                          ),
                          title: 'Create task',
                          icon: Icons.add,
                        ),
                    ],
                  );
                }
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTileComponent(
                        key: ValueKey(todo.id),
                        todo: todo,
                        onIsDone: () {
                          widget.viewModel.update.execute(todo.copyWith(isDone: true));
                        },
                        onDelete: () {
                          widget.viewModel.delete.execute(todo.id);
                        },
                        viewModel: widget.viewModel,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onUpdate() {
    if (widget.viewModel.update.completed) {
      widget.viewModel.update.clearResult();
    }
  }

  void _onDelete() {
    if (widget.viewModel.delete.completed) {
      widget.viewModel.delete.clearResult();
    }
  }

  void _onDeleteAllDone() {
    if (widget.viewModel.deleteAllDone.completed) {
      widget.viewModel.deleteAllDone.clearResult();
    }
  }
}
