import 'package:equatable/equatable.dart';

class LyricsEntity extends Equatable {
  const LyricsEntity({required this.id, required this.title, required this.artist, required this.content});

  final int id;
  final String title;
  final String artist;
  final String content;

  @override
  List<Object> get props => [id, title, artist, content];

  bool isInQuery(String query) {
    return (title.toLowerCase().contains(query.toLowerCase()) ||
        artist.toLowerCase().contains(query.toLowerCase()));
  }

}
