import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Private constructor
  DatabaseHelper._internal();

  // Factory constructor to return the instance
  factory DatabaseHelper() {
    return _instance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Bookmarks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        image TEXT
      )
    ''');
  }

  Future<int> insertBookmark(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert('bookmarks', row);
  }

  Future<bool> toggleBookmark(String title) async {
    Database db = await database;
    final bookmark = await db.query('bookmarks', where: 'title = ?', whereArgs: [title]);
    if (bookmark.isEmpty) {
      // Bookmark does not exist, so insert it
      await insertBookmark({'title': title, 'image': ''});
      return true; // Bookmark was added
    } else {
      // Bookmark exists, so delete it
      await deleteBookmark(title);
      return false; // Bookmark was removed
    }
  }

  Future<List<Map<String, dynamic>>> getBookmarks() async {
    Database db = await database;
    return await db.query('bookmarks');
  }

  Future<int> deleteBookmark(String title) async {
    Database db = await database;
    return await db.delete('bookmarks', where: 'title = ?', whereArgs: [title]);
  }
}