import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

import 'package:itg_lyrics/src/core/usecases/usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/get_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';

import '../../../test_helper.dart';
import '../lyrics_test_helper.dart';

void main() {
  late GetLyricsUsecase usecase;
  late MockLyricsRepository mockLyricsRepository;

  setUp(() {
    mockLyricsRepository = MockLyricsRepository();
    usecase = GetLyricsUsecase(mockLyricsRepository);
  });

  final tLyrics = lyricsTestData();

  test(
    'should get lyrics from the repository',
    () async {
      // "On the fly" implementation of the Repository using the MockTail package.
      // When getConcreteLyrics is called with any argument, always answer with
      // the Right "side" of Either containing a test List<Lyrics> object.
      when(() => mockLyricsRepository.getLyrics())
          .thenAnswer((_) async => Right(tLyrics));

      // The "act" phase of the test.
      final result = await usecase(NoParams());

      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right(tLyrics));

      // Verify that the method has been called on the Repository
      verify(() => mockLyricsRepository.getLyrics());

      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockLyricsRepository);
    },
  );
}
