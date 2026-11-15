import 'package:sqflite/sqflite.dart';
import 'package:word_mate/data/data_sources/local/app_database.dart';

class AppSettingsDao {
  final AppDatabase _appDatabase;

  AppSettingsDao(this._appDatabase);

  Future<void> saveSetting(String key, String value) async {
    final db = await _appDatabase.database;
    await db.insert(
      'AppSettings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'AppSettings',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      return maps.first['value'] as String;
    }
    return null;
  }
}
