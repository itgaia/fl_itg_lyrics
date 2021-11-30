import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/add_edit/bloc/lyric_add_edit.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/search/bloc/lyrics_search.dart';
import 'package:mocktail/mocktail.dart';

class MockLyricsRepository extends Mock implements LyricsRepository {}

class MockLyricsEntity extends Mock implements LyricsEntity {}

class MockAddEditBloc extends Mock implements LyricAddEditBloc {}

LyricsEntity lyricInList = MockLyricsEntity();

void main() {
  late LyricAddEditBloc lyricAddEditBloc;
  late LyricsSearchBloc lyricsSearchBloc;
  late MockLyricsRepository mockLyricsRepository;

  String query = "query.test";
  List<LyricsEntity> lyricsList = List.empty(growable: true);
  int lyricToRemoveID = 1;

  setUp(() {
    mockLyricsRepository = MockLyricsRepository();
    lyricAddEditBloc = LyricAddEditBloc(lyricsRepository: mockLyricsRepository);
    lyricsSearchBloc = LyricsSearchBloc(
        lyricsRepository: mockLyricsRepository, lyricAddEditBloc: lyricAddEditBloc);

    when(() => mockLyricsRepository.searchLyrics(query))
        .thenAnswer((_) => Future.value(Right(lyricsList)));

    when(() => lyricInList.id).thenAnswer((_) {
      return lyricToRemoveID;
    });
    lyricsList.add(lyricInList);
  });

  tearDown(() {
    lyricAddEditBloc.close();
    lyricsSearchBloc.close();
  });

  test('after initialization bloc state is correct', () async {
    await expectLater(SearchStateEmpty(), lyricsSearchBloc.state);
  });

  test('after closing bloc does not emit any states', () async {
    // expectLater(lyricsSearchBloc.stream, emitsInOrder([SearchStateEmpty(), emitsDone]));
    expectLater(lyricsSearchBloc.stream, emitsInOrder([emitsDone]));

    lyricsSearchBloc.close();
  });

  Future fetchList() async {
    final expectedResponse = [
      // SearchStateEmpty(),
      SearchStateLoading(),
      SearchStateSuccess(lyricsList, query),
    ];

    expectLater(lyricsSearchBloc.stream, emitsInOrder(expectedResponse));

    lyricsSearchBloc.add(TextChanged(query: query));

    await Future.delayed(const Duration(seconds: 1), () {});
  }

  test('emits success state after insering lyrics search query', () async {
    fetchList();
  });

  test(
      'emits state success with new song, after adding it in addEditBloc and song is in query',
      () async {
    await fetchList();

    MockLyricsEntity lyricToAdd = MockLyricsEntity();

    when(() => lyricToAdd.isInQuery(query)).thenAnswer((_){return true;});

    List<LyricsEntity> songList = List.from((lyricsSearchBloc.state as SearchStateSuccess).lyrics);
    songList.insert(0, lyricToAdd);
    lyricsSearchBloc.add(LyricAdded(lyric: lyricToAdd));
    await Future.delayed(const Duration(seconds: 1), () {});
    SearchStateSuccess stateSuccess = lyricsSearchBloc.state as SearchStateSuccess;
    assert (listEquals(stateSuccess.lyrics, songList));
  });

  test('removes song from repository when remove event is sent', () async {
    await fetchList();

    expectLater(lyricsSearchBloc.stream, emitsInOrder([SearchStateSuccess(lyricsList, query)]));

    lyricsSearchBloc.add(RemoveLyric(lyricID: lyricToRemoveID));
  });
}
