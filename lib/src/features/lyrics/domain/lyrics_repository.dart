import 'package:dartz/dartz.dart';

import 'package:itg_lyrics/src/core/error/failures.dart';
import 'lyrics_entity.dart';

abstract class LyricsRepository {
  Future<Either<Failure, List<LyricsEntity>>> getLyrics();
}
