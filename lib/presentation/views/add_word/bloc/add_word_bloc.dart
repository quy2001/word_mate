import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';
import 'package:word_mate/domain/usecases/add_card_usecase.dart';
import 'package:word_mate/domain/usecases/fetch_word_details_usecase.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_event.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_state.dart';

class AddWordBloc extends Bloc<AddWordEvent, AddWordState> {
  final AddCardUseCase _addCardUseCase;
  final CardRepository _cardRepository;
  final FetchWordDetailsUseCase _fetchWordDetailsUseCase;

  AddWordBloc(this._addCardUseCase, this._cardRepository, this._fetchWordDetailsUseCase)
      : super(const AddWordState()) {
    on<LoadTopicsEvent>(_onLoadTopics);
    on<UpdateWordEvent>(_onUpdateWord);
    on<UpdateMeaningEvent>(_onUpdateMeaning);
    on<SelectWordTypeEvent>(_onSelectWordType);
    on<SelectTopicEvent>(_onSelectTopic);
    on<AddNewTopicEvent>(_onAddNewTopic);
    on<SubmitWordEvent>(_onSubmitWord);
  }

  Future<void> _onLoadTopics(
      LoadTopicsEvent event, Emitter<AddWordState> emit) async {
    emit(state.copyWith(status: AddWordStatus.loading));
    try {
      final topics = await _cardRepository.getTopics();
      emit(state.copyWith(
        status: AddWordStatus.initial,
        topics: topics,
        selectedTopicId: event.preSelectedTopicId,
      ));
    } catch (_) {
      emit(state.copyWith(status: AddWordStatus.initial));
    }
  }

  void _onUpdateWord(UpdateWordEvent event, Emitter<AddWordState> emit) {
    emit(state.copyWith(word: event.word));
  }

  void _onUpdateMeaning(UpdateMeaningEvent event, Emitter<AddWordState> emit) {
    emit(state.copyWith(meaning: event.meaning));
  }

  void _onSelectWordType(
      SelectWordTypeEvent event, Emitter<AddWordState> emit) {
    // Toggle off if same type is selected again
    if (state.selectedType == event.type) {
      emit(AddWordState(
        status: state.status,
        word: state.word,
        meaning: state.meaning,
        selectedType: null,
        selectedTopicId: state.selectedTopicId,
        topics: state.topics,
      ));
    } else {
      emit(state.copyWith(selectedType: event.type));
    }
  }

  void _onSelectTopic(SelectTopicEvent event, Emitter<AddWordState> emit) {
    // Toggle off if same topic is selected again
    if (state.selectedTopicId == event.topicId) {
      emit(state.copyWith(clearTopicId: true));
    } else {
      emit(state.copyWith(selectedTopicId: event.topicId));
    }
  }

  Future<void> _onAddNewTopic(
      AddNewTopicEvent event, Emitter<AddWordState> emit) async {
    if (event.name.trim().isEmpty) return;
    try {
      final topicId =
          await _cardRepository.addTopic(name: event.name.trim());
      final topics = await _cardRepository.getTopics();
      emit(state.copyWith(topics: topics, selectedTopicId: topicId));
    } catch (_) {
      // Silently fail - topics list unchanged
    }
  }

  Future<void> _onSubmitWord(
      SubmitWordEvent event, Emitter<AddWordState> emit) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: AddWordStatus.submitting));
    
    String ipa = '';
    String audioPath = '';
    String example = '';

    try {
      print('--- CALLING DICTIONARY API FOR: ${state.word.trim()} ---');
      final apiResult = await _fetchWordDetailsUseCase(state.word.trim());
      
      if (apiResult is DataSuccess && apiResult.data != null && apiResult.data!.isNotEmpty) {
        print('--- API SUCCESS: Found ${apiResult.data!.length} entries ---');
        final entry = apiResult.data!.first;

        // 1 & 2. Get IPA and Audio
        if (entry.phonetics.isNotEmpty) {
          final phoneticWithAudio = entry.phonetics.firstWhere(
            (p) => p.audio.isNotEmpty && p.licenseName == 'BY-SA 3.0',
            orElse: () => entry.phonetics.firstWhere(
              (p) => p.audio.isNotEmpty,
              orElse: () => entry.phonetics.first,
            ),
          );
          ipa = phoneticWithAudio.text;
          audioPath = phoneticWithAudio.audio;
          print('--- EXTRACTED IPA: $ipa, AUDIO: $audioPath ---');
        }

        // 3. Get Example based on partOfSpeech
        if (state.selectedType != null && entry.meanings.isNotEmpty) {
          try {
            final matchingMeaning = entry.meanings.firstWhere(
              (m) => m.partOfSpeech.toLowerCase() == state.selectedType!.toLowerCase(),
            );
            final matchingDefinition = matchingMeaning.definitions.firstWhere(
              (d) => d.example.isNotEmpty,
            );
            example = matchingDefinition.example;
            print('--- EXTRACTED EXAMPLE: $example ---');
          } catch (e) {
            print('--- NO EXAMPLE FOUND FOR TYPE ${state.selectedType}: $e ---');
          }
        }
      } else {
        print('--- API FAILED OR EMPTY: ${apiResult.exception} ---');
      }
    } catch (e, stackTrace) {
      print('--- UNEXPECTED ERROR IN API CALL: $e ---');
      print(stackTrace);
      // API call failed, ignore and proceed to save
    }

    try {
      final result = await _addCardUseCase(AddCardParams(
        word: state.word.trim(),
        meaning: state.meaning.trim(),
        type: state.selectedType,
        topicId: state.selectedTopicId == -1 ? null : state.selectedTopicId,
        ipa: ipa,
        audioPath: audioPath,
        example: example,
      ));

      if (result is DataSuccess) {
        emit(state.copyWith(status: AddWordStatus.success));
      } else {
        emit(state.copyWith(status: AddWordStatus.failure));
      }
    } catch (_) {
      emit(state.copyWith(status: AddWordStatus.failure));
    }
  }
}
