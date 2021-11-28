import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:itg_lyrics/src/app_private_config.dart';
import 'package:itg_lyrics/src/core/error/exception.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

import 'lyrics_model.dart';

abstract class LyricsRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<LyricsEntity>> getLyrics();
}

class LyricsRemoteDataSourceImpl implements LyricsRemoteDataSource {
  final http.Client client;

  LyricsRemoteDataSourceImpl({required this.client});

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
        );
      }).toList();
    } else {
      throw ServerException();
    }
  }
}
