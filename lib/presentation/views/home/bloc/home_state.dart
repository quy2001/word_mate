import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final String nickname;
  final String? avatarPath;
  final int dailyGoal;
  final int todayLearnedCount;
  final int dayStreak;
  final int totalWordsSaved;
  final List<Map<String, dynamic>> dueForReviewWords;
  final List<Map<String, dynamic>> topics;

  const HomeState({
    this.status = HomeStatus.initial,
    this.nickname = 'User',
    this.avatarPath,
    this.dailyGoal = 10,
    this.todayLearnedCount = 0,
    this.dayStreak = 0,
    this.totalWordsSaved = 0,
    this.dueForReviewWords = const [],
    this.topics = const [],
  });

  HomeState copyWith({
    HomeStatus? status,
    String? nickname,
    String? avatarPath,
    int? dailyGoal,
    int? todayLearnedCount,
    int? dayStreak,
    int? totalWordsSaved,
    List<Map<String, dynamic>>? dueForReviewWords,
    List<Map<String, dynamic>>? topics,
  }) {
    return HomeState(
      status: status ?? this.status,
      nickname: nickname ?? this.nickname,
      avatarPath: avatarPath ?? this.avatarPath,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      todayLearnedCount: todayLearnedCount ?? this.todayLearnedCount,
      dayStreak: dayStreak ?? this.dayStreak,
      totalWordsSaved: totalWordsSaved ?? this.totalWordsSaved,
      dueForReviewWords: dueForReviewWords ?? this.dueForReviewWords,
      topics: topics ?? this.topics,
    );
  }

  @override
  List<Object?> get props => [
        status,
        nickname,
        avatarPath,
        dailyGoal,
        todayLearnedCount,
        dayStreak,
        totalWordsSaved,
        dueForReviewWords,
        topics,
      ];
}
