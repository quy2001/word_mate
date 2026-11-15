import 'package:equatable/equatable.dart';

enum TopicWordsStatus { initial, loading, loaded, error }

class TopicWordsState extends Equatable {
  final TopicWordsStatus status;
  final List<Map<String, dynamic>> topics;
  final List<Map<String, dynamic>> cards;
  final int? selectedTopicId;
  final String searchQuery;

  const TopicWordsState({
    this.status = TopicWordsStatus.initial,
    this.topics = const [],
    this.cards = const [],
    this.selectedTopicId,
    this.searchQuery = '',
  });

  TopicWordsState copyWith({
    TopicWordsStatus? status,
    List<Map<String, dynamic>>? topics,
    List<Map<String, dynamic>>? cards,
    int? selectedTopicId,
    bool clearSelectedTopicId = false,
    String? searchQuery,
  }) {
    return TopicWordsState(
      status: status ?? this.status,
      topics: topics ?? this.topics,
      cards: cards ?? this.cards,
      selectedTopicId: clearSelectedTopicId ? null : (selectedTopicId ?? this.selectedTopicId),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, topics, cards, selectedTopicId, searchQuery];
}
