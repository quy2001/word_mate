import 'package:equatable/equatable.dart';

abstract class EditWordEvent extends Equatable {
  const EditWordEvent();
  @override
  List<Object?> get props => [];
}

class InitEditWordEvent extends EditWordEvent {
  final Map<String, dynamic> cardData;
  const InitEditWordEvent(this.cardData);
  @override
  List<Object?> get props => [cardData];
}

class UpdateEditWordTextEvent extends EditWordEvent {
  final String word;
  const UpdateEditWordTextEvent(this.word);
  @override
  List<Object?> get props => [word];
}

class UpdateEditMeaningTextEvent extends EditWordEvent {
  final String meaning;
  const UpdateEditMeaningTextEvent(this.meaning);
  @override
  List<Object?> get props => [meaning];
}

class SelectEditWordTypeEvent extends EditWordEvent {
  final String type;
  const SelectEditWordTypeEvent(this.type);
  @override
  List<Object?> get props => [type];
}

class SelectEditTopicEvent extends EditWordEvent {
  final int topicId;
  const SelectEditTopicEvent(this.topicId);
  @override
  List<Object?> get props => [topicId];
}

class SubmitEditWordEvent extends EditWordEvent {
  const SubmitEditWordEvent();
}
