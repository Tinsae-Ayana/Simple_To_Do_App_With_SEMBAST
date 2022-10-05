import 'package:flutter/material.dart';
import 'package:simple_todo_bloc_sem/blocs/todo_bloc.dart';
import 'package:simple_todo_bloc_sem/data/todo.dart';
import 'package:simple_todo_bloc_sem/view/home_page.dart';

class TodoScreen extends StatelessWidget {
  //
  TodoScreen(this.todo, this.isNew, {Key? key}) : super(key: key);
  final Todo todo;
  final bool isNew;
  final bloc = TodoBloc();
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtCompleteBy = TextEditingController();
  final TextEditingController txtPriority = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            TextField(
                controller: txtName,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Name')),
            TextField(
                controller: txtDescription,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Description')),
            TextField(
                controller: txtCompleteBy,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Complete by')),
            TextField(
                controller: txtPriority,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Priority')),
            MaterialButton(
                color: Colors.green,
                child: const Text('save'),
                onPressed: () {
                  save().then((value) {
                    Navigator.pop(context);
                  });
                })
          ],
        ),
      ),
    );
  }

  Future save() async {
    todo.name = txtName.text;
    todo.description = txtDescription.text;
    todo.completeBy = txtCompleteBy.text;
    todo.priority = int.tryParse(txtPriority.text)!;
    if (isNew) {
      bloc.todoInsertSink.add(todo);
    } else {
      bloc.todoUpdateSink.add(todo);
    }
  }
}
