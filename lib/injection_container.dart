import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:itg_lyrics/src/app_config.dart';
import 'package:itg_lyrics/src/app_helper.dart';
import 'package:itg_lyrics/src/core/network/network_info.dart';
import 'package:itg_lyrics/src/core/util/input_converter.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_local_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_remote_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_repository_impl.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/get_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/lyrics_bloc.dart';
import 'package:itg_lyrics/src/features/settings/settings_controller.dart';
import 'package:itg_lyrics/src/features/settings/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mocktail/mocktail.dart';

// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  if (systemInjectionInit) return;
  print('injection_container/init - start...');

  MockDataConnectionChecker mockDataConnectionChecker = MockDataConnectionChecker();
  final tHasConnectionFuture = Future.value(true);
  when(() => mockDataConnectionChecker.hasConnection)
    .thenAnswer((_) => tHasConnectionFuture);

  sl.registerLazySingleton(() => SettingsService());
  sl.registerLazySingleton(() => SettingsController(sl()));

  //! Features - Number Trivia
  sl.registerFactory(() => LyricsBloc(lyrics: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetLyricsUsecase(sl()));

  // Repository
  sl.registerLazySingleton<LyricsRepository>(
          () => LyricsRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ));

  // Data sources
  sl.registerLazySingleton<LyricsRemoteDataSource>(
          () => LyricsRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton<LyricsLocalDataSource>(
          () => LyricsLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(mockDataConnectionChecker));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingletonAsync(() async => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  if (kIsWeb == true) {
    print('>>>>>> [injection_container.init] Warning! DataConnectionChecker is not compatible with Web! Use mocked object instead! <<<<<<');
    // TODO: temp-fix - DataConnectionChecker is not compatible with Web
  }
  sl.registerLazySingleton(() => kIsWeb ? mockDataConnectionChecker : DataConnectionChecker());

  systemInjectionInit = true;
}
