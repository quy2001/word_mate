abstract class CardRepository {
  Future<int> addCard({
    required String word,
    required String meaning,
    String? type,
    int? topicId,
    String? ipa,
    String? audioPath,
    String? example,
  });
  Future<List<Map<String, dynamic>>> getTopics();
  Future<int> addTopic({required String name, String? colorHex});
  Future<List<Map<String, dynamic>>> getTopicsWithWordCount({String? searchQuery});
  Future<int> deleteTopic(int topicId);
  Future<List<Map<String, dynamic>>> getCards({int? topicId, String? searchQuery});
  Future<Map<String, dynamic>?> getCardById(int cardId);
  Future<int> deleteCard(int cardId);
  Future<int> updateCard({
    required int cardId,
    required String word,
    required String meaning,
    String? type,
    int? topicId,
    String? ipa,
    String? audioPath,
    String? example,
  });
  Future<List<Map<String, dynamic>>> getDueForReviewCards({int limit = 50});
  Future<void> reviewCard({
    required int cardId,
    required int rating,
    int durationMs = 0,
  });
}
