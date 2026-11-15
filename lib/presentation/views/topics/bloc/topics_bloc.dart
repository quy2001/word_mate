import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';
import 'package:word_mate/domain/usecases/get_topics_usecase.dart';
import 'package:word_mate/presentation/views/topics/bloc/topics_event.dart';
import 'package:word_mate/presentation/views/topics/bloc/topics_state.dart';

class TopicsBloc extends Bloc<TopicsEvent, TopicsState> {
  final GetTopicsUseCase _getTopicsUseCase;
  final CardRepository _cardRepository;

  TopicsBloc(this._getTopicsUseCase, this._cardRepository)
      : super(const TopicsState()) {
    on<LoadTopicsEvent>(_onLoadTopics);
    on<SearchTopicsEvent>(_onSearchTopics);
    on<AddTopicEvent>(_onAddTopic);
    on<DeleteTopicEvent>(_onDeleteTopic);
  }

  Future<void> _onLoadTopics(
      LoadTopicsEvent event, Emitter<TopicsState> emit) async {
    emit(state.copyWith(status: TopicsStatus.loading));
    final result = await _getTopicsUseCase(state.searchQuery);
    if (result is DataSuccess) {
      emit(state.copyWith(
        status: TopicsStatus.loaded,
        topics: result.data,
      ));
    } else {
      emit(state.copyWith(status: TopicsStatus.error));
    }
  }

  Future<void> _onSearchTopics(
      SearchTopicsEvent event, Emitter<TopicsState> emit) async {
    emit(state.copyWith(searchQuery: event.query, status: TopicsStatus.loading));
    final result = await _getTopicsUseCase(event.query);
    if (result is DataSuccess) {
      emit(state.copyWith(
        status: TopicsStatus.loaded,
        topics: result.data,
      ));
    } else {
      emit(state.copyWith(status: TopicsStatus.error));
    }
  }

  Future<void> _onAddTopic(
      AddTopicEvent event, Emitter<TopicsState> emit) async {
    if (event.name.trim().isEmpty) return;
    try {
      await _cardRepository.addTopic(
        name: event.name.trim(),
        colorHex: event.colorHex,
      );
      // Reload topics list
      final result = await _getTopicsUseCase(state.searchQuery);
      if (result is DataSuccess) {
        emit(state.copyWith(
          status: TopicsStatus.loaded,
          topics: result.data,
        ));
      }
    } catch (_) {
      // Ignore adding topic error
    }
  }

  Future<void> _onDeleteTopic(
      DeleteTopicEvent event, Emitter<TopicsState> emit) async {
    try {
      await _cardRepository.deleteTopic(event.topicId);
      // Reload topics list
      final result = await _getTopicsUseCase(state.searchQuery);
      if (result is DataSuccess) {
        emit(state.copyWith(
          status: TopicsStatus.loaded,
          topics: result.data,
        ));
      }
    } catch (_) {
      // Ignore error
    }
  }
}
