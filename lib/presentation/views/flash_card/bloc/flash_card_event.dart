import 'package:equatable/equatable.dart';

abstract class FlashCardEvent extends Equatable {}

class LoadFlashCards extends FlashCardEvent {
  final int? topicId;
  final bool isReviewMode;
  LoadFlashCards({this.topicId, this.isReviewMode = false});
  @override
  List<Object?> get props => [topicId, isReviewMode];
}

class SwipeCardEvent extends FlashCardEvent {
  final bool isKnown;
  SwipeCardEvent({required this.isKnown});
  @override
  List<Object?> get props => [isKnown];
}

class UndoSwipeEvent extends FlashCardEvent {
  @override
  List<Object?> get props => [];
}

class FlipCardEvent extends FlashCardEvent {
  @override
  List<Object?> get props => [];
}
