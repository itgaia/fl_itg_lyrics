// import 'package:flutter_test/flutter_test.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:itg_lyrics/src/app.dart';
// import 'package:itg_lyrics/src/features/lyrics/domain/get_lyrics_usecase.dart';
// import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
// import 'package:itg_lyrics/src/features/lyrics/presentation/main/bloc/lyrics_bloc.dart';
// import 'package:itg_lyrics/src/features/lyrics/presentation/main/lyrics_list.dart';
// import 'package:itg_lyrics/src/features/settings/settings_controller.dart';
// import 'package:itg_lyrics/src/features/settings/settings_service.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:itg_lyrics/injection_container.dart' as di;
//
// import '../../lyrics_test_helper.dart';
//
// class MockLyricsBloc extends MockBloc<LyricsEvent, LyricsState> implements LyricsBloc {}
// class LyricsStateFake extends Fake implements LyricsState {}
// class LyricsEventFake extends Fake implements LyricsEvent {}
//
// extension on WidgetTester {
//   Future<void> pumpLyricsList(LyricsBloc lyricBloc) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await di.init();
//     return pumpWidget(
//       MaterialApp(
//         home: BlocProvider.value(
//           value: lyricBloc,
//           child: LyricsList(),
//         ),
//       ),
//     );
//   }
// }
//
void main() {
// //   final mockLyrics = List.generate(
// //     5,
// //     (i) => LyricsEntity(id: i, title: 'lyric title $i', artist: 'lyric body $i'),
// //   );
// //
//   // late LyricsBlocbloc;
//   late MockLyricsBloc mockLyricsBloc;
//   late MockGetLyricsUsecase mockGetLyricsUsecase;
//
//   setUpAll(() {
//     registerFallbackValue(LyricsStateFake());
//     registerFallbackValue(LyricsEventFake());
//   });
//
//   setUp(() {
//     // mockLyricsBloc = MockLyricBloc();
//     mockGetLyricsUsecase = MockGetLyricsUsecase();
//     mockLyricsBloc = MockLyricsBloc();
//   });
//
//   Future<Widget> _createWidgetUnderTest() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     // await di.init();
//     final settingsController = SettingsController(SettingsService());
//     await settingsController.loadSettings();
//     // return MyApp(settingsController: settingsController);
//     return MyApp();
//   }
//
//   group('LyricsList', () {
//     testWidgets(
//         'renders CircularProgressIndicator when state is loading', (tester) async {
//       when(() => mockLyricsBloc.state).thenReturn(Loading());
//       await tester.pumpLyricsList(mockLyricsBloc);
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//     });
//
// //     // testWidgets(
// //     //   'loading indicator is diplayed while wait for articles',
// //     //       (WidgetTester tester) async {
// //     //     arrangeReturnsNLyricsAfterNSecondsWait(mockGetLyricsUsecase);
// //     //     // await tester.pumpLyricsList(mockLyricsBloc);
// //     //     await tester.pumpWidget(await _createWidgetUnderTest());
// //     //     await tester.pump(const Duration(milliseconds: 500));
// //     //     expect(find.byType(CircularProgressIndicator), findsOneWidget);
// //     //     expect(find.byKey(Key('progress-indicator-main')), findsOneWidget);
// //     //     await tester.pumpAndSettle();
// //     //   }
// //     // );
// //     //
// //     // testWidgets(
// //     //     'renders no lyrics text '
// //     //     'when lyric status is success but with 0 lyrics', (tester) async {
// //     //   when(() => mockLyricsBloc.state).thenReturn(Empty());
// //     //   await tester.pumpLyricsList(mockLyricsBloc);
// //     //   expect(find.text('no lyrics'), findsOneWidget);
// //     // });
// //     //
// //     // testWidgets(
// //     //     'renders 5 lyrics and a bottom loader when lyric max is not reached yet',
// //     //     (tester) async {
// //     //   when(() => mockLyricsBloc.state).thenReturn(Loaded(lyrics: mockLyrics));
// //     //   await tester.pumpLyricsList(mockLyricsBloc);
// //     //   expect(find.byType(LyricsListItem), findsNWidgets(5));
// //     //   expect(find.byType(BottomLoader), findsOneWidget);
// //     // });
// //     //
// //     // testWidgets('does not render bottom loader when lyric max is reached',
// //     //     (tester) async {
// //     //   when(() => mockLyricsBloc.state).thenReturn(Loaded(
// //     //     lyrics: mockLyrics,
// //     //     hasReachedMax: true,
// //     //   ));
// //     //   await tester.pumpLyricsList(mockLyricsBloc);
// //     //   expect(find.byType(BottomLoader), findsNothing);
// //     // });
// //     //
// //     // testWidgets('fetches more lyrics when scrolled to the bottom',
// //     //     (tester) async {
// //     //   when(() => mockLyricsBloc.state).thenReturn(
// //     //     Loaded(
// //     //       lyrics: List.generate(
// //     //         10,
// //     //         (i) => LyricsEntity(id: i, title: 'lyric title $i', artist: 'lyric body $i'),
// //     //       ),
// //     //     ),
// //     //   );
// //     //   await tester.pumpLyricsList(mockLyricsBloc);
// //     //   await tester.drag(find.byType(LyricsList), const Offset(0, -500));
// //     //   verify(() => mockLyricsBloc.add(GetLyricsEvent())).called(1);
// //     // });
//   });
}
