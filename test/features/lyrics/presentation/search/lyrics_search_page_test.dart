import 'package:bloc_test/bloc_test.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/injection_container.dart';
import 'package:itg_lyrics/src/app_private_config.dart';
import 'package:itg_lyrics/src/common/secrets.dart';
import 'package:itg_lyrics/src/core/constants.dart';
import 'package:itg_lyrics/src/core/network/network_info.dart';
import 'package:itg_lyrics/src/core/usecases/usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_local_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_remote_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_repository_impl.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/add_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/edit_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/get_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/remove_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/search_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/add_edit/bloc/lyric_add_edit.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/main/lyrics_list.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/search/bloc/lyrics_search.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/search/lyrics_search_list.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/search/lyrics_search_page.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/search/search_bar.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../lib/injection_container.dart' as di;
import 'package:itg_lyrics/src/app.dart';
import 'package:itg_lyrics/src/features/home/home_page.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/main/bloc/lyrics_bloc.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/main/lyrics_page.dart';
import 'package:itg_lyrics/src/features/settings/settings_controller.dart';
import 'package:itg_lyrics/src/features/settings/settings_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../../fixtures/fixture_helper.dart';
import '../../../../test_helper.dart';
import '../../lyrics_test_helper.dart';

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

  final mockTextToFind = 'find this one';

  late MockLyricsSearchBloc mockLyricsSearchBloc;
  // late LyricAddEditBloc lyricAddEditBloc;
  // late MockSearchLyricsUsecase mockSearchLyricsUsecase;
  // late MockRemoveLyricUsecase mockRemoveLyricUsecase;
  // late MockAddLyricUsecase mockAddLyricUsecase;
  // late MockEditLyricUsecase mockEditLyricUsecase;

  setUpAll(() {
    // Necessary setup to use with mocktail null safety
    registerFallbackValue(NoParams());
    registerFallbackValue(LyricsSearchEmptyState());
    registerFallbackValue(LyricsSearchTextChangedEvent(query: ''));
  });

  setUpAll(() async {
    // mockSearchLyricsUsecase = MockSearchLyricsUsecase();
    // mockRemoveLyricUsecase = MockRemoveLyricUsecase();
    // mockAddLyricUsecase = MockAddLyricUsecase();
    // mockEditLyricUsecase = MockEditLyricUsecase();

    sl.registerLazySingleton(() => SearchLyricsUsecase(sl()));
    sl.registerLazySingleton(() => RemoveLyricUsecase(sl()));
    sl.registerLazySingleton(() => AddLyricUsecase(sl()));
    sl.registerLazySingleton(() => EditLyricUsecase(sl()));

    sl.registerFactory(() =>
        LyricAddEditBloc(addLyricUsecase: sl(), editLyricUsecase: sl()));

    if (!sl.isRegistered<SettingsController>()) {
      sl.registerLazySingleton(() => SettingsService());
      sl.registerLazySingleton(() => SettingsController(sl()));
    }
    sl<SettingsController>().appMainPage = LyricsSearchPage();
    // sl<SettingsController>().appMainPage = LyricsSearchPage(
    //   addLyricUsecase: mockAddLyricUsecase,
    //   editLyricUsecase: mockEditLyricUsecase,
    //   searchLyricsUsecase: mockSearchLyricsUsecase,
    //   removeLyricUsecase: mockRemoveLyricUsecase,
    // );
    sl.registerFactory(() => LyricsBloc(lyrics: sl()));
    sl.registerLazySingleton(() => GetLyricsUsecase(sl()));
    sl.registerLazySingleton<LyricsRepository>(
            () =>
            LyricsRepositoryImpl(
              remoteDataSource: sl(),
              localDataSource: sl(),
              networkInfo: sl(),
            ));
    sl.registerLazySingleton<LyricsRemoteDataSource>(
            () => LyricsRemoteDataSourceImpl(client: sl()));
    sl.registerLazySingleton<LyricsLocalDataSource>(
            () => LyricsLocalDataSourceImpl(sharedPreferences: sl()));
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

    SharedPreferences.setMockInitialValues(
        {}); // In order to bypuss error - It could be not a good one...!
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingletonAsync(() async => sharedPreferences);

    // TODO: This approach works but the direct assignment is not! Why?
    // sl.registerFactory<LyricsSearchBloc>(() => MockLyricsSearchBloc());
    mockLyricsSearchBloc = MockLyricsSearchBloc();
    sl.registerFactory<LyricsSearchBloc>(() => mockLyricsSearchBloc);

    // sl.registerLazySingleton(() => http.Client());
    sl.registerLazySingleton<http.Client>(() => MockHttpClient());

    MockDataConnectionChecker mockDataConnectionChecker = MockDataConnectionChecker();
    final tHasConnectionFuture = Future.value(true);
    when(() => mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) => tHasConnectionFuture);
    sl.registerLazySingleton(() =>
    kIsWeb
        ? mockDataConnectionChecker
        : DataConnectionChecker());

    when(() => sl<LyricsSearchBloc>().state).thenReturn(
      LyricsSearchEmptyState(),
    );
  });

  setUp(() {
    print('LyricsSearchPageTest - setUp - start....');
    // lyricAddEditBloc = LyricAddEditBloc(
    //   addLyricUsecase: mockAddLyricUsecase,
    //   editLyricUsecase: mockEditLyricUsecase,
    // );

    // mockLyricsSearchBloc = MockLyricsSearchBloc();
    // if (sl.isRegistered<LyricsSearchBloc>()) {
    //   sl.unregister<LyricsSearchBloc>();
    // }
    // sl.registerFactory<LyricsSearchBloc>(() => MockLyricsSearchBloc());

    // bloc = LyricsSearchBloc(
    //     searchLyricsUsecase: mockSearchLyricsUsecase,
    //     removeLyricUsecase: mockRemoveLyricUsecase,
    //     lyricAddEditBloc: lyricAddEditBloc
    // );
    print('LyricsSearchPageTest - setUp - end....');
  });

  group('Lyrics page widget tests', () {
    test('correct route name', () {
      expect(LyricsSearchPage.routeName, '/search');
    });

    testWidgets('page class', (widgetTester) async {
      await testWidgetPageClass<LyricsSearchPage>(
          widgetTester, createWidgetUnderTest);
    });

    testWidgets('page title', (widgetTester) async {
      await testWidgetPageTitle(
          widgetTester, createWidgetUnderTest, 'app name');
    });

    testWidgets('renders SearchBar', (widgetTester) async {
      await widgetTester.pumpWidget(await createWidgetUnderTest());
      expect(find.byType(SearchBar), findsOneWidget);
    });

    testWidgets('renders LyricsSearchList', (widgetTester) async {
      await widgetTester.pumpWidget(await createWidgetUnderTest());
      expect(find.byType(LyricsSearchList), findsOneWidget);
    });

    testWidgets('renders add button', (widgetTester) async {
      await widgetTester.pumpWidget(await createWidgetUnderTest());
      expect(find.byKey(keyButtonSearchPageAdd), findsOneWidget);
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

  group('SearchBar', () {
    testWidgets(
        'user can enter text for searching lyrics', (widgetTester) async {
      await widgetTester.pumpWidget(await createWidgetUnderTest());
      await widgetTester.enterText(find.byKey(keyTextFieldSearchBar), mockTextToFind);
      await widgetTester.pumpAndSettle();
      verify(() => mockLyricsSearchBloc.add(
        LyricsSearchTextChangedEvent(query: mockTextToFind))
      ).called(1);
    });
  });

  group('LyricsSearchList', () {
    testWidgets('user see an empty list', (widgetTester) async {
      await widgetTester.pumpWidget(await createWidgetUnderTest());
      expect(find.text('enter song title'), findsOneWidget);
    });

    testWidgets('user see a list of lyrics', (widgetTester) async {
      if (sl.isRegistered<LyricsSearchBloc>()) {
        sl.unregister<LyricsSearchBloc>();
        sl.registerFactory(() => LyricsSearchBloc(searchLyricsUsecase: sl(), removeLyricUsecase: sl(), lyricAddEditBloc: sl()));
      }
      final url = Uri.parse("$geniusBaseUrl?q=$mockTextToFind&access_token=$geniusApiKey");
      setUpHttpClientSuccess200(url, response: fixture('lyrics_from_genius.json'));
      await widgetTester.pumpWidget(await createWidgetUnderTest());
      await widgetTester.enterText(find.byKey(keyTextFieldSearchBar), mockTextToFind);
      await widgetTester.pumpAndSettle();
      await widgetTester.pumpAndSettle();
      // verify(() => mockLyricsSearchBloc.add(
      //     LyricsSearchTextChangedEvent(query: mockTextToFind))
      // ).called(1);
    });
  });

  group('LyricAddScreen', () {

  });
}