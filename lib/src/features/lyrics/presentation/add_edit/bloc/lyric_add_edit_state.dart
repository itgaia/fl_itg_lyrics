import 'package:equatable/equatable.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

abstract class LyricAddEditState extends Equatable {
  @override
  List<Object> get props => [];
}

class StateShowLyric extends LyricAddEditState {
  @override
  String toString() => 'SearchStateEmpty';
}

class StateLoading extends LyricAddEditState {
  @override
  String toString() => 'SearchStateLoading';
}

class AddLyricStateSuccess extends LyricAddEditState {
  final LyricsEntity lyric;

  AddLyricStateSuccess(this.lyric);

  @override
  List<Object> get props => [lyric];

  @override
  String toString() => 'AddLyricSuccess {lyric: $lyric }';
}

class AddLyricStateFailure extends LyricAddEditState {
  @override
  String toString() => 'AddLyricStateFailure';
}

class EditLyricStateSuccess extends LyricAddEditState {
  final LyricsModel lyric;

  EditLyricStateSuccess(this.lyric);

  @override
  List<Object> get props => [lyric];

  @override
  String toString() => 'EditLyricSuccess {lyric: $lyric }';
}

class EditLyricStateFailure extends LyricAddEditState {
  @override
  String toString() => 'EditLyricStateFailure';
}
