import 'package:flutter/material.dart';
import 'package:simple_todo_bloc_sem/view/todo_screen.dart';

import '../blocs/todo_bloc.dart';
import '../data/todo.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late TodoBloc todoBloc;
  late List<Todo> todos;
  @override
  void initState() {
    todoBloc = TodoBloc();
    todoBloc.getTodos();
    super.initState();
  }

  @override
  void dispose() {
    todoBloc.dispose();
    super.dispose();
  }

  _onPressed(snapshot, index) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TodoScreen(snapshot.data![index], false)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: StreamBuilder<List<Todo>>(
        stream: todoBloc.todos,
        initialData: todoBloc.todoList,
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: (snapshot.hasData) ? snapshot.data!.length : 0,
            itemBuilder: (context, index) {
              return Dismissible(
                key: ValueKey(snapshot.data![index].id.toString()),
                onDismissed: (_) =>
                    todoBloc.todoDeleteSink.add(snapshot.data![index]),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('${snapshot.data![index].priority}'),
                  ),
                  title: Text(snapshot.data![index].name),
                  subtitle: Text(snapshot.data![index].description),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _onPressed(snapshot.data, index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TodoScreen(Todo('', '', '', 0), true)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
