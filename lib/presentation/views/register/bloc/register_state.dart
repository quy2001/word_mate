import 'package:equatable/equatable.dart';

enum RegisterStatus { initial, submitting, success, failure }

class RegisterState extends Equatable {
  final String nickname;
  final String? selectedAvatar;
  final RegisterStatus status;

  const RegisterState({
    this.nickname = '',
    this.selectedAvatar,
    this.status = RegisterStatus.initial,
  });

  bool get isValid => nickname.trim().isNotEmpty && selectedAvatar != null;

  RegisterState copyWith({
    String? nickname,
    String? selectedAvatar,
    RegisterStatus? status,
  }) {
    return RegisterState(
      nickname: nickname ?? this.nickname,
      selectedAvatar: selectedAvatar ?? this.selectedAvatar,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [nickname, selectedAvatar, status];
}
