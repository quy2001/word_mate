import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class SelectAvatarEvent extends RegisterEvent {
  final String avatarPath;

  const SelectAvatarEvent(this.avatarPath);

  @override
  List<Object?> get props => [avatarPath];
}

class UpdateNicknameEvent extends RegisterEvent {
  final String nickname;

  const UpdateNicknameEvent(this.nickname);

  @override
  List<Object?> get props => [nickname];
}

class SubmitRegisterEvent extends RegisterEvent {}
