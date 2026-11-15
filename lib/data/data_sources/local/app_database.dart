import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static const String _databaseName = "word_mate.db";
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    // Add support for foreign keys
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Bảng AppSettings
    await db.execute('''
      CREATE TABLE AppSettings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    // 2. Bảng Topics
    await db.execute('''
      CREATE TABLE Topics (
        topic_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color_hex TEXT DEFAULT '#FFFFFF',
        is_default INTEGER DEFAULT 0,
        created_at INTEGER
      )
    ''');

    // 3. Bảng Cards
    await db.execute('''
      CREATE TABLE Cards (
        card_id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER,
        word TEXT NOT NULL,
        meaning TEXT NOT NULL,
        type TEXT,
        ipa TEXT,
        example TEXT,
        image_path TEXT,
        audio_path TEXT,
        is_archived INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        next_review_ts INTEGER DEFAULT (CAST(strftime('%s','now') AS INTEGER)),
        interval_days INTEGER DEFAULT 0,
        easiness_factor REAL DEFAULT 2.5,
        streak INTEGER DEFAULT 0,
        FOREIGN KEY (topic_id) REFERENCES Topics(topic_id) ON DELETE SET NULL
      )
    ''');

    // 4. Bảng ReviewHistory
    await db.execute('''
      CREATE TABLE ReviewHistory (
        review_id INTEGER PRIMARY KEY AUTOINCREMENT,
        card_id INTEGER,
        review_ts INTEGER NOT NULL,
        rating INTEGER NOT NULL,
        duration_ms INTEGER,
        FOREIGN KEY (card_id) REFERENCES Cards(card_id) ON DELETE CASCADE
      )
    ''');
  }
}
