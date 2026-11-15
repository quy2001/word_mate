abstract class HomeRepository {
  Future<int> getTodayLearnedCount();
  Future<int> getDayStreak();
  Future<int> getTotalWordsSaved();
  Future<List<Map<String, dynamic>>> getDueForReviewWords();
  Future<List<Map<String, dynamic>>> getTopics();
}
