import 'package:bloc_test/bloc_test.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/injection_container.dart';
import 'package:itg_lyrics/src/core/network/network_info.dart';
import 'package:itg_lyrics/src/core/usecases/usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_local_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_remote_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_repository_impl.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/get_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/lyrics_list.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../lib/injection_container.dart' as di;
import 'package:itg_lyrics/src/app.dart';
import 'package:itg_lyrics/src/features/home/home_page.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/lyrics_bloc.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/lyrics_page.dart';
import 'package:itg_lyrics/src/features/settings/settings_controller.dart';
import 'package:itg_lyrics/src/features/settings/settings_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../test_helper.dart';
import '../lyrics_test_helper.dart';

// class MockLyricsBloc extends MockBloc<LyricsEvent, LyricsState> implements LyricsBloc {}
// class LyricsStateFake extends Fake implements LyricsState {}

void main() {
  // late MockLyricsBloc mockLyricsBloc;
  // late LyricsStateFake fakeLyricsState;
  // setUpAll(() {
  //   print('>>>>>>>>>>>>> setUpAll.....');
  //   mockLyricsBloc = MockLyricsBloc();
  //   fakeLyricsState = LyricsStateFake();
  //   registerFallbackValue(fakeLyricsState);
  // });

  late LyricsBloc bloc;
  late MockGetLyricsUsecase mockGetLyricsUsecase;

  setUpAll(() {
    // Necessary setup to use Params with mocktail null safety
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetLyricsUsecase = MockGetLyricsUsecase();
    bloc = LyricsBloc(lyrics: mockGetLyricsUsecase);
  });

  setUpAll(() async {
    if (!sl.isRegistered<SettingsController>()) {
      sl.registerLazySingleton(() => SettingsService());
      sl.registerLazySingleton(() => SettingsController(sl()));
    }
    sl<SettingsController>().appMainPage = LyricsPage(title: 'Lyrics',);
    sl.registerFactory(() => LyricsBloc(lyrics: sl()));
    sl.registerLazySingleton(() => GetLyricsUsecase(sl()));
    sl.registerLazySingleton<LyricsRepository>(
            () => LyricsRepositoryImpl(
          remoteDataSource: sl(),
          localDataSource: sl(),
          networkInfo: sl(),
        ));
    sl.registerLazySingleton<LyricsRemoteDataSource>(
            () => LyricsRemoteDataSourceImpl(client: sl()));
    sl.registerLazySingleton<LyricsLocalDataSource>(
            () => LyricsLocalDataSourceImpl(sharedPreferences: sl()));
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
    sl.registerLazySingleton(() => http.Client());

    SharedPreferences.setMockInitialValues({});  // In order to bypuss error - It could be not a good one...!
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingletonAsync(() async => sharedPreferences);

    MockDataConnectionChecker mockDataConnectionChecker = MockDataConnectionChecker();
    final tHasConnectionFuture = Future.value(true);
    when(() => mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) => tHasConnectionFuture);
    sl.registerLazySingleton(() => kIsWeb ? mockDataConnectionChecker : DataConnectionChecker());
  });

  group('Lyrics page widget tests', () {
    test('correct route name', () {
      expect(LyricsPage.routeName, '/lyrics');
    });

    testWidgets('page class', (widgetTester) async {
      await testWidgetPageClass<LyricsPage>(widgetTester, createWidgetUnderTest);
    });

    testWidgets('page title', (widgetTester) async {
      await testWidgetPageTitle(widgetTester, createWidgetUnderTest, 'Lyrics');
    });

    // testWidgets('renders LyricsList', (tester) async {
    //   // WidgetsFlutterBinding.ensureInitialized();
    //   print('00000');
    //   await di.init();
    //   print('11111');
    //   await tester.pumpWidget(MaterialApp(home: LyricsPage(title: 'Lyrics',)));
    //   print('2222');
    //   await tester.pumpAndSettle();
    //   print('3333');
    //   expect(find.byType(LyricsList), findsOneWidget);
    // });

    // testWidgets('lyrics page class', (widgetTester) async {
    //   final LyricsStateFake fakeLyricsState = LyricsStateFake();
    //   print('>>>>>>>>>>>>> regsterFallbackValue.....');
    //   registerFallbackValue(fakeLyricsState);
    //
    //   final mockLyricsBloc = MockLyricsBloc();
    //
    //   // Stub the state stream
    //   whenListen(
    //     mockLyricsBloc,
    //     Stream.fromIterable([0, 1, 2, 3]),
    //     initialState: 0,
    //   );
    //
    //   await widgetTester.pumpWidget(await _createWidgetUnderTest());
    //   expect(find.byType(HomePage), findsOneWidget);
    //   await _navigateToLyricsPage(widgetTester);
    //   expect(find.byType(LyricsPage), findsOneWidget);
    // });
    //
    // testWidgets('correct title', (widgetTester) async {
    //   await widgetTester.pumpWidget(await _createWidgetUnderTest());
    //   expect(find.text('Lyrics'), findsOneWidget);
    // });
  });
}