import 'package:itg_lyrics/src/features/lyrics/api/song_result.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/network_lyric.dart';

class SongMapper {
  NetworkLyric toDomainModel(SongResultItem songResultItem) {
    return NetworkLyric(
      lyricsURL: songResultItem.lyricsURL,
      albumThumbnail: songResultItem.albumThumbnail,
      id: songResultItem.id,
      title: songResultItem.title,
      artist: songResultItem.artist,
      content: ''
    );
  }
}