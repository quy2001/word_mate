import 'package:equatable/equatable.dart';

enum FlashCardStatus { initial, loading, loaded, finished, error }

class FlashCardState extends Equatable {
  final FlashCardStatus status;
  final List<Map<String, dynamic>> cards;
  final int currentIndex;
  final bool isFlipped;
  final List<bool> swipeHistory;

  const FlashCardState({
    this.status = FlashCardStatus.initial,
    this.cards = const [],
    this.currentIndex = 0,
    this.isFlipped = false,
    this.swipeHistory = const [],
  });

  FlashCardState copyWith({
    FlashCardStatus? status,
    List<Map<String, dynamic>>? cards,
    int? currentIndex,
    bool? isFlipped,
    List<bool>? swipeHistory,
  }) {
    return FlashCardState(
      status: status ?? this.status,
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      swipeHistory: swipeHistory ?? this.swipeHistory,
    );
  }

  @override
  List<Object?> get props => [status, cards, currentIndex, isFlipped, swipeHistory];
}
