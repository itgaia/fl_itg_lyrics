import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/core/usecases/usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/get_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/presentation/main/bloc/lyrics_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_helper.dart';
import '../../lyrics_test_helper.dart';

void main() {
  late LyricsBloc bloc;
  late MockGetLyricsUsecase mockGetLyricsUsecase;

  setUpAll(() {
    // Necessary for using Params with mocktail null safety
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetLyricsUsecase = MockGetLyricsUsecase();
    bloc = LyricsBloc(lyrics: mockGetLyricsUsecase);
  });

  // test('initialState should be Empty', () {
  // // assert
  // expect(bloc.initialState, equals(Empty()));
  // });
  
  group('GetLyrics', () {
    final tLyrics = lyricsTestData();

    test('should get data', () async {
      // arrange
      when(() => mockGetLyricsUsecase(any()))
        .thenAnswer((_) async => Right(tLyrics));
      // act
      bloc.add(GetLyricsEvent());
      await untilCalled(() => mockGetLyricsUsecase(any()));
      // assert
      verify(() => mockGetLyricsUsecase(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(() => mockGetLyricsUsecase(any()))
        .thenAnswer((_) async => Right(tLyrics));
      // assert later
      final expected = [
        Loading(),
        Loaded(lyrics: tLyrics),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetLyricsEvent());
    });

    test('should emit [Loading, Loaded, Empty] when data is gotten successfully but are empty',
        () async {
      // arrange
      when(() => mockGetLyricsUsecase(any()))
          .thenAnswer((_) async => const Right([]));
      // assert later
      final expected = [
        Loading(),
        const Loaded(lyrics: []),
        Empty()
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetLyricsEvent());
    });

    test(
        'should emit [Loading, Error] with serverFailureMessage when getting data fails with a ServerFailure',
        () async {
      // arrange
      when(() => mockGetLyricsUsecase(any()))
        .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Loading(),
        const Error(message: serverFailureMessage),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetLyricsEvent());
    });

    test(
        'should emit [Loading, Error] with cacheFailureMessage when getting data fails with a CacheFailure',
        () async {
      // arrange
      when(() => mockGetLyricsUsecase(any()))
        .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Loading(),
        const Error(message: cacheFailureMessage),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetLyricsEvent());
    });
  });
}
