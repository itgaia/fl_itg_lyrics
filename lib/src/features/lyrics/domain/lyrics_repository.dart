import 'package:dartz/dartz.dart';

import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'lyrics_entity.dart';

abstract class LyricsRepository {
  Future<Either<Failure, List<LyricsEntity>>> getLyrics();

  Future<Either<Failure, List<LyricsEntity>>> searchLyrics(String query);
  Future<Either<Failure, void>> removeLyric(int id);
  Future<Either<Failure, LyricsModel>> addLyric(LyricsModel lyric);
  Future<Either<Failure, LyricsModel>> editLyric(LyricsModel lyric);
}
