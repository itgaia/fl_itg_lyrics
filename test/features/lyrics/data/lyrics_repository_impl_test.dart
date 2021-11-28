import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:itg_lyrics/src/core/error/exception.dart';
import 'package:itg_lyrics/src/core/error/failures.dart';
import 'package:itg_lyrics/src/core/network/network_info.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_local_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_model.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_remote_datasource.dart';
import 'package:itg_lyrics/src/features/lyrics/data/lyrics_repository_impl.dart';
import 'package:itg_lyrics/src/features/lyrics/domain/lyrics_entity.dart';
import 'package:mocktail/mocktail.dart';

import '../../../test_helper.dart';
import '../lyrics_test_helper.dart';

void main() {
  late LyricsRepositoryImpl repository;
  late MockLyricsRemoteDataSource mockRemoteDataSource;
  late MockLyricsLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockLyricsRemoteDataSource();
    mockLocalDataSource = MockLyricsLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = LyricsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void _runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void _runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getLyrics', () {
    final tLyricsModelList = lyricsTestData();
    final List<LyricsEntity> tLyricsEntityList = tLyricsModelList;

    test('should check if the device is online', () {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // don't know why this makes the test pass...
      when(() => mockRemoteDataSource.getLyrics())
        .thenAnswer((_) async => tLyricsModelList);
      when(() => mockLocalDataSource
        .cacheLyrics(tLyricsEntityList as List<LyricsModel>))
        .thenAnswer((_) async => tLyricsModelList);
      // act
      repository.getLyrics();
      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    _runTestsOnline(() {
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getLyrics())
          .thenAnswer((_) async => tLyricsModelList);
        when(() => mockLocalDataSource
          .cacheLyrics(tLyricsEntityList as List<LyricsModel>))
          .thenAnswer((_) async => tLyricsModelList);
        // act
        final result = await repository.getLyrics();
        // assert
        verify(() => mockRemoteDataSource.getLyrics());
        expect(result, equals(Right(tLyricsEntityList)));
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getLyrics())
          .thenAnswer((_) async => tLyricsModelList);
        when(() => mockLocalDataSource
          .cacheLyrics(tLyricsEntityList as List<LyricsModel>))
          .thenAnswer((_) async => tLyricsModelList);
        // act
        await repository.getLyrics();
        // assert
        verify(() => mockRemoteDataSource.getLyrics());
        verify(() => mockLocalDataSource
          .cacheLyrics(tLyricsEntityList as List<LyricsModel>));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(() => mockRemoteDataSource.getLyrics())
          .thenThrow(ServerException());
        // act
        final result = await repository.getLyrics();
        // assert
        verify(() => mockRemoteDataSource.getLyrics());
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    _runTestsOffline(() {
      test(
          'should return last locally cached data when the cached data is present',
          () async {
        //arrange
        when(() => mockLocalDataSource.getLastLyrics())
          .thenAnswer((_) async => tLyricsModelList);
        // act
        final result = await repository.getLyrics();
        // asssert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastLyrics());
        expect(result, equals(Right(tLyricsEntityList)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(() => mockLocalDataSource.getLastLyrics())
          .thenThrow(CacheException());
        // act
        final result = await repository.getLyrics();
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getLastLyrics());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
