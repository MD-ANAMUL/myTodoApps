import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTable(sql.Database database) async {
    await database.execute(
        """CREATE TABLE dataStore(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , 
    title TEXT,
    desc TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbTodo.db',
      version: 1,
      onCreate: (sql.Database databases, int version) async {
        print("...Creating a table....");
        await createTable(databases);
      },
    );
  }

  static Future<int> createData(String title, String? description) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': description};
    final id = await db.insert('items', data,conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllData() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getOneData(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateData(
      int id, String title, String? description) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ? ", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id=?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting and item : $err");
    }
  }
}
