import 'package:dio/dio.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/core/usecase.dart';
import 'package:word_mate/domain/repositories/app_settings_repository.dart';

class SaveDailyGoalUseCase implements UseCase<void, SaveDailyGoalParams> {
  final AppSettingsRepository _repository;

  SaveDailyGoalUseCase(this._repository);

  @override
  Future<DataState<void>> call(SaveDailyGoalParams params) async {
    try {
      await _repository.saveDailyGoal(params.goal);
      return const DataSuccess(null);
    } on DioException catch (e) {
      return DataFail(e);
    } catch (e) {
      return DataFail(DioException(requestOptions: RequestOptions(path: ''), error: e));
    }
  }
}

class SaveDailyGoalParams {
  final int goal;

  SaveDailyGoalParams({required this.goal});
}
