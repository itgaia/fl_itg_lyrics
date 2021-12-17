import 'package:dartz/dartz.dart';
import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/core/usecases/usecase.dart';

import 'lyrics_entity.dart';
import 'lyrics_repository.dart';

class SearchLyricsUsecase implements UseCase<List<LyricsEntity>, String> {
  final LyricsRepository repository;

  SearchLyricsUsecase(this.repository);

  @override
  Future<Either<Failure, List<LyricsEntity>>> call(String query) async {
    print('>>> SearchLyricsUsecase - query: $query');
    return repository.searchLyrics(query);
  }
}
