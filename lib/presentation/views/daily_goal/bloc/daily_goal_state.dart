import 'package:equatable/equatable.dart';

enum DailyGoalStatus { initial, submitting, success, failure }

class DailyGoalState extends Equatable {
  final int goal;
  final DailyGoalStatus status;

  const DailyGoalState({
    this.goal = 10,
    this.status = DailyGoalStatus.initial,
  });

  DailyGoalState copyWith({
    int? goal,
    DailyGoalStatus? status,
  }) {
    return DailyGoalState(
      goal: goal ?? this.goal,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [goal, status];
}
