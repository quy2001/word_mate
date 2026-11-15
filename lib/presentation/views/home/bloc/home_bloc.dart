import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/domain/usecases/get_home_data_usecase.dart';
import 'package:word_mate/presentation/views/home/bloc/home_event.dart';
import 'package:word_mate/presentation/views/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;

  HomeBloc(this._getHomeDataUseCase) : super(const HomeState()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(LoadHomeDataEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final data = await _getHomeDataUseCase();
      emit(state.copyWith(
        status: HomeStatus.loaded,
        nickname: data.nickname,
        avatarPath: data.avatarPath,
        dailyGoal: data.dailyGoal,
        todayLearnedCount: data.todayLearnedCount,
        dayStreak: data.dayStreak,
        totalWordsSaved: data.totalWordsSaved,
        dueForReviewWords: data.dueForReviewWords,
        topics: data.topics,
      ));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.error));
    }
  }
}
