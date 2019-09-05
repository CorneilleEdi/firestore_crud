import 'package:firestore_crud/models/task.dart';
import 'package:firestore_crud/pages/text_input_dialog.dart';
import 'package:firestore_crud/services/task_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TaskRepository _repository = TaskRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        elevation: 8.0,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StreamBuilder<List<Task>>(
          stream: _repository.getFromDb(),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator(),);
              default :
                return ListView(
                  children: makeListWidget(snapshot),
                );
            }

          },
        ),
      ),
      floatingActionButton:
          FloatingActionButton(child: new Icon(Icons.add), onPressed: () {
            displayDialog(context: context, repository: _repository);
          }),
    );
  }

  _formatDate(int at) {
    return DateFormat.yMd()
        .add_jm()
        .format(DateTime.fromMillisecondsSinceEpoch(at));
  }


  makeListWidget(AsyncSnapshot snapshot) {
    return snapshot.data.map<Widget>((Task task) {
      return Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Card(
          elevation: 2.0,
          child: ListTile(
            onLongPress: (){
              displayDialog(context: context, repository: _repository, update: true, task : task );
            },
              title: Text(
                task.name,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              subtitle: Text(
                'created at  ${_formatDate(task.createdAt)}',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
              ),
              trailing: IconButton(
                onPressed: () async {
                  await _repository.deleteTask(task.id);
                },
                icon: Icon(
                  Icons.remove_circle,
                  color: Theme.of(context).accentColor,
                ),
              )),
        ),
      );
    }).toList();
  }
}
