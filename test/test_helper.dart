import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/injection_container.dart';
import 'package:itg_lyrics/src/app.dart';
import 'package:itg_lyrics/src/app_config.dart';
import 'package:itg_lyrics/src/core/constants.dart';
import 'package:itg_lyrics/src/core/network/network_info.dart';
import 'package:itg_lyrics/src/core/util/input_converter.dart';
import 'package:itg_lyrics/src/features/home/home_page.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/add_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/edit_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/get_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/network_lyric.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/remove_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/search_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/search/bloc/lyrics_search.dart';
import 'package:itg_lyrics/src/features/settings/settings_controller.dart';
import 'package:itg_lyrics/src/features/settings/settings_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../lib/injection_container.dart' as di;
import 'package:http/http.dart' as http;

import 'fixtures/fixture_helper.dart';

// class MockMyBloc extends MockBloc<MyEvent, MyState> implements MyBloc {}

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}
class MockInputConverter extends Mock implements InputConverter {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockNetworkInfoImpl extends Mock implements NetworkInfoImpl {}
class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockHttpClient extends Mock implements http.Client {}
class MockSearchLyricsUsecase extends Mock implements SearchLyricsUsecase {}
class MockRemoveLyricUsecase extends Mock implements RemoveLyricUsecase {}
class MockAddLyricUsecase extends Mock implements AddLyricUsecase {}
class MockEditLyricUsecase extends Mock implements EditLyricUsecase {}

class MockLyricsSearchBloc extends MockBloc<LyricsSearchEvent, LyricsSearchState> implements LyricsSearchBloc {}

final tLyricsFromGenius = [
  NetworkLyric(id: 3584538, title: 'Ooh Yea', artist: 'Fabolous', albumThumbnail: '', lyricsURL: '', content: ''),
  NetworkLyric(id: 3867570, title: 'New Music Friday 07/13/18', artist: 'Spotify', albumThumbnail: '', lyricsURL: '', content: ''),
  NetworkLyric(id: 88443, title: 'So NY', artist: 'Fabolous', albumThumbnail: '', lyricsURL: '', content: ''),
  NetworkLyric(id: 19629, title: 'This Is My Party', artist: 'Fabolous', albumThumbnail: '', lyricsURL: '', content: ''),
  NetworkLyric(id: 134312, title: 'Fabolous - So NY (Traduction Française)', artist: 'Genius Traductions Françaises', albumThumbnail: '', lyricsURL: '', content: ''),
  NetworkLyric(id: 212570, title: 'Green', artist: 'Ryan Leslie', albumThumbnail: '', lyricsURL: '', content: ''),
  NetworkLyric(id: 32054, title: 'Badaboom', artist: 'B2K', albumThumbnail: '', lyricsURL: '', content: ''),
  NetworkLyric(id: 858836, title: 'I Keep It Gangsta', artist: 'B.G.', albumThumbnail: '', lyricsURL: '', content: ''),
  NetworkLyric(id: 2474836, title: 'Driven', artist: 'Jay Whiss & SAFE', albumThumbnail: '', lyricsURL: '', content: '')
];


// Future<Widget> createWidgetUnderTest() async {
//   final settingsController = SettingsController(SettingsService());
//   await settingsController.loadSettings();
//   // return MyApp(settingsController: settingsController);
//   return AnimatedBuilder(
//     animation: settingsController,
//     builder: (BuildContext context, Widget? child) {
//       return MaterialApp(
//         // Providing a restorationScopeId allows the Navigator built by the
//         // MaterialApp to restore the navigation stack when a user leaves and
//         // returns to the app after it has been killed while running in the
//         // background.
//         restorationScopeId: 'app',
//
//         // Provide the generated AppLocalizations to the MaterialApp. This
//         // allows descendant Widgets to display the correct translations
//         // depending on the user's locale.
//         localizationsDelegates: const [
//           AppLocalizations.delegate,
//           GlobalMaterialLocalizations.delegate,
//           GlobalWidgetsLocalizations.delegate,
//           GlobalCupertinoLocalizations.delegate,
//         ],
//         supportedLocales: const [
//           Locale('en', ''), // English, no country code
//         ],
//
//         // Use AppLocalizations to configure the correct application title
//         // depending on the user's locale.
//         //
//         // The appTitle is defined in .arb files found in the localization
//         // directory.
//         onGenerateTitle: (BuildContext context) =>
//         AppLocalizations.of(context)!.appTitle,
//
//         // Define a light and dark color theme. Then, read the user's
//         // preferred ThemeMode (light, dark, or system default) from the
//         // SettingsController to display the correct theme.
//         theme: ThemeData(),
//         darkTheme: ThemeData.dark(),
//         themeMode: settingsController.themeMode,
//
//         // Define a function to handle named routes in order to support
//         // Flutter web url navigation and deep linking.
//         onGenerateRoute: (RouteSettings routeSettings) {
//           return MaterialPageRoute<void>(
//             settings: routeSettings,
//             builder: (BuildContext context) {
//               switch (routeSettings.name) {
//                 // case SettingsView.routeName:
//                 //   return SettingsView(controller: settingsController);
//                 // case SampleItemDetailsView.routeName:
//                 //   return const SampleItemDetailsView();
//                 case LyricsPage.routeName:
//                 default:
//                   // return LyricsPage(lyricsCubit: LyricsCubit(), title: 'Lyrics');
//                   return const LyricsPage(title: 'Lyrics');
//               }
//             },
//           );
//         },
//       );
//     },
//   );
// }

Future<Widget> createWidgetUnderTest() async {
  systemUnderTesting = true;
  WidgetsFlutterBinding.ensureInitialized();

  if (!sl.isRegistered<SettingsController>()) {
    sl.registerLazySingleton(() => SettingsService());
    sl.registerLazySingleton(() => SettingsController(sl()));
  }
  // final settingsController = SettingsController(SettingsService());
  final SettingsController settingsController = sl();
  await settingsController.loadSettings();
  // return MyApp(settingsController: settingsController);
  return MyApp();
}

Future<void> navigateToLyricsPage(WidgetTester tester) async {
  expect(find.byKey(keyButtonLyricsPage), findsOneWidget);
  await tester.tap(find.byKey(keyButtonLyricsPage));
  await tester.pumpAndSettle();
}

Future<void> testWidgetPageClass<T>(widgetTester, widgetUnderTest) async {
  await widgetTester.pumpWidget(await widgetUnderTest());
  expect(find.byType(T), findsOneWidget);
  widgetTester.pumpAndSettle();
}

Future<void> testWidgetPageTitle(widgetTester, widgetUnderTest, title) async {
  await widgetTester.pumpWidget(await widgetUnderTest());
  expect(find.text(title), findsOneWidget);
  widgetTester.pumpAndSettle();
}

// testWidgets('correct title', (widgetTester) async {
// await widgetTester.pumpWidget(await createWidgetUnderTest());
// expect(find.text('Lyrics App'), findsOneWidget);
// });

void setUpHttpClientSuccess200(Uri url, {String response = 'DEF'}) {
  if (response == 'DEF') response = fixture('lyrics.json');
  // when(() => mockHttpClient.get(url, headers: any(named: 'headers')))
  when(() => sl<http.Client>().get(url, headers: any(named: 'headers')))
      .thenAnswer((_) async => http.Response(response, 200));
}

void setUpHttpClientFailure404(Uri url) {
  // when(() => mockHttpClient.get(url, headers: any(named: 'headers')))
  when(() => sl<http.Client>().get(url, headers: any(named: 'headers')))
      .thenAnswer((_) async => http.Response('Something went wrong', 404));
}

