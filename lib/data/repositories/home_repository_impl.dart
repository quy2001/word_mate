import 'package:word_mate/data/data_sources/local/home_dao.dart';
import 'package:word_mate/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDao _dao;

  HomeRepositoryImpl(this._dao);

  @override
  Future<int> getTodayLearnedCount() => _dao.getTodayLearnedCount();

  @override
  Future<int> getDayStreak() => _dao.getDayStreak();

  @override
  Future<int> getTotalWordsSaved() => _dao.getTotalWordsSaved();

  @override
  Future<List<Map<String, dynamic>>> getDueForReviewWords() => _dao.getDueForReviewWords();

  @override
  Future<List<Map<String, dynamic>>> getTopics() => _dao.getTopics();
}
