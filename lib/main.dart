import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:word_mate/app.dart';
import 'package:word_mate/core/index.dart';
import 'package:word_mate/injector.dart';

import 'package:word_mate/domain/repositories/app_settings_repository.dart';
import 'package:word_mate/router.dart';

/// Allow all connection to server using self signed cert
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  
  // Configure dependencies
  await configureDependencies();
  Bloc.observer = AppBlocObserver();

  // Check if user is registered
  final appSettingsRepository = injector<AppSettingsRepository>();
  final nickname = await appSettingsRepository.getNickname();
  final isRegistered = nickname != null && nickname.isNotEmpty;

  // Initialize router
  AppRouter.setupRouter(isRegistered: isRegistered);

  // Initialize the app
  runApp(const App());
}
