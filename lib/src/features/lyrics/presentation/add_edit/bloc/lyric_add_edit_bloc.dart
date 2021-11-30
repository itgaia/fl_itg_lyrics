import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';

import 'lyric_add_edit.dart';

class LyricAddEditBloc extends Cubit<LyricAddEditState> {
  final LyricsRepository lyricsRepository;

  LyricAddEditBloc({required this.lyricsRepository}) : super(StateShowLyric());

  Future<Either<Failure, void>> addLyric(LyricsModel lyric) async {
    emit(StateLoading());
    final failureOrLyric = await lyricsRepository.addLyric(lyric);
    if (failureOrLyric.isRight()) {
      emit(AddLyricStateSuccess(failureOrLyric.toOption().toNullable()!));
    } else {
      emit(AddLyricStateFailure());
    }
    return Right(Future.value(null));
  }

  Future<void> editLyric(LyricsModel lyric) async {
    emit(StateLoading());
    final failureOrLyric = await lyricsRepository.editLyric(lyric);
    if (failureOrLyric.isRight()) {
      emit(EditLyricStateSuccess(failureOrLyric.toOption().toNullable()!));
    } else {
      emit(EditLyricStateFailure());
    }
  }
}
