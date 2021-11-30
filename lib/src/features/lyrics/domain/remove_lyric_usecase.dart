import 'package:dartz/dartz.dart';
import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/core/usecases/usecase.dart';

import 'lyrics_entity.dart';
import 'lyrics_repository.dart';

class RemoveLyricUsecase implements UseCase<void, int> {
  final LyricsRepository repository;

  RemoveLyricUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) async {
    return repository.removeLyric(id);
  }
}
