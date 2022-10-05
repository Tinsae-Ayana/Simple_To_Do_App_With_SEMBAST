import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:simple_todo_bloc_sem/data/todo.dart';

class TodoDb {
  DatabaseFactory dbFactory = databaseFactoryIo;
  final store = intMapStoreFactory.store('todos');
  late Database _database;

  static final TodoDb _singleton = TodoDb._internal();
  TodoDb._internal();
  factory TodoDb() {
    return _singleton;
  }

  Future _openDb() async {
    final docspath = await getApplicationDocumentsDirectory();
    final dbPath = join(docspath.path, 'todos.db');
    final db = await dbFactory.openDatabase(dbPath);
    _database = db;
    debugPrint('database opended');
  }

  Future insertTodo(Todo todo) async {
    // await database;
    await store.add(_database, todo.toMap());
    debugPrint('task inserted');
  }

  Future updateTodo(Todo todo) async {
    // await database;
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.update(_database, todo.toMap(), finder: finder);
    debugPrint('task updated');
  }

  Future deleteTodo(Todo todo) async {
    // await database;
    final finder = Finder(filter: Filter.byKey(todo.id));
    await store.delete(_database, finder: finder);
    debugPrint('task deleted');
  }

  Future deleteAll() async {
    // await database;
    await store.delete(_database);
  }

  Future<List<Todo>> getTodos() async {
    await _openDb();
    final finder = Finder(sortOrders: [SortOrder('priority'), SortOrder('id')]);
    final todosSnapshot = await store.find(_database, finder: finder);
    debugPrint('read from database');
    return todosSnapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);
      todo.id = snapshot.key;
      return todo;
    }).toList();
  }
}
