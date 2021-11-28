import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/core/usecases/usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/get_lyrics_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';

part 'lyrics_event.dart';
part 'lyrics_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class LyricsBloc extends Bloc<LyricsEvent, LyricsState> {
  final GetLyricsUsecase getLyricsUsecase;

  LyricsBloc({
    required GetLyricsUsecase lyrics,
  })  : getLyricsUsecase = lyrics,
        super(Empty());

  @override
  Stream<LyricsState> mapEventToState(
    LyricsEvent event,
  ) async* {
    if (event is GetLyricsEvent) {
      yield Loading();
      final failureOrLyrics = await getLyricsUsecase(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrLyrics);
      if (failureOrLyrics.isRight()) {
        final lyrics = failureOrLyrics.toOption().toNullable()!;
        if (lyrics.isEmpty) yield Empty();
      }
    }
  }

  Stream<LyricsState> _eitherLoadedOrErrorState(
      Either<Failure, List<LyricsEntity>> failureOrLyrics) async* {
    yield failureOrLyrics.fold(
        (failure) => Error(message: _mapFailureToMessage(failure)),
        (lyrics) => Loaded(lyrics: lyrics));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
