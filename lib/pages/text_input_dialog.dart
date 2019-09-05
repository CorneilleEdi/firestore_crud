import 'package:firestore_crud/models/task.dart';
import 'package:firestore_crud/services/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

displayDialog({
  @required BuildContext context,
  @required TaskRepository repository,
  bool update = false,
  Task task
}) async {
  final TextEditingController textEditingController = TextEditingController();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(update ? 'Update task' : 'Add a task'),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              labelText: 'title',
              filled: true,
              hintText: update ? task.name : "Enter a title",
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                update ? 'UPDATE' : 'OK',
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () async {
                final message = textEditingController.text;
                textEditingController.clear();
                Navigator.of(context).pop();
                if (update) {
                  task.name = message;
                  await repository.updateTask(task);
                } else {
                  final task = Task(
                      name: message,
                      createdAt: DateTime.now().millisecondsSinceEpoch);
                  await repository.addTask(task);
                }

              },
            ),
          ],
        );
      });
}
