import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'book_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<String> copyAssetToLocal(String assetPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = assetPath.split('/').last;
    final localPath = '${directory.path}/$fileName';

    // Check if file already exists
    if (!await File(localPath).exists()) {
      final ByteData data = await rootBundle.load(assetPath);
      final List<int> bytes = data.buffer.asUint8List();
      await File(localPath).writeAsBytes(bytes);
    }

    return localPath;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'library.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id TEXT PRIMARY KEY,
        title TEXT,
        author TEXT,
        cover TEXT,
        summary TEXT,
        ratings TEXT
      )
    ''');

    // Creating users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    final threekingdomsPath =
        await copyAssetToLocal('assets/three_kingdoms.jpg');
    final dunePath = await copyAssetToLocal('assets/dune.jpg');
    final redRisingPath = await copyAssetToLocal('assets/red_rising.jpg');

    await db.insert('books', {
      'id': '1',
      'title': 'Three Kingdoms',
      'author': 'Luo Guanzhong',
      'cover': threekingdomsPath, // example
      'summary': 'Çinin Savaşan Devletler zamanından birleşmesine olan dönem.',
      'ratings': ''
    });

    await db.insert('books', {
      'id': '2',
      'title': 'Dune',
      'author': 'Frank Herbert',
      'cover': dunePath, // example
      'summary': 'Melanj içeren çöl gezegeni.',
      'ratings': ''
    });

    await db.insert('books', {
      'id': '3',
      'title': 'Red Rising',
      'author': 'Pierce Brown',
      'cover': redRisingPath, // example
      'summary':
          'Marsta, madenci Darrowun elitlerin arasına sızmasını anlatıyor.',
      'ratings': ''
    });
  }

  // Insert a book
  Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert(
      'books',
      {
        'id': book.id,
        'title': book.title,
        'author': book.author,
        'cover': book.cover,
        'summary': book.summary,
        'ratings': book.ratings.join(',')
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all books
  Future<List<Book>> fetchBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) {
      return Book(
        id: maps[i]['id'],
        title: maps[i]['title'],
        author: maps[i]['author'],
        cover: maps[i]['cover'],
        summary: maps[i]['summary'],
        ratings: (maps[i]['ratings'] as String)
            .split(',')
            .where((e) => e.isNotEmpty)
            .map((e) => int.parse(e))
            .toList(),
      );
    });
  }

  // Update a book
  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update(
      'books',
      {
        'title': book.title,
        'author': book.author,
        'cover': book.cover,
        'summary': book.summary,
        'ratings': book.ratings.join(',')
      },
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  // Delete a book
  Future<void> deleteBook(String id) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Insert a user (sign up)
  Future<void> insertUser(String username, String password) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'username': username,
        'password': password,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get user by username (login)
  Future<Map<String, dynamic>?> getUser(String username) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // Update a user (optional)
  Future<void> updateUser(int id, String username, String password) async {
    final db = await database;
    await db.update(
      'users',
      {'username': username, 'password': password},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a user (optional)
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
