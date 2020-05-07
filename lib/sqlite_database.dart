import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskModel {
  final int id;
  final String title;
  final bool isDone;

  TaskModel(this.id, this.title, this.isDone);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone == true ? 1 : 0,
    };
  }

  static TaskModel fromMap(final Map<String, dynamic> map) {
    return TaskModel(
      map['id'],
      map['title'],
      map['isDone'] == 0 ? false : true,
    );
  }
}

class SqliteDatabase {
  Future<Database> getDatabase() async {
    return openDatabase(
      await getSqliteDatabasePath(),
      onCreate: onSqliteDatabaseCreate,
      version: 1,
    );
  }

  Future<void> onSqliteDatabaseCreate(
    final Database database,
    final int version,
  ) {
    return database.execute(
        'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, isDone INTEGER)');
  }

  Future<String> getSqliteDatabasePath() async {
    return join(await getDatabasesPath(), 'database.db');
  }

  Future<List<TaskModel>> getAllTasks() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(
      'tasks', //name of the table
    );
    return result.map(TaskModel.fromMap).toList();
  }

  Future<void> insertNewTask(final TaskModel newTask) async {
    final Database db = await getDatabase();
    await db.insert(
      'tasks',
      newTask.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
      // definition of how the base should behave if we try
      // to insert an object with the same primary key in it
      // fail - throws an exception
    );
  }

  Future<void> updateTask(final TaskModel updatedTask) async {
    final Database db = await getDatabase();
    await db.update(
      'tasks',
      updatedTask.toMap(),
      where: 'id = ?',
      whereArgs: [updatedTask.id],
    );
  }

  Future<void> deleteTask(final int taskId) async {
    final Database db = await getDatabase();

    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }
}
