import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';
import 'topic_words_event.dart';
import 'topic_words_state.dart';

class TopicWordsBloc extends Bloc<TopicWordsEvent, TopicWordsState> {
  final CardRepository _cardRepository;

  TopicWordsBloc(this._cardRepository) : super(const TopicWordsState()) {
    on<InitTopicWordsEvent>(_onInit);
    on<SelectTopicTabEvent>(_onSelectTopicTab);
    on<SearchWordsEvent>(_onSearchWords);
    on<RefreshWordsEvent>(_onRefreshWords);
  }

  Future<void> _onInit(InitTopicWordsEvent event, Emitter<TopicWordsState> emit) async {
    emit(state.copyWith(status: TopicWordsStatus.loading, selectedTopicId: event.initialTopicId));
    try {
      final topics = await _cardRepository.getTopics();
      final cards = await _cardRepository.getCards(
        topicId: event.initialTopicId,
        searchQuery: state.searchQuery,
      );
      emit(state.copyWith(
        status: TopicWordsStatus.loaded,
        topics: topics,
        cards: cards,
      ));
    } catch (_) {
      emit(state.copyWith(status: TopicWordsStatus.error));
    }
  }

  Future<void> _onSelectTopicTab(SelectTopicTabEvent event, Emitter<TopicWordsState> emit) async {
    emit(state.copyWith(
      status: TopicWordsStatus.loading,
      selectedTopicId: event.topicId,
      clearSelectedTopicId: event.topicId == null,
    ));
    try {
      final cards = await _cardRepository.getCards(
        topicId: event.topicId,
        searchQuery: state.searchQuery,
      );
      emit(state.copyWith(
        status: TopicWordsStatus.loaded,
        cards: cards,
      ));
    } catch (_) {
      emit(state.copyWith(status: TopicWordsStatus.error));
    }
  }

  Future<void> _onSearchWords(SearchWordsEvent event, Emitter<TopicWordsState> emit) async {
    emit(state.copyWith(status: TopicWordsStatus.loading, searchQuery: event.query));
    try {
      final cards = await _cardRepository.getCards(
        topicId: state.selectedTopicId,
        searchQuery: event.query,
      );
      emit(state.copyWith(
        status: TopicWordsStatus.loaded,
        cards: cards,
      ));
    } catch (_) {
      emit(state.copyWith(status: TopicWordsStatus.error));
    }
  }

  Future<void> _onRefreshWords(RefreshWordsEvent event, Emitter<TopicWordsState> emit) async {
    try {
      final cards = await _cardRepository.getCards(
        topicId: state.selectedTopicId,
        searchQuery: state.searchQuery,
      );
      emit(state.copyWith(
        status: TopicWordsStatus.loaded,
        cards: cards,
      ));
    } catch (_) {
      // ignore
    }
  }
}
