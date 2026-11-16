import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';
import 'flash_card_event.dart';
import 'flash_card_state.dart';

class FlashCardBloc extends Bloc<FlashCardEvent, FlashCardState> {
  final CardRepository _cardRepository;

  FlashCardBloc(this._cardRepository) : super(const FlashCardState()) {
    on<LoadFlashCards>(_onLoadFlashCards);
    on<SwipeCardEvent>(_onSwipeCard);
    on<UndoSwipeEvent>(_onUndoSwipe);
    on<FlipCardEvent>(_onFlipCard);
  }

  Future<void> _onLoadFlashCards(LoadFlashCards event, Emitter<FlashCardState> emit) async {
    emit(state.copyWith(status: FlashCardStatus.loading));
    try {
      final List<Map<String, dynamic>> cards;
      if (event.isReviewMode) {
        cards = await _cardRepository.getDueForReviewCards();
      } else {
        cards = await _cardRepository.getCards(topicId: event.topicId);
      }
      if (cards.isEmpty) {
        emit(state.copyWith(status: FlashCardStatus.finished, cards: [], swipeHistory: []));
      } else {
        emit(state.copyWith(
          status: FlashCardStatus.loaded,
          cards: cards,
          currentIndex: 0,
          isFlipped: false,
          swipeHistory: [],
        ));
      }
    } catch (_) {
      emit(state.copyWith(status: FlashCardStatus.error));
    }
  }

  void _onSwipeCard(SwipeCardEvent event, Emitter<FlashCardState> emit) {
    if (state.currentIndex < state.cards.length) {
      final currentCard = state.cards[state.currentIndex];
      final cardId = currentCard['card_id'] as int?;
      if (cardId != null) {
        // SM-2 rating: 4 for Known (Good), 1 for Unknown (Again)
        final rating = event.isKnown ? 4 : 1;
        _cardRepository.reviewCard(cardId: cardId, rating: rating);
      }
    }

    final newHistory = List<bool>.from(state.swipeHistory)..add(event.isKnown);
    if (state.currentIndex >= state.cards.length - 1) {
      emit(state.copyWith(
        status: FlashCardStatus.finished, 
        currentIndex: state.currentIndex + 1,
        swipeHistory: newHistory,
      ));
    } else {
      emit(state.copyWith(
        currentIndex: state.currentIndex + 1,
        isFlipped: false, // Reset flip state for the next card
        swipeHistory: newHistory,
      ));
    }
  }

  void _onUndoSwipe(UndoSwipeEvent event, Emitter<FlashCardState> emit) {
    if (state.currentIndex > 0) {
      final newHistory = List<bool>.from(state.swipeHistory)..removeLast();
      emit(state.copyWith(
        status: FlashCardStatus.loaded,
        currentIndex: state.currentIndex - 1,
        isFlipped: false,
        swipeHistory: newHistory,
      ));
    }
  }

  void _onFlipCard(FlipCardEvent event, Emitter<FlashCardState> emit) {
    emit(state.copyWith(isFlipped: !state.isFlipped));
  }
}
