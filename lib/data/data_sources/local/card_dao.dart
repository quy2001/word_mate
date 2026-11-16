import 'package:sqflite/sqflite.dart';
import 'package:word_mate/data/data_sources/local/app_database.dart';

class CardDao {
  final AppDatabase _appDatabase;

  CardDao(this._appDatabase);

  /// Insert a new card into the database
  Future<int> insertCard(Map<String, dynamic> cardData) async {
    final db = await _appDatabase.database;
    return db.insert('Cards', cardData);
  }

  /// Get all topics
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

  /// Insert a new topic
  Future<int> insertTopic(Map<String, dynamic> topicData) async {
    final db = await _appDatabase.database;
    return db.insert('Topics', topicData);
  }

  /// Get topics with word counts and search filter
  Future<List<Map<String, dynamic>>> getTopicsWithWordCount({String? searchQuery}) async {
    final db = await _appDatabase.database;
    List<Map<String, dynamic>> result;
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      result = await db.rawQuery('''
        SELECT T.*, COUNT(C.card_id) as word_count 
        FROM Topics T 
        LEFT JOIN Cards C ON T.topic_id = C.topic_id 
        WHERE T.name LIKE ?
        GROUP BY T.topic_id 
        ORDER BY T.created_at DESC
      ''', ['%${searchQuery.trim()}%']);
    } else {
      result = await db.rawQuery('''
        SELECT T.*, COUNT(C.card_id) as word_count 
        FROM Topics T 
        LEFT JOIN Cards C ON T.topic_id = C.topic_id 
        GROUP BY T.topic_id 
        ORDER BY T.created_at DESC
      ''');
    }

    // Check if we should include "Khác" / "Other"
    bool includeKhac = true;
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      if (!'khác'.contains(q) && !'other'.contains(q)) {
        includeKhac = false;
      }
    }

    if (includeKhac) {
      final nullCountResult = await db.rawQuery('SELECT COUNT(*) as word_count FROM Cards WHERE topic_id IS NULL AND is_archived = 0');
      final nullCount = Sqflite.firstIntValue(nullCountResult) ?? 0;
      
      return [
        ...result,
        {
          'topic_id': -1,
          'name': 'Khác',
          'color_hex': '#5B657A',
          'is_default': 1,
          'created_at': 0,
          'word_count': nullCount,
        }
      ];
    }
    
    return result;
  }

  /// Delete a topic by id
  Future<int> deleteTopic(int topicId) async {
    final db = await _appDatabase.database;
    return db.delete('Topics', where: 'topic_id = ?', whereArgs: [topicId]);
  }

  /// Get cards by topic_id (or all if null) and optional search query
  Future<List<Map<String, dynamic>>> getCards({int? topicId, String? searchQuery}) async {
    final db = await _appDatabase.database;
    String whereClause = 'is_archived = 0';
    List<dynamic> whereArgs = [];

    if (topicId != null) {
      if (topicId == -1) {
        whereClause += ' AND topic_id IS NULL';
      } else {
        whereClause += ' AND topic_id = ?';
        whereArgs.add(topicId);
      }
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      whereClause += ' AND (word LIKE ? OR meaning LIKE ?)';
      final cleanSearch = '%${searchQuery.trim()}%';
      whereArgs.add(cleanSearch);
      whereArgs.add(cleanSearch);
    }

    return db.query(
      'Cards',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'created_at DESC',
    );
  }

  /// Get a single card by card_id
  Future<Map<String, dynamic>?> getCardById(int cardId) async {
    final db = await _appDatabase.database;
    final result = await db.query(
      'Cards',
      where: 'card_id = ? AND is_archived = 0',
      whereArgs: [cardId],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  /// Delete a card by card_id (Soft delete or hard delete? The schema has `is_archived` which could be used for soft delete. Let's do a hard delete as it might be simpler, or soft delete by setting `is_archived = 1`. The request asks for delete, I'll do a hard delete for now.)
  Future<int> deleteCard(int cardId) async {
    final db = await _appDatabase.database;
    return db.delete('Cards', where: 'card_id = ?', whereArgs: [cardId]);
  }

  /// Update an existing card
  Future<int> updateCard(int cardId, Map<String, dynamic> cardData) async {
    final db = await _appDatabase.database;
    return db.update(
      'Cards',
      cardData,
      where: 'card_id = ?',
      whereArgs: [cardId],
    );
  }

  /// Get cards due for review (next_review_ts <= now)
  Future<List<Map<String, dynamic>>> getDueForReviewCards({int limit = 50}) async {
    final db = await _appDatabase.database;
    final nowTs = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return db.query(
      'Cards',
      where: 'next_review_ts <= ? AND is_archived = 0',
      whereArgs: [nowTs],
      orderBy: 'next_review_ts ASC',
      limit: limit,
    );
  }

  /// Record SM-2 review progress
  Future<void> reviewCard({
    required int cardId,
    required int rating, // 0 - 5
    int durationMs = 0,
  }) async {
    final db = await _appDatabase.database;
    final card = await getCardById(cardId);
    if (card == null) return;

    final nowTs = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    int streak = (card['streak'] as int?) ?? 0;
    int intervalDays = (card['interval_days'] as int?) ?? 0;
    double easinessFactor = ((card['easiness_factor'] as num?) ?? 2.5).toDouble();

    // SM-2 Spaced Repetition calculation
    if (rating >= 3) {
      if (streak == 0) {
        intervalDays = 1;
      } else if (streak == 1) {
        intervalDays = 6;
      } else {
        intervalDays = (intervalDays * easinessFactor).round();
      }
      streak += 1;
    } else {
      streak = 0;
      intervalDays = 1;
    }

    // New EF = EF + (0.1 - (5 - rating) * (0.08 + (5 - rating) * 0.02))
    easinessFactor = easinessFactor + (0.1 - (5 - rating) * (0.08 + (5 - rating) * 0.02));
    if (easinessFactor < 1.3) easinessFactor = 1.3;

    final nextReviewTs = nowTs + (intervalDays * 86400);

    await db.transaction((txn) async {
      await txn.update(
        'Cards',
        {
          'streak': streak,
          'interval_days': intervalDays,
          'easiness_factor': easinessFactor,
          'next_review_ts': nextReviewTs,
        },
        where: 'card_id = ?',
        whereArgs: [cardId],
      );

      await txn.insert('ReviewHistory', {
        'card_id': cardId,
        'review_ts': nowTs,
        'rating': rating,
        'duration_ms': durationMs,
      });
    });
  }
}
