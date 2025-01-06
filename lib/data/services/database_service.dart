import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_prototype/ui/todo_list/viewmodel/args/add_todo_args.dart';

import '../../business/model/todo.dart';
import '../../utils/result.dart';

class DatabaseService {
  DatabaseService({
    required this.databaseFactory,
  });

  final DatabaseFactory databaseFactory;

  static const _kTableTodo = 'todo';
  static const _kColumnId = '_id';
  static const _kColumnTask = 'task';
  static const _kDescription = 'description';
  static const _kIsDone = 'is_done';

  Database? _database;

  bool isOpen() => _database != null;

  Future<void> open() async {
    _database = await databaseFactory.openDatabase(
      join(await databaseFactory.getDatabasesPath(), 'app_database.db'),
      options: OpenDatabaseOptions(
        onCreate: (db, version) {
          return db.execute('CREATE TABLE $_kTableTodo('
              '$_kColumnId INTEGER PRIMARY KEY AUTOINCREMENT, '
              '$_kColumnTask TEXT, '
              '$_kDescription TEXT, '
              '$_kIsDone INTEGER)');
        },
        version: 1,
      ),
    );
  }

  Future<Result<Todo>> insert(AddTodoArgs args) async {
    try {
      final id = await _database!.insert(_kTableTodo, {
        _kColumnTask: args.task,
        _kDescription: args.description,
        _kIsDone: args.isDone ? 1 : 0,
      });
      return Result.ok(Todo(
        id: id,
        task: args.task,
        description: args.description,
        isDone: args.isDone,
      ));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<List<Todo>>> getAll() async {
    try {
      final entries = await _database!.query(
        _kTableTodo,
        columns: [_kColumnId, _kColumnTask, _kDescription, _kIsDone],
      );

      final list = entries
          .map(
            (element) => Todo(
              id: element[_kColumnId] as int,
              task: element[_kColumnTask] as String,
              description: element[_kDescription] as String,
              isDone: (element[_kIsDone] as int?) == 1,
            ),
          )
          .toList();
      return Result.ok(list);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> delete(int id) async {
    try {
      final rowsDeleted =
          await _database!.delete(_kTableTodo, where: '$_kColumnId = ?', whereArgs: [id]);
      if (rowsDeleted == 0) {
        return Result.error(Exception('No todo found with id $id'));
      }
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> updateTodo(Todo todo) async {
    try {
      final rowsUpdated = await _database!.update(
        _kTableTodo,
        {
          _kColumnTask: todo.task,
          _kDescription: todo.description,
          _kIsDone: todo.isDone ? 1 : 0,
        },
        where: '$_kColumnId = ?',
        whereArgs: [todo.id],
      );

      if (rowsUpdated == 0) {
        return Result.error(Exception('No todo found with id ${todo.id}'));
      }

      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteAllDone() async {
    try {
      await _database!.delete(
        _kTableTodo,
        where: '$_kIsDone = ?',
        whereArgs: [1],
      );

      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future close() async {
    await _database?.close();
    _database = null;
  }
}
