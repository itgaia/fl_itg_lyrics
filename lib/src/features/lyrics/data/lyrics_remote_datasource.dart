import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:itg_lyrics/src/app_private_config.dart';
import 'package:itg_lyrics/src/common/secrets.dart';
import 'package:itg_lyrics/src/core/error/exception.dart';
import 'package:itg_lyrics/src/features/lyrics/api/search_result.dart';
import 'package:itg_lyrics/src/features/lyrics/api/search_result_error.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/api/song_mapper.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/network_lyric.dart';

import 'lyrics_model.dart';

abstract class LyricsRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<LyricsEntity>> getLyrics();
  Future<List<LyricsEntity>> searchLyrics(query);
}

class LyricsRemoteDataSourceImpl implements LyricsRemoteDataSource {
  final http.Client client;

  LyricsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<NetworkLyric>> searchLyrics(query) async {
    print('>>> LyricsRemoteDataSourceImpl.searchLyrics ---- query: $query');
    final songMapper = SongMapper();
    // print('>>> LyricsRemoteDataSourceImpl.searchLyrics - songMapper: $songMapper');
    // final response = http.Response('aaaaaa', 404);
    var response;
    try {
      // print('>>> LyricsRemoteDataSourceImpl.searchLyrics - bef call api - url: "${"$geniusBaseUrl$query"}"}');
      // print({
      //   // 'Content-Type': 'application/json',
      //   HttpHeaders.acceptHeader: 'application/json',
      //   HttpHeaders.contentTypeHeader: 'application/json',
      //   HttpHeaders.authorizationHeader: "Bearer $geniusApiKey"
      // });
      response = await client.get(
        // Uri.parse("$geniusBaseUrl$query"),
        Uri.parse("$geniusBaseUrl?q=$query&access_token=$geniusApiKey"),
        // Uri.parse("https://api.genius.com/search"),
        // Uri.parse("https://api.genius.com/search?access_token=gf4xUGD3C1hAM3yDACH7OQ6EXeKBtP-PKL-FB-JJKM-BPuJV0fyfVMpWT_mjL4Wm"),   // it works!
        headers: {
          // 'Content-Type': 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          // HttpHeaders.contentTypeHeader: 'application/json',
          // HttpHeaders.authorizationHeader: "Bearer $geniusApiKey"
        },
      );
    }
    catch (e) {
      print('>>> LyricsRemoteDataSourceImpl.searchLyrics - error: $e');
    }
    // print('>>> LyricsRemoteDataSourceImpl.searchLyrics....');
    // print('>>> LyricsRemoteDataSourceImpl.searchLyrics - response: $response');
    // print('>>> LyricsRemoteDataSourceImpl.searchLyrics - response.body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final results = json.decode(response.body);
      // print('>>> LyricsRemoteDataSourceImpl.searchLyrics - results: $results');
      return SearchResult.fromJson(results)
          .searchItems
          .songs
          .map(
            (songResult) => songMapper.toDomainModel(songResult.songResultItem),
      )
      .toList() as List<NetworkLyric>;
    } else {
      print('>>> LyricsRemoteDataSourceImpl.searchLyrics - error... ');
      throw ServerException();
      // throw MetaResponse.fromJson(results).searchResultError;
    }
  }

  @override
  Future<List<LyricsModel>> getLyrics() async =>
      _getLyricsFromUrl(serverUrl);

  Future<List<LyricsModel>> _getLyricsFromUrl(String url) async {
    final lyricsUrl = Uri.parse(url);
    final response = await client.get(
      lyricsUrl,
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // return LyricsModel.fromJson(
      //     json.decode(response.body) as Map<String, dynamic>);
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        return LyricsModel(
          id: json['id'] as int,
          title: json['title'] as String,
          artist: json['artist'] as String,
          content: json['content'] as String,
        );
      }).toList();
    } else {
      throw ServerException();
    }
  }
}
