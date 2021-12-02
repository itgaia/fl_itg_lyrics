import 'package:equatable/equatable.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

abstract class LyricsSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class LyricsSearchEmptyState extends LyricsSearchState {
  @override
  String toString() => 'LyricsSearchEmptyState';
}

class LyricsSearchLoadingState extends LyricsSearchState {
  @override
  String toString() => 'LyricsSearchLoadingState';
}

class LyricsSearchSuccessState extends LyricsSearchState {
  final List<LyricsEntity> lyrics;
  final String query;

  LyricsSearchSuccessState(this.lyrics, this.query);

  @override
  List<Object> get props => [lyrics, query];

  @override
  String toString() => 'LyricsSearchSuccessState { lyrics: ${lyrics.length} }';
}

class LyricsSearchErrorState extends LyricsSearchState {
  final String error;

  LyricsSearchErrorState(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LyricsSearchErrorState { error: $error }';
}
