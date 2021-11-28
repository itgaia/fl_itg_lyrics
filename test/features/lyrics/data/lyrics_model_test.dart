import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

import '../../../fixtures/fixture_helper.dart';
import '../lyrics_test_helper.dart';

void main() {
  final tLyrics = lyricsTestData(count: 3);

  test(
    'should be a subclass of Lyrics entity',
    () async {
      expect(tLyrics.first, isA<LyricsEntity>());
    },
  );

  group('fromJson', () {
    test('should return a valid model from JSON',
      () async {
        // arrange
        // act
        final result = (json.decode(fixture('lyrics.json')) as List)
          .map<LyricsModel>((json) => LyricsModel.fromJson(json)).toList();
        // assert
        expect(result, tLyrics);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      // arrange
      final expectedJsonMap = lyricsTestMapData(count: tLyrics.length);
      // act
      final result = tLyrics.map((LyricsModel lyric) => lyric.toJson()).toList();
      // assert
      expect(result, expectedJsonMap);
    });
  });
}
