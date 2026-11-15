import 'package:equatable/equatable.dart';

enum WordDetailStatus { initial, loading, success, failure, deleted }

class WordDetailState extends Equatable {
  final WordDetailStatus status;
  final Map<String, dynamic>? cardData;
  final String? errorMessage;

  const WordDetailState({
    this.status = WordDetailStatus.initial,
    this.cardData,
    this.errorMessage,
  });

  WordDetailState copyWith({
    WordDetailStatus? status,
    Map<String, dynamic>? cardData,
    String? errorMessage,
  }) {
    return WordDetailState(
      status: status ?? this.status,
      cardData: cardData ?? this.cardData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cardData, errorMessage];
}
