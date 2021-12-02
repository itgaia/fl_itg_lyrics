import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/add_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/edit_lyric_usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';

import 'lyric_add_edit.dart';

class LyricAddEditBloc extends Cubit<LyricsAddEditState> {
  // final LyricsRepository lyricsRepository;
  final AddLyricUsecase addLyricUsecase;
  final EditLyricUsecase editLyricUsecase;

  // LyricAddEditBloc({required this.lyricsRepository}) : super(StateShowLyric());
  LyricAddEditBloc({required this.addLyricUsecase, required this.editLyricUsecase}) : super(LyricsAddEditShowLyricState());

  Future<Either<Failure, void>> addLyric(LyricsModel lyric) async {
    emit(LyricsAddEditLoadingState());
    // final failureOrLyric = await lyricsRepository.addLyric(lyric);
    final failureOrLyric = await addLyricUsecase(lyric);
    if (failureOrLyric.isRight()) {
      emit(LyricsAddEditAddLyricSuccessState(failureOrLyric.toOption().toNullable()!));
    } else {
      emit(LyricsAddEditAddLyricFailureState());
    }
    return Right(Future.value(null));
  }

  Future<void> editLyric(LyricsModel lyric) async {
    emit(LyricsAddEditLoadingState());
    // final failureOrLyric = await lyricsRepository.editLyric(lyric);
    final failureOrLyric = await editLyricUsecase(lyric);
    if (failureOrLyric.isRight()) {
      emit(LyricsAddEditEditLyricSuccessState(failureOrLyric.toOption().toNullable()!));
    } else {
      emit(LyricsAddEditEditLyricFailureState());
    }
  }
}
