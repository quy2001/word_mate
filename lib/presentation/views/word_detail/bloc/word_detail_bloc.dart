import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';
import 'word_detail_event.dart';
import 'word_detail_state.dart';

class WordDetailBloc extends Bloc<WordDetailEvent, WordDetailState> {
  final CardRepository _cardRepository;

  WordDetailBloc(this._cardRepository) : super(const WordDetailState()) {
    on<LoadWordDetailEvent>(_onLoadWordDetail);
    on<DeleteWordEvent>(_onDeleteWord);
  }

  Future<void> _onLoadWordDetail(LoadWordDetailEvent event, Emitter<WordDetailState> emit) async {
    emit(state.copyWith(status: WordDetailStatus.loading));
    try {
      final cardData = await _cardRepository.getCardById(event.cardId);
      if (cardData != null) {
        emit(state.copyWith(status: WordDetailStatus.success, cardData: cardData));
      } else {
        emit(state.copyWith(status: WordDetailStatus.failure, errorMessage: 'Card not found'));
      }
    } catch (e) {
      emit(state.copyWith(status: WordDetailStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteWord(DeleteWordEvent event, Emitter<WordDetailState> emit) async {
    emit(state.copyWith(status: WordDetailStatus.loading));
    try {
      await _cardRepository.deleteCard(event.cardId);
      emit(state.copyWith(status: WordDetailStatus.deleted));
    } catch (e) {
      emit(state.copyWith(status: WordDetailStatus.failure, errorMessage: e.toString()));
    }
  }
}
