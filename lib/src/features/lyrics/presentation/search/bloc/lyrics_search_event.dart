import 'package:equatable/equatable.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

abstract class LyricsSearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LyricsSearchTextChangedEvent extends LyricsSearchEvent {
  final String query;

  LyricsSearchTextChangedEvent({required this.query});

  @override
  List<Object> get props => [query];

  @override
  String toString() => "LyricsSearchTextChangedEvent { query: $query }";
}

class LyricsSearchLyricAddedEvent extends LyricsSearchEvent {
  final LyricsEntity lyric;

  LyricsSearchLyricAddedEvent({required this.lyric});

  @override
  List<Object> get props => [lyric];

  @override
  String toString() => "LyricsSearchLyricAddedEvent { lyric: $lyric }";
}

class LyricsSearchLyricUpdatedEvent extends LyricsSearchEvent {
  final LyricsEntity lyric;

  LyricsSearchLyricUpdatedEvent({required this.lyric});

  @override
  List<Object> get props => [lyric];

  @override
  String toString() => "LyricsSearchLyricUpdatedEvent { lyric: $lyric }";
}

class LyricsSearchLyricRemovedEvent extends LyricsSearchEvent {
  final int lyricID;

  LyricsSearchLyricRemovedEvent({required this.lyricID});

  @override
  List<Object> get props => [lyricID];

  @override
  String toString() => "LyricsSearchRemoveLyricEvent { lyricID: $lyricID }";
}

