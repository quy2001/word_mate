import 'package:dio/dio.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/core/usecase.dart';
import 'package:word_mate/domain/repositories/app_settings_repository.dart';

class SaveUserProfileUseCase implements UseCase<void, SaveUserProfileParams> {
  final AppSettingsRepository _repository;

  SaveUserProfileUseCase(this._repository);

  @override
  Future<DataState<void>> call(SaveUserProfileParams params) async {
    try {
      await _repository.saveNickname(params.nickname);
      await _repository.saveAvatar(params.avatarPath);
      return const DataSuccess(null);
    } on DioException catch (e) {
      return DataFail(e);
    } catch (e) {
      return DataFail(DioException(requestOptions: RequestOptions(path: ''), error: e));
    }
  }
}

class SaveUserProfileParams {
  final String nickname;
  final String avatarPath;

  SaveUserProfileParams({required this.nickname, required this.avatarPath});
}
