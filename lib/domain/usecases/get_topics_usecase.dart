import 'package:dio/dio.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/core/usecase.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';

class GetTopicsUseCase implements UseCase<List<Map<String, dynamic>>, String?> {
  final CardRepository _repository;

  GetTopicsUseCase(this._repository);

  @override
  Future<DataState<List<Map<String, dynamic>>>> call(String? params) async {
    try {
      final topics = await _repository.getTopicsWithWordCount(searchQuery: params);
      return DataSuccess(topics);
    } on DioException catch (e) {
      return DataFail(e);
    } catch (e) {
      return DataFail(DioException(
        requestOptions: RequestOptions(path: ''),
        error: e,
      ));
    }
  }
}
