import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:word_mate/data/data_sources/local/app_database.dart';
import 'package:word_mate/data/data_sources/local/app_settings_dao.dart';
import 'package:word_mate/data/data_sources/local/card_dao.dart';
import 'package:word_mate/data/data_sources/local/home_dao.dart';
import 'package:word_mate/data/data_sources/remote/dictionary_api_service.dart';
import 'package:word_mate/data/repositories/app_settings_repository_impl.dart';
import 'package:word_mate/data/repositories/card_repository_impl.dart';
import 'package:word_mate/data/repositories/dictionary_repository_impl.dart';
import 'package:word_mate/data/repositories/home_repository_impl.dart';
import 'package:word_mate/domain/repositories/app_settings_repository.dart';
import 'package:word_mate/domain/repositories/card_repository.dart';
import 'package:word_mate/domain/repositories/dictionary_repository.dart';
import 'package:word_mate/domain/repositories/home_repository.dart';
import 'package:word_mate/domain/usecases/add_card_usecase.dart';
import 'package:word_mate/domain/usecases/update_card_usecase.dart';
import 'package:word_mate/domain/usecases/fetch_word_details_usecase.dart';
import 'package:word_mate/domain/usecases/get_home_data_usecase.dart';
import 'package:word_mate/domain/usecases/get_stats_usecase.dart';
import 'package:word_mate/domain/usecases/get_topics_usecase.dart';
import 'package:word_mate/domain/usecases/save_daily_goal_usecase.dart';
import 'package:word_mate/domain/usecases/save_user_profile_usecase.dart';
import 'package:word_mate/presentation/views/add_word/bloc/add_word_bloc.dart';
import 'package:word_mate/presentation/views/edit_word/bloc/edit_word_bloc.dart';
import 'package:word_mate/presentation/views/stats/bloc/stats_bloc.dart';
import 'package:word_mate/presentation/views/daily_goal/bloc/daily_goal_bloc.dart';
import 'package:word_mate/presentation/views/home/bloc/home_bloc.dart';
import 'package:word_mate/presentation/views/register/bloc/register_bloc.dart';
import 'package:word_mate/presentation/views/topics/bloc/topics_bloc.dart';
import 'package:word_mate/presentation/views/topics/bloc/topic_words_bloc.dart';
import 'package:word_mate/presentation/views/flash_card/bloc/flash_card_bloc.dart';
import 'package:word_mate/presentation/views/settings/bloc/locale_bloc.dart';
import 'package:word_mate/presentation/views/word_detail/bloc/word_detail_bloc.dart';
import 'package:word_mate/presentation/widgets/bottom_nav/bottom_nav_bloc.dart';

final injector = GetIt.instance;

Future<void> configureDependencies() async {
  /// Commonly used dependencies
  injector.registerSingleton<FlutterSecureStorage>(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ),
  );

  final dio = Dio();
  injector.registerSingleton<Dio>(dio);

  // Databases
  injector.registerSingleton<AppDatabase>(AppDatabase());

  // Services
  injector.registerLazySingleton<DictionaryApiService>(() => DictionaryApiService(injector()));

  // Daos
  injector.registerLazySingleton<AppSettingsDao>(() => AppSettingsDao(injector()));
  injector.registerLazySingleton<CardDao>(() => CardDao(injector()));
  injector.registerLazySingleton<HomeDao>(() => HomeDao(injector()));

  // Repositories
  injector.registerLazySingleton<AppSettingsRepository>(() => AppSettingsRepositoryImpl(injector()));
  injector.registerLazySingleton<CardRepository>(() => CardRepositoryImpl(injector()));
  injector.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(injector()));
  injector.registerLazySingleton<DictionaryRepository>(() => DictionaryRepositoryImpl(injector()));

  // UseCases
  injector.registerLazySingleton<SaveUserProfileUseCase>(() => SaveUserProfileUseCase(injector()));
  injector.registerLazySingleton<SaveDailyGoalUseCase>(() => SaveDailyGoalUseCase(injector()));
  injector.registerLazySingleton<AddCardUseCase>(() => AddCardUseCase(injector()));
  injector.registerLazySingleton<UpdateCardUseCase>(() => UpdateCardUseCase(injector()));
  injector.registerLazySingleton<GetTopicsUseCase>(() => GetTopicsUseCase(injector()));
  injector.registerLazySingleton<GetHomeDataUseCase>(() => GetHomeDataUseCase(injector(), injector()));
  injector.registerLazySingleton<GetStatsUseCase>(() => GetStatsUseCase(injector()));
  injector.registerLazySingleton<FetchWordDetailsUseCase>(() => FetchWordDetailsUseCase(injector()));

  // Blocs
  injector.registerFactory<RegisterBloc>(() => RegisterBloc(injector()));
  injector.registerFactory<DailyGoalBloc>(() => DailyGoalBloc(injector()));
  injector.registerFactory<AddWordBloc>(() => AddWordBloc(injector(), injector(), injector()));
  injector.registerFactory<EditWordBloc>(() => EditWordBloc(injector(), injector(), injector()));
  injector.registerFactory<TopicsBloc>(() => TopicsBloc(injector(), injector()));
  injector.registerFactory<TopicWordsBloc>(() => TopicWordsBloc(injector()));
  injector.registerFactory<FlashCardBloc>(() => FlashCardBloc(injector()));
  injector.registerFactory<HomeBloc>(() => HomeBloc(injector()));
  injector.registerFactory<StatsBloc>(() => StatsBloc(injector()));
  injector.registerFactory<BottomNavBloc>(() => BottomNavBloc());
  injector.registerFactory<WordDetailBloc>(() => WordDetailBloc(injector()));
  injector.registerLazySingleton<LocaleBloc>(() => LocaleBloc(injector()));
}

