import 'package:sqflite/sqflite.dart';
import 'package:word_mate/data/data_sources/local/app_database.dart';

class HomeDao {
  final AppDatabase _appDatabase;

  HomeDao(this._appDatabase);

  /// Đếm số Cards được tạo hôm nay
  Future<int> getTodayLearnedCount() async {
    final db = await _appDatabase.database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 1000;
    final endOfDay = startOfDay + 86400; // +24h

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM Cards WHERE created_at >= ? AND created_at < ?',
      [startOfDay, endOfDay],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Tính chuỗi ngày liên tục có tạo Cards
  Future<int> getDayStreak() async {
    final db = await _appDatabase.database;
    final result = await db.rawQuery('''
      SELECT DISTINCT date(created_at, 'unixepoch', 'localtime') as day
      FROM Cards
      ORDER BY day DESC
    ''');

    if (result.isEmpty) return 0;

    int streak = 0;
    final now = DateTime.now();
    var checkDate = DateTime(now.year, now.month, now.day);

    for (final row in result) {
      final dayStr = row['day'] as String;
      final parts = dayStr.split('-');
      final rowDate = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );

      if (rowDate == checkDate) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (rowDate.isBefore(checkDate)) {
        break;
      }
    }

    return streak;
  }

  /// Đếm tổng số Cards
  Future<int> getTotalWordsSaved() async {
    final db = await _appDatabase.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM Cards');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Lấy danh sách Cards cần ôn (next_review_ts <= now)
  Future<List<Map<String, dynamic>>> getDueForReviewWords() async {
    final db = await _appDatabase.database;
    final nowTs = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return db.query(
      'Cards',
      columns: ['card_id', 'word', 'ipa', 'meaning'],
      where: 'next_review_ts <= ? AND is_archived = 0',
      whereArgs: [nowTs],
      limit: 10,
    );
  }

  /// Lấy danh sách Topics
  Future<List<Map<String, dynamic>>> getTopics() async {
    final db = await _appDatabase.database;
    final topics = await db.query('Topics', orderBy: 'created_at DESC');
    return [
      ...topics,
      {
        'topic_id': -1,
        'name': 'Khác',
        'color_hex': '#5B657A',
        'is_default': 1,
        'created_at': 0,
      }
    ];
  }
}
