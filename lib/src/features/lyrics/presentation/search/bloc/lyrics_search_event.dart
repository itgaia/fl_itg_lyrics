import 'package:equatable/equatable.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

abstract class LyricSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TextChanged extends LyricSearchEvent {
  final String query;

  TextChanged({required this.query});

  @override
  List<Object> get props => [query];

  @override
  String toString() => "LyricSearchTextChanged { query: $query }";
}

class RemoveLyric extends LyricSearchEvent {
  final int lyricID;

  RemoveLyric({required this.lyricID});

  @override
  List<Object> get props => [lyricID];

  @override
  String toString() => "Remove lyric { lyricID: $lyricID }";
}

class LyricUpdated extends LyricSearchEvent {
  final LyricsEntity lyric;

  LyricUpdated({required this.lyric});

  @override
  List<Object> get props => [lyric];

  @override
  String toString() => "Update lyric { lyric: $lyric }";
}

class LyricAdded extends LyricSearchEvent {
  final LyricsEntity lyric;

  LyricAdded({required this.lyric});

  @override
  List<Object> get props => [lyric];

  @override
  String toString() => "AddedLyric { lyric: $lyric }";
}
