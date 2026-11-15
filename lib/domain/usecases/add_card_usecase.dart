import 'package:dio/dio.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/core/usecase.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';

class AddCardUseCase implements UseCase<int, AddCardParams> {
  final CardRepository _repository;

  AddCardUseCase(this._repository);

  @override
  Future<DataState<int>> call(AddCardParams params) async {
    try {
      final id = await _repository.addCard(
        word: params.word,
        meaning: params.meaning,
        type: params.type,
        topicId: params.topicId,
        ipa: params.ipa,
        audioPath: params.audioPath,
        example: params.example,
      );
      return DataSuccess(id);
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

class AddCardParams {
  final String word;
  final String meaning;
  final String? type;
  final int? topicId;
  final String? ipa;
  final String? audioPath;
  final String? example;

  AddCardParams({
    required this.word,
    required this.meaning,
    this.type,
    this.topicId,
    this.ipa,
    this.audioPath,
    this.example,
  });
}
