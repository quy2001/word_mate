import 'package:equatable/equatable.dart';

enum StatsStatus { initial, loading, loaded, error }

class StatsState extends Equatable {
  final StatsStatus status;
  final int totalWords;
  final int masteredWords;
  final int learningWords;
  final int dueWords;
  final int totalReviews;
  final double accuracy;
  final List<Map<String, dynamic>> weeklyActivity;
  final int dayStreak;

  const StatsState({
    this.status = StatsStatus.initial,
    this.totalWords = 0,
    this.masteredWords = 0,
    this.learningWords = 0,
    this.dueWords = 0,
    this.totalReviews = 0,
    this.accuracy = 0.0,
    this.weeklyActivity = const [],
    this.dayStreak = 0,
  });

  StatsState copyWith({
    StatsStatus? status,
    int? totalWords,
    int? masteredWords,
    int? learningWords,
    int? dueWords,
    int? totalReviews,
    double? accuracy,
    List<Map<String, dynamic>>? weeklyActivity,
    int? dayStreak,
  }) {
    return StatsState(
      status: status ?? this.status,
      totalWords: totalWords ?? this.totalWords,
      masteredWords: masteredWords ?? this.masteredWords,
      learningWords: learningWords ?? this.learningWords,
      dueWords: dueWords ?? this.dueWords,
      totalReviews: totalReviews ?? this.totalReviews,
      accuracy: accuracy ?? this.accuracy,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      dayStreak: dayStreak ?? this.dayStreak,
    );
  }

  @override
  List<Object?> get props => [
        status,
        totalWords,
        masteredWords,
        learningWords,
        dueWords,
        totalReviews,
        accuracy,
        weeklyActivity,
        dayStreak,
      ];
}
