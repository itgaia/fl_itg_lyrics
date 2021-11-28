import 'dart:convert';

import 'package:itg_lyrics/src/features/lyrics/data/lyrics_local_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_remote_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/get_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixture_helper.dart';

class MockGetLyricsUsecase extends Mock implements GetLyricsUsecase {}
class MockLyricsRepository extends Mock implements LyricsRepository {}
class MockLyricsRemoteDataSource extends Mock implements LyricsRemoteDataSource {}
class MockLyricsLocalDataSource extends Mock implements LyricsLocalDataSource {}

List<LyricsModel> fixtureLyricsCached() => (json.decode(fixture('lyrics_cached.json')) as List)
    .map<LyricsModel>((json) => LyricsModel.fromJson(json)).toList() as List<LyricsModel>;

List<LyricsModel> lyricsTestData({int count = 5}) => List.generate(
  count,
  (i) => LyricsModel(id: i+1, title: 'test song ${i+1}', artist: 'test artist ${i+1}')
);


List<Map<String, dynamic>> lyricsTestMapData({int count = 5}) => List.generate(
  count,
  (i) => {'id': i+1, 'title': 'test song ${i+1}', 'artist': 'test artist ${i+1}'}
);

void arrangeReturnsNLyrics(mockGetLyricsUsecase, {int count = 5}) {
  when(() => mockGetLyricsUsecase.getLyrics()).thenAnswer(
          (_) async => lyricsTestData(count: count)
  );
}

void arrangeReturnsNLyricsAfterNSecondsWait(
  mockGetLyricsUsecase,
  {int count = 5, Duration wait = const Duration(seconds: 2)}) {
  when(() => mockGetLyricsUsecase.getLyrics()).thenAnswer(
    (_) async {
      await Future.delayed(wait);
      return lyricsTestData(count: count);
    }
  );
}

