import 'package:equatable/equatable.dart';

enum TopicsStatus { initial, loading, loaded, error }

class TopicsState extends Equatable {
  final TopicsStatus status;
  final List<Map<String, dynamic>> topics;
  final String searchQuery;

  const TopicsState({
    this.status = TopicsStatus.initial,
    this.topics = const [],
    this.searchQuery = '',
  });

  TopicsState copyWith({
    TopicsStatus? status,
    List<Map<String, dynamic>>? topics,
    String? searchQuery,
  }) {
    return TopicsState(
      status: status ?? this.status,
      topics: topics ?? this.topics,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [status, topics, searchQuery];
}
