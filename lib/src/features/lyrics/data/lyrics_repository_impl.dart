import 'package:dartz/dartz.dart';
import 'package:itg_lyrics/src/core/error/exception.dart';
import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/core/network/network_info.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_repository.dart';

import 'lyrics_local_datasource.dart';
import 'lyrics_model.dart';
import 'lyrics_remote_datasource.dart';

class LyricsRepositoryImpl implements LyricsRepository {
  final LyricsRemoteDataSource remoteDataSource;
  final LyricsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  LyricsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LyricsEntity>>> getLyrics() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteLyrics = await remoteDataSource.getLyrics();
        localDataSource.cacheLyrics(remoteLyrics as List<LyricsModel>);
        return Right(remoteLyrics);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localLyrics = await localDataSource.getLastLyrics();
        return Right(localLyrics);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
