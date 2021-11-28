import 'package:dartz/dartz.dart';
import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/core/usecases/usecase.dart';

import 'lyrics_entity.dart';
import 'lyrics_repository.dart';

class GetLyricsUsecase implements UseCase<List<LyricsEntity>, NoParams> {
  final LyricsRepository repository;

  GetLyricsUsecase(this.repository);

  @override
  Future<Either<Failure, List<LyricsEntity>>> call(NoParams params) async {
    return repository.getLyrics();
  }
}
