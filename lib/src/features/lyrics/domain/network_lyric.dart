import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

class NetworkLyric extends LyricsEntity {
  final String lyricsURL;
  final String albumThumbnail;

  const NetworkLyric({
    required this.lyricsURL,
    required this.albumThumbnail,
    id,
    title,
    artist,
    content
  }) : super(id: id, title: title, artist: artist, content: content);
}
