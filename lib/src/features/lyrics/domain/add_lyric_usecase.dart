import 'package:dartz/dartz.dart';
import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/core/usecases/usecase.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';

import 'lyrics_entity.dart';
import 'lyrics_repository.dart';

class AddLyricUsecase implements UseCase<LyricsEntity, LyricsModel> {
  final LyricsRepository repository;

  AddLyricUsecase(this.repository);

  @override
  Future<Either<Failure, LyricsEntity>> call(LyricsModel lyric) async {
    return repository.addLyric(lyric);
  }
}
