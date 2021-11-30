import '../domain/lyrics_entity.dart';

class LyricsModel extends LyricsEntity {
  const LyricsModel({
    required int id,
    required String title,
    required String artist,
    required String content,
  }) : super(id: id, title: title, artist: artist, content: content);

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return LyricsModel(
      id: (json['id'] as num).toInt(),
      title: json['title'].toString(),
      artist: json['artist'].toString(),
      content: json['content'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'content': content,
    };
  }
}
