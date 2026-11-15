import 'package:word_mate/domain/repositories/app_settings_repository.dart';
import 'package:word_mate/domain/repositories/home_repository.dart';

class HomeData {
  final String nickname;
  final String? avatarPath;
  final int dailyGoal;
  final int todayLearnedCount;
  final int dayStreak;
  final int totalWordsSaved;
  final List<Map<String, dynamic>> dueForReviewWords;
  final List<Map<String, dynamic>> topics;

  HomeData({
    required this.nickname,
    this.avatarPath,
    required this.dailyGoal,
    required this.todayLearnedCount,
    required this.dayStreak,
    required this.totalWordsSaved,
    required this.dueForReviewWords,
    required this.topics,
  });
}

class GetHomeDataUseCase {
  final HomeRepository _homeRepository;
  final AppSettingsRepository _settingsRepository;

  GetHomeDataUseCase(this._homeRepository, this._settingsRepository);

  Future<HomeData> call() async {
    final results = await Future.wait([
      _settingsRepository.getNickname(),
      _settingsRepository.getAvatar(),
      _settingsRepository.getDailyGoal(),
      _homeRepository.getTodayLearnedCount(),
      _homeRepository.getDayStreak(),
      _homeRepository.getTotalWordsSaved(),
      _homeRepository.getDueForReviewWords(),
      _homeRepository.getTopics(),
    ]);

    return HomeData(
      nickname: (results[0] as String?) ?? 'User',
      avatarPath: results[1] as String?,
      dailyGoal: (results[2] as int?) ?? 10,
      todayLearnedCount: results[3] as int,
      dayStreak: results[4] as int,
      totalWordsSaved: results[5] as int,
      dueForReviewWords: results[6] as List<Map<String, dynamic>>,
      topics: results[7] as List<Map<String, dynamic>>,
    );
  }
}
