import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/domain/usecases/save_daily_goal_usecase.dart';
import 'package:word_mate/presentation/views/daily_goal/bloc/daily_goal_event.dart';
import 'package:word_mate/presentation/views/daily_goal/bloc/daily_goal_state.dart';

class DailyGoalBloc extends Bloc<DailyGoalEvent, DailyGoalState> {
  final SaveDailyGoalUseCase _saveDailyGoalUseCase;
  static const int minGoal = 5;

  DailyGoalBloc(this._saveDailyGoalUseCase) : super(const DailyGoalState()) {
    on<IncreaseGoalEvent>(_onIncreaseGoal);
    on<DecreaseGoalEvent>(_onDecreaseGoal);
    on<SelectGoalEvent>(_onSelectGoal);
    on<SubmitGoalEvent>(_onSubmitGoal);
  }

  void _onIncreaseGoal(IncreaseGoalEvent event, Emitter<DailyGoalState> emit) {
    emit(state.copyWith(goal: state.goal + 5));
  }

  void _onDecreaseGoal(DecreaseGoalEvent event, Emitter<DailyGoalState> emit) {
    if (state.goal > minGoal) {
      emit(state.copyWith(goal: state.goal - 5));
    }
  }

  void _onSelectGoal(SelectGoalEvent event, Emitter<DailyGoalState> emit) {
    if (event.goal >= minGoal) {
      emit(state.copyWith(goal: event.goal));
    }
  }

  Future<void> _onSubmitGoal(SubmitGoalEvent event, Emitter<DailyGoalState> emit) async {
    emit(state.copyWith(status: DailyGoalStatus.submitting));
    try {
      final result = await _saveDailyGoalUseCase(SaveDailyGoalParams(goal: state.goal));
      if (result is DataSuccess) {
        emit(state.copyWith(status: DailyGoalStatus.success));
      } else {
        emit(state.copyWith(status: DailyGoalStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(status: DailyGoalStatus.failure));
    }
  }
}
