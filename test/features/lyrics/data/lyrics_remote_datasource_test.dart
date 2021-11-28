import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/src/app_private_config.dart';
import 'package:itg_lyrics/src/core/error/exception.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_remote_datasource.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_helper.dart';
import '../../../test_helper.dart';

void main() {
  late LyricsRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = LyricsRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpHttpClientSuccess200(Uri url) {
    when(() => mockHttpClient.get(url, headers: any(named: 'headers')))
      .thenAnswer((_) async => http.Response(fixture('lyrics.json'), 200));
  }

  void setUpHttpClientFailure404(Uri url) {
    when(() => mockHttpClient.get(url, headers: any(named: 'headers')))
      .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getLyrics', () {
    final url = Uri.parse(serverUrl);

    test(
        'should perform a GET request on a URL with application/json header',
        () {
      // arrange
      setUpHttpClientSuccess200(url);
      // act
      dataSource.getLyrics();
      // assert
      verify(() => mockHttpClient
        .get(url, headers: {'Content-Type': 'application/json'}));
    });

    final tLyricsModel = (json.decode(fixture('lyrics.json')) as List)
      .map<LyricsModel>((json) => LyricsModel.fromJson(json)).toList();

    test('should return Lyrics when the response code is 200', () async {
      // arrange
      setUpHttpClientSuccess200(url);
      // act
      final result = await dataSource.getLyrics();
      // assert
      expect(result, equals(tLyricsModel));
    });

    test(
        'should return a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpHttpClientFailure404(url);
      // act
      final call = dataSource.getLyrics;
      // assert
      expect(() => call(), throwsA(isInstanceOf<ServerException>()));
    });
  });
}
