import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/domain/usecases/get_stats_usecase.dart';
import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetStatsUseCase _getStatsUseCase;

  StatsBloc(this._getStatsUseCase) : super(const StatsState()) {
    on<LoadStatsEvent>(_onLoadStats);
  }

  Future<void> _onLoadStats(LoadStatsEvent event, Emitter<StatsState> emit) async {
    emit(state.copyWith(status: StatsStatus.loading));
    try {
      final stats = await _getStatsUseCase();
      emit(state.copyWith(
        status: StatsStatus.loaded,
        totalWords: stats['totalWords'] as int,
        masteredWords: stats['masteredWords'] as int,
        learningWords: stats['learningWords'] as int,
        dueWords: stats['dueWords'] as int,
        totalReviews: stats['totalReviews'] as int,
        accuracy: (stats['accuracy'] as num).toDouble(),
        weeklyActivity: stats['weeklyActivity'] as List<Map<String, dynamic>>,
        dayStreak: stats['dayStreak'] as int,
      ));
    } catch (_) {
      emit(state.copyWith(status: StatsStatus.error));
    }
  }
}
