import 'package:equatable/equatable.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

abstract class LyricSearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends LyricSearchState {
  @override
  String toString() => 'SearchStateEmpty';
}

class SearchStateLoading extends LyricSearchState {
  @override
  String toString() => 'SearchStateLoading';
}

class SearchStateSuccess extends LyricSearchState {
  final List<LyricsEntity> lyrics;
  final String query;

  SearchStateSuccess(this.lyrics, this.query);

  @override
  List<Object> get props => [lyrics, query];

  @override
  String toString() => 'SearchStateSuccess { lyrics: ${lyrics.length} }';
}

class SearchStateError extends LyricSearchState {
  final String error;

  SearchStateError(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SearchStateError { error: $error }';
}
