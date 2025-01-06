class AddTodoArgs {
  final String task;
  final String description;
  final bool isDone;

  AddTodoArgs({required this.task, required this.description, this.isDone = false});
}
