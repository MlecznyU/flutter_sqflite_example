import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const idColumnName = 'id';
const titleColumnName = 'title';
const isDoneColumnName = 'is_done';
const tableName = 'tasks';
const databaseName = 'database.db';

class TaskModel {
  final int id;
  final String title;
  final bool isDone;

  TaskModel(this.id, this.title, this.isDone);

  Map<String, dynamic> toMap() {
    return {
      idColumnName: id,
      titleColumnName: title,
      isDoneColumnName: isDone == true ? 1 : 0,
    };
  }

  static TaskModel fromMap(final Map<String, dynamic> map) {
    return TaskModel(
      map[idColumnName],
      map[titleColumnName],
      map[isDoneColumnName] == 0 ? false : true,
    );
  }
}

class SqliteDatabase {
  Future<Database> getDatabase() async {
    return openDatabase(
      await getSqliteDatabasePath(),
      onCreate: onDatabaseCreate,
      version: 1,
    );
  }

  Future<void> onDatabaseCreate(
    final Database database,
    final int version,
  ) {
    return database.execute(
        'CREATE TABLE $tableName($idColumnName INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $titleColumnName TEXT, $isDoneColumnName INTEGER)');
  }

  Future<String> getSqliteDatabasePath() async {
    return join(await getDatabasesPath(), databaseName);
  }

  Future<List<TaskModel>> getAllTasks() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(tableName);
    return result.map(TaskModel.fromMap).toList();
  }

  Future<void> insertNewTask(final TaskModel newTask) async {
    final Database db = await getDatabase();
    await db.insert(
      tableName,
      newTask.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
      // conflictAlgorithm definition of how the base should
      // behave if we try to insert an object with the same
      // primary key. Fail - throws an exception
    );
  }

  Future<void> updateTask(final TaskModel updatedTask) async {
    final Database db = await getDatabase();
    await db.update(
      tableName,
      updatedTask.toMap(),
      where: '$idColumnName = ?',
      whereArgs: [updatedTask.id],
    );
  }

  Future<void> deleteTask(final int taskId) async {
    final Database db = await getDatabase();
    await db.delete(
      tableName,
      where: '$idColumnName = ?',
      whereArgs: [taskId],
    );
  }
}
