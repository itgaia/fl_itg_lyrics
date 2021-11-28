import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/src/core/error/exception.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_local_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_helper.dart';
import '../../../test_helper.dart';
import '../lyrics_test_helper.dart';

void main() {
  late LyricsLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = LyricsLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);});

  group('getLastLyrics', () {
    final tLyricsModel = fixtureLyricsCached();

    test(
        'should return Lyrics from SharedPreferences when there is one in cache',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any()))
        .thenReturn(fixture('lyrics_cached.json'));
      // act
      final result = await dataSource.getLastLyrics();
      // assert
      verify(() => mockSharedPreferences.getString(cachedLyrics));
      expect(result, equals(tLyricsModel));
    });

    test('should throw a CacheException when there is not a cached value',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any()))
        .thenThrow(CacheException());
      // act
      final call = dataSource.getLastLyrics;
      // assert
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  group('cacheLyrics', () {
    final tLyricsModel = lyricsTestData(count: 3);

    test('should call SharedPreferences to cache the data', () {
      // arrange
      when(() => mockSharedPreferences.setString(cachedLyrics, any()))
        .thenAnswer((_) async => true);
      // act
      dataSource.cacheLyrics(tLyricsModel);
      // assert
      final expectedJsonString = json.encode(tLyricsModel.map((LyricsModel lyric) => lyric.toJson()).toList());
      verify(
        () => mockSharedPreferences.setString(
          cachedLyrics,
          expectedJsonString,
        ),
      );
    });
  });
}
