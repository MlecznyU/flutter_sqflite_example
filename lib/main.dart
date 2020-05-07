import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sqlite/sqlite_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'flutter_sqflite_example',
        home: HomePage(),
      ),
      create: (BuildContext context) => SqliteDatabase(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskModel> listOfTasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SafeArea(child: _buildListView()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              onSubmitted: (String taskName) async {
                final db = Provider.of<SqliteDatabase>(context, listen: false);
                await db.insertNewTask(TaskModel(
                  null,
                  taskName,
                  false,
                ));
              },
              decoration: InputDecoration(
                hintText: 'title of task',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            child: RaisedButton(
              child: Icon(Icons.refresh),
              onPressed: () async {
                final db = Provider.of<SqliteDatabase>(context, listen: false);
                listOfTasks = await db.getAllTasks();
                setState(() {});
              },
            ),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: listOfTasks == null ? 0 : listOfTasks.length,
        itemBuilder: (_, index) {
          final task = listOfTasks[index];
          return _buildItem(task);
        },
      ),
    );
  }

  Widget _buildItem(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              final db = Provider.of<SqliteDatabase>(context, listen: false);
              db.deleteTask(task.id);
            },
          )
        ],
        child: CheckboxListTile(
          title: Text(task.title),
          value: task.isDone,
          onChanged: (newValue)  {
            final db = Provider.of<SqliteDatabase>(context, listen: false);
            db.updateTask(TaskModel(
              task.id,
              task.title,
              newValue,
            ));
          },
        ),
      ),
    );
  }
}
