import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/add_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/edit_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/add_edit/bloc/lyric_add_edit.dart';
import 'package:mocktail/mocktail.dart';

// class MockLyricsRepository extends Mock implements LyricsRepository {}
class MockAddLyricUsecase extends Mock implements AddLyricUsecase {}
class MockEditLyricUsecase extends Mock implements EditLyricUsecase {}

class MockLyricsModel extends Mock implements LyricsModel {}

void main() {
  late LyricAddEditBloc lyricAddEditBloc;
  // late MockLyricsRepository lyricsRepository;
  late MockAddLyricUsecase mockAddLyricUsecase;
  late MockEditLyricUsecase mockEditLyricUsecase;

  setUp(() {
    // lyricsRepository = MockLyricsRepository();
    mockAddLyricUsecase = MockAddLyricUsecase();
    mockEditLyricUsecase = MockEditLyricUsecase();
    // lyricAddEditBloc = LyricAddEditBloc(lyricsRepository: lyricsRepository);
    lyricAddEditBloc = LyricAddEditBloc(
      addLyricUsecase: mockAddLyricUsecase,
      editLyricUsecase: mockEditLyricUsecase,
    );
  });

  tearDown(() {
    lyricAddEditBloc.close();
  });

  test('after initialization bloc state is correct', () async {
    expect(LyricsAddEditShowLyricState(), lyricAddEditBloc.state);
  });

  test('after closing bloc does not emit any states', () async {
    // expectLater(lyricAddEditBloc, emitsInOrder([StateShowLyric(), emitsDone]));
    expectLater(lyricAddEditBloc.stream, emitsInOrder([emitsDone]));

    lyricAddEditBloc.close();
  });

  test('after adding a lyric lyricAddedState should be emited', () async {

    MockLyricsModel lyricToAdd = MockLyricsModel();

    final expectedResponse = [
      // LyricsAddEditShowLyricState(),
      LyricsAddEditLoadingState(),
      LyricsAddEditAddLyricSuccessState(lyricToAdd)
    ];

    // when(lyricsRepository.addLyric(lyricToAdd))
    //     .thenAnswer((_) => Future.value(lyricToAdd));
    when(() => mockAddLyricUsecase(lyricToAdd))
        .thenAnswer((_) => Future.value(Right(lyricToAdd)));

    expectLater(lyricAddEditBloc.stream, emitsInOrder(expectedResponse));

    lyricAddEditBloc.addLyric(lyricToAdd);
  });

  test('after editing a lyric lyricEditedState should be emited', () async {

    MockLyricsModel lyricToAdd = MockLyricsModel();

    final expectedResponse = [
      // LyricsAddEditShowLyricState(),
      LyricsAddEditLoadingState(),
      LyricsAddEditEditLyricSuccessState(lyricToAdd)
    ];

    // when(lyricsRepository.editLyric(lyricToAdd))
    //     .thenAnswer((_) => Future.value(lyricToAdd));
    when(() => mockEditLyricUsecase(lyricToAdd))
        .thenAnswer((_) => Future.value(Right(lyricToAdd)));

    expectLater(lyricAddEditBloc.stream, emitsInOrder(expectedResponse));

    lyricAddEditBloc.editLyric(lyricToAdd);
  });
}
