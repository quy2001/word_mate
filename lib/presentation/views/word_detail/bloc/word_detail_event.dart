import 'package:equatable/equatable.dart';

abstract class WordDetailEvent extends Equatable {
  const WordDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadWordDetailEvent extends WordDetailEvent {
  final int cardId;

  const LoadWordDetailEvent(this.cardId);

  @override
  List<Object?> get props => [cardId];
}

class DeleteWordEvent extends WordDetailEvent {
  final int cardId;

  const DeleteWordEvent(this.cardId);

  @override
  List<Object?> get props => [cardId];
}
