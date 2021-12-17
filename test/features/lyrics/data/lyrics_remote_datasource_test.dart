import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:itg_lyrics/injection_container.dart';
import 'package:itg_lyrics/src/app_private_config.dart';
import 'package:itg_lyrics/src/common/secrets.dart';
import 'package:itg_lyrics/src/core/error/exception.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_remote_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/network_lyric.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../fixtures/fixture_helper.dart';
import '../../../test_helper.dart';

void main() {
  late LyricsRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    sl.registerLazySingleton<http.Client>(() => MockHttpClient());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    // dataSource = LyricsRemoteDataSourceImpl(client: mockHttpClient);
    dataSource = LyricsRemoteDataSourceImpl(client: sl<http.Client>());
  });

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
      // verify(() => mockHttpClient
      verify(() => sl<http.Client>()
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

  group('searchLyrics', () {
    // final url = Uri.parse(geniusBaseUrl);
    const query = 'a';
    // final url = Uri.parse("$geniusBaseUrl$query");
    final url = Uri.parse("$geniusBaseUrl?q=$query&access_token=$geniusApiKey");

    test(
        'should perform a GET request on a URL with application/json header',
        () {
      // arrange
      setUpHttpClientSuccess200(url, response: fixture('lyrics_from_genius.json'));
      // actR
      dataSource.searchLyrics('a');
      // assert
      // verify(() => mockHttpClient
      verify(() => sl<http.Client>()
        .get(url,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            // HttpHeaders.authorizationHeader: "Bearer $geniusApiKey"
          },
          ));
    });

    test('should return Lyrics when the response code is 200', () async {
      // arrange
      setUpHttpClientSuccess200(url, response: fixture('lyrics_from_genius.json'));
      // act
      final result = await dataSource.searchLyrics('a');
      // assert
      expect(result, equals(tLyricsFromGenius));
    });

    test(
        'should return a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpHttpClientFailure404(url);
      // act
      final call = dataSource.searchLyrics;
      // assert
      expect(() => call('a'), throwsA(isInstanceOf<ServerException>()));
    });
  });
}
