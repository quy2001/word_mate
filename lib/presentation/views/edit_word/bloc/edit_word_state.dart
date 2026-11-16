import 'package:equatable/equatable.dart';

enum EditWordStatus { initial, loading, submitting, success, failure }

class EditWordState extends Equatable {
  final EditWordStatus status;
  final int cardId;
  final String word;
  final String meaning;
  final String? selectedType;
  final int? selectedTopicId;
  final String? ipa;
  final String? audioPath;
  final String? example;
  final List<Map<String, dynamic>> topics;

  const EditWordState({
    this.status = EditWordStatus.initial,
    this.cardId = 0,
    this.word = '',
    this.meaning = '',
    this.selectedType,
    this.selectedTopicId,
    this.ipa,
    this.audioPath,
    this.example,
    this.topics = const [],
  });

  bool get isValid => word.trim().isNotEmpty && meaning.trim().isNotEmpty;

  EditWordState copyWith({
    EditWordStatus? status,
    int? cardId,
    String? word,
    String? meaning,
    String? selectedType,
    int? selectedTopicId,
    bool clearTopicId = false,
    String? ipa,
    String? audioPath,
    String? example,
    List<Map<String, dynamic>>? topics,
  }) {
    return EditWordState(
      status: status ?? this.status,
      cardId: cardId ?? this.cardId,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      selectedType: selectedType ?? this.selectedType,
      selectedTopicId: clearTopicId ? null : (selectedTopicId ?? this.selectedTopicId),
      ipa: ipa ?? this.ipa,
      audioPath: audioPath ?? this.audioPath,
      example: example ?? this.example,
      topics: topics ?? this.topics,
    );
  }

  @override
  List<Object?> get props => [
        status,
        cardId,
        word,
        meaning,
        selectedType,
        selectedTopicId,
        ipa,
        audioPath,
        example,
        topics,
      ];
}
