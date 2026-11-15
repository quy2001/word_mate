import 'package:equatable/equatable.dart';

abstract class DailyGoalEvent extends Equatable {
  const DailyGoalEvent();

  @override
  List<Object?> get props => [];
}

class IncreaseGoalEvent extends DailyGoalEvent {}

class DecreaseGoalEvent extends DailyGoalEvent {}

class SelectGoalEvent extends DailyGoalEvent {
  final int goal;

  const SelectGoalEvent(this.goal);

  @override
  List<Object?> get props => [goal];
}

class SubmitGoalEvent extends DailyGoalEvent {}
