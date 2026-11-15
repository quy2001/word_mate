import 'dart:ui';

abstract class LocaleEvent {}

class LoadLocaleEvent extends LocaleEvent {}

class ChangeLocaleEvent extends LocaleEvent {
  final Locale locale;

  ChangeLocaleEvent(this.locale);
}
