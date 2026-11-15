import 'package:equatable/equatable.dart';

abstract class TopicsEvent extends Equatable {
  const TopicsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTopicsEvent extends TopicsEvent {}

class SearchTopicsEvent extends TopicsEvent {
  final String query;
  const SearchTopicsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AddTopicEvent extends TopicsEvent {
  final String name;
  final String? colorHex;
  const AddTopicEvent(this.name, {this.colorHex});

  @override
  List<Object?> get props => [name, colorHex];
}

class DeleteTopicEvent extends TopicsEvent {
  final int topicId;
  const DeleteTopicEvent(this.topicId);

  @override
  List<Object?> get props => [topicId];
}
