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

    // Check if we should include "Khác"
    bool includeKhac = true;
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      if (!'khác'.contains(searchQuery.trim().toLowerCase())) {
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
}
