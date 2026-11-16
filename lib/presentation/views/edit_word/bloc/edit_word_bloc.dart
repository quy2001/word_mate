import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';
import 'package:word_mate/domain/usecases/fetch_word_details_usecase.dart';
import 'package:word_mate/domain/usecases/update_card_usecase.dart';
import 'edit_word_event.dart';
import 'edit_word_state.dart';

class EditWordBloc extends Bloc<EditWordEvent, EditWordState> {
  final UpdateCardUseCase _updateCardUseCase;
  final CardRepository _cardRepository;
  final FetchWordDetailsUseCase _fetchWordDetailsUseCase;

  EditWordBloc(
    this._updateCardUseCase,
    this._cardRepository,
    this._fetchWordDetailsUseCase,
  ) : super(const EditWordState()) {
    on<InitEditWordEvent>(_onInit);
    on<UpdateEditWordTextEvent>(_onUpdateWord);
    on<UpdateEditMeaningTextEvent>(_onUpdateMeaning);
    on<SelectEditWordTypeEvent>(_onSelectType);
    on<SelectEditTopicEvent>(_onSelectTopic);
    on<SubmitEditWordEvent>(_onSubmit);
  }

  Future<void> _onInit(InitEditWordEvent event, Emitter<EditWordState> emit) async {
    emit(state.copyWith(status: EditWordStatus.loading));
    try {
      final topics = await _cardRepository.getTopics();
      final card = event.cardData;
      emit(state.copyWith(
        status: EditWordStatus.initial,
        cardId: (card['card_id'] as int?) ?? 0,
        word: (card['word'] as String?) ?? '',
        meaning: (card['meaning'] as String?) ?? '',
        selectedType: card['type'] as String?,
        selectedTopicId: card['topic_id'] as int?,
        ipa: card['ipa'] as String?,
        audioPath: card['audio_path'] as String?,
        example: card['example'] as String?,
        topics: topics,
      ));
    } catch (_) {
      emit(state.copyWith(status: EditWordStatus.initial));
    }
  }

  void _onUpdateWord(UpdateEditWordTextEvent event, Emitter<EditWordState> emit) {
    emit(state.copyWith(word: event.word));
  }

  void _onUpdateMeaning(UpdateEditMeaningTextEvent event, Emitter<EditWordState> emit) {
    emit(state.copyWith(meaning: event.meaning));
  }

  void _onSelectType(SelectEditWordTypeEvent event, Emitter<EditWordState> emit) {
    if (state.selectedType == event.type) {
      emit(state.copyWith(selectedType: null));
    } else {
      emit(state.copyWith(selectedType: event.type));
    }
  }

  void _onSelectTopic(SelectEditTopicEvent event, Emitter<EditWordState> emit) {
    if (state.selectedTopicId == event.topicId) {
      emit(state.copyWith(clearTopicId: true));
    } else {
      emit(state.copyWith(selectedTopicId: event.topicId));
    }
  }

  Future<void> _onSubmit(SubmitEditWordEvent event, Emitter<EditWordState> emit) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: EditWordStatus.submitting));

    String ipa = state.ipa ?? '';
    String audioPath = state.audioPath ?? '';
    String example = state.example ?? '';

    // If IPA or Audio is missing, try fetching from Dictionary API
    if (ipa.isEmpty || audioPath.isEmpty) {
      try {
        final apiResult = await _fetchWordDetailsUseCase(state.word.trim());
        if (apiResult is DataSuccess && apiResult.data != null && apiResult.data!.isNotEmpty) {
          final entry = apiResult.data!.first;
          if (entry.phonetics.isNotEmpty) {
            final phoneticWithAudio = entry.phonetics.firstWhere(
              (p) => p.audio.isNotEmpty,
              orElse: () => entry.phonetics.first,
            );
            if (ipa.isEmpty) ipa = phoneticWithAudio.text;
            if (audioPath.isEmpty) audioPath = phoneticWithAudio.audio;
          }
          if (example.isEmpty && state.selectedType != null && entry.meanings.isNotEmpty) {
            try {
              final matchingMeaning = entry.meanings.firstWhere(
                (m) => m.partOfSpeech.toLowerCase() == state.selectedType!.toLowerCase(),
              );
              final matchingDefinition = matchingMeaning.definitions.firstWhere(
                (d) => d.example.isNotEmpty,
              );
              example = matchingDefinition.example;
            } catch (_) {}
          }
        }
      } catch (_) {}
    }

    final result = await _updateCardUseCase(UpdateCardParams(
      cardId: state.cardId,
      word: state.word.trim(),
      meaning: state.meaning.trim(),
      type: state.selectedType,
      topicId: state.selectedTopicId == -1 ? null : state.selectedTopicId,
      ipa: ipa,
      audioPath: audioPath,
      example: example,
    ));

    if (result is DataSuccess) {
      emit(state.copyWith(status: EditWordStatus.success));
    } else {
      emit(state.copyWith(status: EditWordStatus.failure));
    }
  }
}
