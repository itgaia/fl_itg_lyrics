import 'package:equatable/equatable.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

abstract class LyricsAddEditState extends Equatable {
  @override
  List<Object> get props => [];
}

class LyricsAddEditShowLyricState extends LyricsAddEditState {
  @override
  String toString() => 'LyricsAddEditShowLyricState';
}

class LyricsAddEditLoadingState extends LyricsAddEditState {
  @override
  String toString() => 'LyricsAddEditLoadingState';
}

class LyricsAddEditAddLyricSuccessState extends LyricsAddEditState {
  final LyricsEntity lyric;

  LyricsAddEditAddLyricSuccessState(this.lyric);

  @override
  List<Object> get props => [lyric];

  @override
  String toString() => 'LyricsAddEditAddLyricSuccessState {lyric: $lyric }';
}

class LyricsAddEditAddLyricFailureState extends LyricsAddEditState {
  @override
  String toString() => 'LyricsAddEditAddLyricFailureState';
}

class LyricsAddEditEditLyricSuccessState extends LyricsAddEditState {
  final LyricsEntity lyric;

  LyricsAddEditEditLyricSuccessState(this.lyric);

  @override
  List<Object> get props => [lyric];

  @override
  String toString() => 'LyricsAddEditEditLyricSuccessState {lyric: $lyric }';
}

class LyricsAddEditEditLyricFailureState extends LyricsAddEditState {
  @override
  String toString() => 'LyricsAddEditEditLyricFailureState';
}
