import 'package:equatable/equatable.dart';

abstract class TopicWordsEvent extends Equatable {
  const TopicWordsEvent();

  @override
  List<Object?> get props => [];
}

class InitTopicWordsEvent extends TopicWordsEvent {
  final int? initialTopicId;
  const InitTopicWordsEvent({this.initialTopicId});

  @override
  List<Object?> get props => [initialTopicId];
}

class SelectTopicTabEvent extends TopicWordsEvent {
  final int? topicId;
  const SelectTopicTabEvent(this.topicId);

  @override
  List<Object?> get props => [topicId];
}

class SearchWordsEvent extends TopicWordsEvent {
  final String query;
  const SearchWordsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class RefreshWordsEvent extends TopicWordsEvent {}
