import 'package:word_mate/data/data_sources/local/card_dao.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';

class CardRepositoryImpl implements CardRepository {
  final CardDao _dao;

  CardRepositoryImpl(this._dao);

  @override
  Future<int> addCard({
    required String word,
    required String meaning,
    String? type,
    int? topicId,
    String? ipa,
    String? audioPath,
    String? example,
  }) {
    final nowTs = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return _dao.insertCard({
      'word': word,
      'meaning': meaning,
      'type': type,
      'topic_id': topicId,
      'ipa': ipa,
      'audio_path': audioPath,
      'example': example,
      'created_at': nowTs,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getTopics() {
    return _dao.getTopics();
  }

  @override
  Future<int> addTopic({required String name, String? colorHex}) {
    final nowTs = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return _dao.insertTopic({
      'name': name,
      'created_at': nowTs,
      if (colorHex != null) 'color_hex': colorHex,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getTopicsWithWordCount({String? searchQuery}) {
    return _dao.getTopicsWithWordCount(searchQuery: searchQuery);
  }

  @override
  Future<int> deleteTopic(int topicId) {
    return _dao.deleteTopic(topicId);
  }

  @override
  Future<List<Map<String, dynamic>>> getCards({int? topicId, String? searchQuery}) {
    return _dao.getCards(topicId: topicId, searchQuery: searchQuery);
  }

  @override
  Future<Map<String, dynamic>?> getCardById(int cardId) {
    return _dao.getCardById(cardId);
  }

  @override
  Future<int> deleteCard(int cardId) {
    return _dao.deleteCard(cardId);
  }
}
