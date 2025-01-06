import 'package:flutter/material.dart';

import '../../../business/model/todo.dart';
import '../../../data/repositories/todo_repository.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';
import 'args/add_todo_args.dart';

class TodoListViewModel extends ChangeNotifier {
  TodoListViewModel({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository {
    load = Command0<void>(_load)..execute();
    add = Command1<void, AddTodoArgs>(_add);
    delete = Command1<void, int>(_delete);
    update = Command1<void, Todo>(_update);
    deleteAllDone = Command0<void>(_deleteAllDone);
  }

  final TodoRepository _todoRepository;

  late Command0<void> load;
  late Command1<void, AddTodoArgs> add;
  late Command1<void, Todo> update;
  late Command1<void, int> delete;
  late Command0<void> deleteAllDone;

  final searchController = TextEditingController();

  List<Todo> _todos = [];
  List<Todo> get todos => _todos
      .where((todo) => todo.task.toLowerCase().contains(searchController.text.toLowerCase()))
      .toList();

  Future<Result<void>> _load() async {
    try {
      final result = await _todoRepository.fetchTodos();
      switch (result) {
        case Ok<List<Todo>>():
          _todos = result.value;
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _add(AddTodoArgs args) async {
    try {
      final result = await _todoRepository.createTodo(args);
      switch (result) {
        case Ok<Todo>():
          _todos.add(result.value);
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _update(Todo todo) async {
    try {
      final result = await _todoRepository.updateTodo(todo);
      switch (result) {
        case Ok<void>():
          final index = _todos.indexWhere((t) => t.id == todo.id);
          if (index != -1) {
            _todos[index] = todo;
          }

          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _delete(int id) async {
    try {
      final result = await _todoRepository.deleteTodo(id);
      switch (result) {
        case Ok<void>():
          _todos.removeWhere((todo) => todo.id == id);
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteAllDone() async {
    try {
      final result = await _todoRepository.deleteAllDone();
      switch (result) {
        case Ok<void>():
          _todos.removeWhere((todo) => todo.isDone);
          return Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }
}
