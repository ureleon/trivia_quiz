import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Добавляет запись о вопросе в базу
Future<void> changeDB(String date, String question, String answer, String mark) async {
  final String databasesPath = await getDatabasesPath();
  final String path = join(databasesPath, 'statistics.db');

  final Database database = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS Statistics (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, questions TEXT, answer TEXT, mark TEXT)',
      );
    },
  );

  // Используем параметризованный запрос, чтобы избежать SQL-инъекций и ошибок с кавычками
  await database.insert(
    'Statistics',
    <String, Object?>{
      'date': date,
      'questions': question,
      'answer': answer,
      'mark': mark,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  await database.close();
}

/// Возвращает список всех записей из таблицы Statistics
Future<List<Map<String, dynamic>>> getStatistics() async {
  final String databasesPath = await getDatabasesPath();
  final String path = join(databasesPath, 'statistics.db');

  final Database database = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS Statistics (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, questions TEXT, answer TEXT, mark TEXT)',
      );
    },
  );

  final List<Map<String, dynamic>> list = await database.rawQuery('SELECT * FROM Statistics');
  await database.close();
  return list;
}

Future<List<Map<String, dynamic>>> searchStatistics(String userSearch) async {
  final String databasesPath = await getDatabasesPath();
  final String path = join(databasesPath, 'statistics.db');

  final Database database = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS Statistics (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, questions TEXT, answer TEXT, mark TEXT)',
      );
    },
  );


  final List<Map<String, dynamic>> list = await database.rawQuery(
      "SELECT * FROM Statistics WHERE date LIKE '%$userSearch%' OR questions LIKE '%$userSearch%' OR answer LIKE '%$userSearch%' or mark LIKE '%$userSearch%'"
  );
  await database.close();
  return list;
}
