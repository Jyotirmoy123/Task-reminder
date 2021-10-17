

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TasksDatabase{

  setDatabase() async{
    String databasePath = await getDatabasesPath();
    String path = join(databasePath,"tasks_db");
    Database database = await openDatabase(path,version: 1,onCreate: (Database db,int version)async{
      await db.execute("CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, note TEXT, type TEXT, howManyWeeks INTEGER, taskForm TEXT, time INTEGER, notifyId INTEGER)");
    });
    return database;
  }

}