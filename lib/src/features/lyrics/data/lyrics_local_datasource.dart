import 'dart:convert';

import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/exception.dart';
import 'lyrics_model.dart';

abstract class LyricsLocalDataSource {
  Future<List<LyricsEntity>> getLastLyrics();
  Future<List<LyricsEntity>> getLyrics(query);
  Future<void> removeLyric(id);
  Future<LyricsModel> addLyric(lyric);
  Future<LyricsModel> editLyric(lyric);

  Future<void> cacheLyrics(List<LyricsModel> lyricsToCache);
}

const cachedLyrics = 'CACHED_NOTES';

class LyricsLocalDataSourceImpl implements LyricsLocalDataSource {
  final SharedPreferences sharedPreferences;

  LyricsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<LyricsModel>> getLyrics(query) {
    print('>>> LyricsLocalDataSourceImpl.getLyrics - query: $query');
    return getLastLyrics();
  }

  @override
  Future<void> removeLyric(id) async {
    // return Future.value(null);
  }

  @override
  Future<LyricsModel> addLyric(lyric) {
    return Future.value(LyricsModel(id: 11, title: 'title 11', artist: 'artist 11', content: 'content 11'));
  }

  @override
  Future<LyricsModel> editLyric(lyric) {
    return Future.value(lyric);
  }

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
          content: json['content'] as String,
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
