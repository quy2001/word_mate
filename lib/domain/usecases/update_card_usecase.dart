import 'package:dio/dio.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/core/usecase.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';

class UpdateCardUseCase implements UseCase<int, UpdateCardParams> {
  final CardRepository _repository;

  UpdateCardUseCase(this._repository);

  @override
  Future<DataState<int>> call(UpdateCardParams params) async {
    try {
      final rows = await _repository.updateCard(
        cardId: params.cardId,
        word: params.word,
        meaning: params.meaning,
        type: params.type,
        topicId: params.topicId,
        ipa: params.ipa,
        audioPath: params.audioPath,
        example: params.example,
      );
      return DataSuccess(rows);
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

class UpdateCardParams {
  final int cardId;
  final String word;
  final String meaning;
  final String? type;
  final int? topicId;
  final String? ipa;
  final String? audioPath;
  final String? example;

  UpdateCardParams({
    required this.cardId,
    required this.word,
    required this.meaning,
    this.type,
    this.topicId,
    this.ipa,
    this.audioPath,
    this.example,
  });
}
