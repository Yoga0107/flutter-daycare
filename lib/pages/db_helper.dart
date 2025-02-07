import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "day_care.db";
  static const _databaseVersion = 1;

  static const tableUsers = 'users';
  static const columnId = '_id';
  static const columnName = 'name';
  static const columnEmail = 'email';
  static const columnPassword = 'password';
  static const columnRole = 'role';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Database instance
  static Database? _database;
  FutureOr<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  FutureOr<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Create users table
  FutureOr _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnEmail TEXT NOT NULL UNIQUE,
        $columnPassword TEXT NOT NULL,
        $columnRole TEXT NOT NULL
      )
      ''');
  }

  // Insert new user
  FutureOr<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableUsers, row);
  }

  // Query user by email
  FutureOr<Map<String, dynamic>?> queryUser(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query(tableUsers,
        where: '$columnEmail = ?', whereArgs: [email], limit: 1);
    if (users.isNotEmpty) {
      return users.first;
    } else {
      return null;
    }
  }
}
