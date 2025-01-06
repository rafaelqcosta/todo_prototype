import 'package:todo_prototype/ui/todo_list/viewmodel/args/add_todo_args.dart';

import '../../business/model/todo.dart';
import '../../utils/result.dart';
import '../services/database_service.dart';

class TodoRepository {
  TodoRepository({
    required DatabaseService database,
  }) : _database = database;

  final DatabaseService _database;

  Future<Result<List<Todo>>> fetchTodos() async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.getAll();
  }

  Future<Result<Todo>> createTodo(AddTodoArgs args) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.insert(args);
  }

  Future<Result<void>> updateTodo(Todo todo) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.updateTodo(todo);
  }

  Future<Result<void>> deleteTodo(int id) async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.delete(id);
  }

  Future<Result<void>> deleteAllDone() async {
    if (!_database.isOpen()) {
      await _database.open();
    }
    return _database.deleteAllDone();
  }
}
