part of 'lyrics_bloc.dart';

abstract class LyricsState extends Equatable {
  const LyricsState();

  @override
  List<Object> get props => [];
}

class Empty extends LyricsState {}

class Loading extends LyricsState {}

class Loaded extends LyricsState {
  final List<LyricsEntity> lyrics;
  final bool hasReachedMax;

  const Loaded({
    required this.lyrics,
    this.hasReachedMax = false,
  });
}

class Error extends LyricsState {
  final String message;

  const Error({required this.message});
}
