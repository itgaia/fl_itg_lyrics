import 'dart:convert';

import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exception.dart';
import 'lyrics_model.dart';

abstract class LyricsLocalDataSource {
  Future<List<LyricsEntity>> getLastLyrics();

  Future<void> cacheLyrics(List<LyricsModel> lyricsToCache);
}

const cachedLyrics = 'CACHED_NOTES';

class LyricsLocalDataSourceImpl implements LyricsLocalDataSource {
  final SharedPreferences sharedPreferences;

  LyricsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<LyricsModel>> getLastLyrics() {
    final jsonString = sharedPreferences.getString(cachedLyrics);
    if (jsonString != null) {
      final body = json.decode(jsonString) as List;
      return Future.value(
        // LyricsModel.fromJson(
        //   json.decode(jsonString) as Map<String, dynamic>,
        // ),
      body.map((dynamic json) {
        return LyricsModel(
          id: json['id'] as int,
          title: json['title'] as String,
          artist: json['artist'] as String,
        );
      }).toList()
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheLyrics(List<LyricsModel> lyricsToCache) {
    return sharedPreferences.setString(
      cachedLyrics,
      json.encode(lyricsToCache.map((LyricsModel lyric) => lyric.toJson()).toList()),
    );
  }
}
