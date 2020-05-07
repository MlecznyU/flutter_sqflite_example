import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'flutter_sqflite_example',
        home: HomePage(),
      ),
      create: (BuildContext context) {
        // here we can provide database
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
              onSubmitted: (String taskName) {},
              decoration: InputDecoration(
                hintText: 'title of task',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            child: RaisedButton(
              child: Icon(Icons.refresh),
              onPressed: () {},
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
        itemCount: 12,
        // TODO Then change to the length of the list
        itemBuilder: (_, index) {
          //Todo Later change to the title taken from the list
          return _buildItem('item');
        },
      ),
    );
  }

  Widget _buildItem(String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {},
          )
        ],
        child: CheckboxListTile(
          title: Text(name),
          value: false,
          onChanged: (newValue) {},
        ),
      ),
    );
  }
}
