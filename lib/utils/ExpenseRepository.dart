import 'dart:async';
import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';

class ExpenseRepository {
  static const _databaseName = "expenses_db";
  static const _databaseVersion = 1;

  static const table = 'expenses_table';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnAmount = 'amount';
  static const columnDate = 'created';
  static const columnCategory = 'category';


  // this opens the database (and creates it if it doesn't exist)
  Future<Database> initDb() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<List<Expense>> getExpenses() async {
    try {
      final List<Map<String, dynamic>> maps = await queryAllRows();
      final list = List.generate(maps.length, (i) {
        return Expense.fromDb(
          id: maps[i][columnId] as String,
          title: maps[i][columnTitle] as String,
          amount: maps[i][columnAmount] as int,
          created: DateTime.fromMicrosecondsSinceEpoch(maps[i][columnDate]),
          category: getCategoryByName(maps[i][columnCategory]),
        );
      });
      list.sort((a, b) => a.created.millisecondsSinceEpoch.compareTo(b.created.millisecondsSinceEpoch));
      return list;
    } catch (e) {
        log(e.toString());
    } 
    return List.empty();
  }

  // insert data
  Future<int> insertExpenses(List<Expense> expenses) async {
    int result = 0;
    final Database db = await initDb();
    for (var expense in expenses) {
      result = await db.insert(table, expense.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    return result;
  }


  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('DROP TABLE IF EXISTS $table');
    await db.execute('''
          CREATE TABLE $table (
            $columnId TEXT PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnAmount INTEGER NOT NULL,
            $columnDate INTEGER NOT NULL,
            $columnCategory TEXT NOT NULL
          )
          ''');
  }


  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final Database db = await initDb();
    return await db.query(table);
  }

  Future<int> delete(String id) async {
    final Database db = await initDb();
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}