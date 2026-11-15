import 'package:equatable/equatable.dart';

abstract class AddWordEvent extends Equatable {
  const AddWordEvent();

  @override
  List<Object?> get props => [];
}

class LoadTopicsEvent extends AddWordEvent {
  final int? preSelectedTopicId;
  const LoadTopicsEvent({this.preSelectedTopicId});

  @override
  List<Object?> get props => [preSelectedTopicId];
}

class UpdateWordEvent extends AddWordEvent {
  final String word;
  const UpdateWordEvent(this.word);
  @override
  List<Object?> get props => [word];
}

class UpdateMeaningEvent extends AddWordEvent {
  final String meaning;
  const UpdateMeaningEvent(this.meaning);
  @override
  List<Object?> get props => [meaning];
}

class SelectWordTypeEvent extends AddWordEvent {
  final String type;
  const SelectWordTypeEvent(this.type);
  @override
  List<Object?> get props => [type];
}

class SelectTopicEvent extends AddWordEvent {
  final int topicId;
  const SelectTopicEvent(this.topicId);
  @override
  List<Object?> get props => [topicId];
}

class AddNewTopicEvent extends AddWordEvent {
  final String name;
  const AddNewTopicEvent(this.name);
  @override
  List<Object?> get props => [name];
}

class SubmitWordEvent extends AddWordEvent {}
