import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/core/data_state.dart';
import 'package:word_mate/domain/usecases/save_user_profile_usecase.dart';
import 'package:word_mate/presentation/views/register/bloc/register_event.dart';
import 'package:word_mate/presentation/views/register/bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final SaveUserProfileUseCase _saveUserProfileUseCase;

  RegisterBloc(this._saveUserProfileUseCase) : super(const RegisterState()) {
    on<SelectAvatarEvent>(_onSelectAvatar);
    on<UpdateNicknameEvent>(_onUpdateNickname);
    on<SubmitRegisterEvent>(_onSubmitRegister);
  }

  void _onSelectAvatar(SelectAvatarEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(selectedAvatar: event.avatarPath));
  }

  void _onUpdateNickname(UpdateNicknameEvent event, Emitter<RegisterState> emit) {
    emit(state.copyWith(nickname: event.nickname));
  }

  Future<void> _onSubmitRegister(SubmitRegisterEvent event, Emitter<RegisterState> emit) async {
    if (!state.isValid) return;

    emit(state.copyWith(status: RegisterStatus.submitting));
    try {
      final result = await _saveUserProfileUseCase(
        SaveUserProfileParams(
          nickname: state.nickname,
          avatarPath: state.selectedAvatar!,
        ),
      );

      if (result is DataSuccess) {
        emit(state.copyWith(status: RegisterStatus.success));
      } else {
        emit(state.copyWith(status: RegisterStatus.failure));
      }
    } catch (e) {
      emit(state.copyWith(status: RegisterStatus.failure));
    }
  }
}
