import 'package:dio/dio.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/core/usecase.dart';
import 'package:word_mate/data/models/dictionary_entry_model.dart';
import 'package:word_mate/domain/repositories/dictionary_repository.dart';

class FetchWordDetailsUseCase implements UseCase<List<DictionaryEntryModel>, String> {
  final DictionaryRepository _repository;

  FetchWordDetailsUseCase(this._repository);

  @override
  Future<DataState<List<DictionaryEntryModel>>> call(String word) async {
    try {
      final result = await _repository.fetchWordDetails(word);
      return DataSuccess(result);
    } on DioException catch (e) {
      return DataFail(e);
    } catch (e) {
      return DataFail(DioException(requestOptions: RequestOptions(path: ''), error: e));
    }
  }
}
