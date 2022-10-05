import 'dart:async';
import 'package:simple_todo_bloc_sem/data/todo_db.dart';
import '../data/todo.dart';

class TodoBloc {
  TodoBloc() {
    db = TodoDb();
    _todosStreamController.stream.listen(returnTodos);
    _todoInsertController.stream.listen(_addTodo);
    _todoUpdateController.stream.listen(_updateTodp);
    _todoDeleteController.stream.listen(_deleteTodo);
  }
  late TodoDb db;
  List<Todo> todoList = [];
  final _todosStreamController = StreamController<List<Todo>>.broadcast();
  final _todoInsertController = StreamController<Todo>();
  final _todoUpdateController = StreamController<Todo>();
  final _todoDeleteController = StreamController<Todo>();
  Stream<List<Todo>> get todos => _todosStreamController.stream;
  StreamSink<List<Todo>> get todosSink => _todosStreamController.sink;
  StreamSink<Todo> get todoInsertSink => _todoInsertController.sink;
  StreamSink<Todo> get todoUpdateSink => _todoUpdateController.sink;
  StreamSink<Todo> get todoDeleteSink => _todoDeleteController.sink;

  Future getTodos() async {
    List<Todo> todos = await db.getTodos();
    todoList = todos;
    todosSink.add(todos);
  }

  List<Todo> returnTodos(todos) {
    return todos;
  }

  void _deleteTodo(Todo todo) {
    db.deleteTodo(todo).then((value) => getTodos());
  }

  void _updateTodp(Todo todo) {
    db.updateTodo(todo).then((value) => getTodos());
  }

  void _addTodo(Todo todo) {
    db.insertTodo(todo).then((value) => getTodos());
  }

  void dispose() {
    _todoDeleteController.close();
    _todoInsertController.close();
    _todoDeleteController.close();
    _todoDeleteController.close();
  }
}
