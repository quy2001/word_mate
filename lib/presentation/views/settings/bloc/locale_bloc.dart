import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_mate/domain/repositories/app_settings_repository.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_event.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final AppSettingsRepository _appSettingsRepository;

  LocaleBloc(this._appSettingsRepository)
      : super(const LocaleState(locale: Locale('vi'))) {
    on<LoadLocaleEvent>(_onLoadLocale);
    on<ChangeLocaleEvent>(_onChangeLocale);
  }

  Future<void> _onLoadLocale(
    LoadLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    final savedLocale = await _appSettingsRepository.getLocale();
    if (savedLocale != null && savedLocale.isNotEmpty) {
      emit(state.copyWith(locale: Locale(savedLocale)));
    }
  }

  Future<void> _onChangeLocale(
    ChangeLocaleEvent event,
    Emitter<LocaleState> emit,
  ) async {
    await _appSettingsRepository.saveLocale(event.locale.languageCode);
    emit(state.copyWith(locale: event.locale));
  }
}
