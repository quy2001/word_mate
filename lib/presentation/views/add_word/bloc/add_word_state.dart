import 'package:equatable/equatable.dart';

enum AddWordStatus { initial, loading, submitting, success, failure }

class AddWordState extends Equatable {
  final AddWordStatus status;
  final String word;
  final String meaning;
  final String? selectedType;
  final int? selectedTopicId;
  final List<Map<String, dynamic>> topics;

  const AddWordState({
    this.status = AddWordStatus.initial,
    this.word = '',
    this.meaning = '',
    this.selectedType,
    this.selectedTopicId,
    this.topics = const [],
  });

  bool get isValid => word.trim().isNotEmpty && meaning.trim().isNotEmpty;

  AddWordState copyWith({
    AddWordStatus? status,
    String? word,
    String? meaning,
    String? selectedType,
    int? selectedTopicId,
    List<Map<String, dynamic>>? topics,
    bool clearTopicId = false,
  }) {
    return AddWordState(
      status: status ?? this.status,
      word: word ?? this.word,
      meaning: meaning ?? this.meaning,
      selectedType: selectedType ?? this.selectedType,
      selectedTopicId: clearTopicId ? null : (selectedTopicId ?? this.selectedTopicId),
      topics: topics ?? this.topics,
    );
  }

  @override
  List<Object?> get props => [status, word, meaning, selectedType, selectedTopicId, topics];
}
