import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:core/common/exception.dart';
import 'package:core/common/failure.dart';
import 'package:core/data/datasources/tv_series/tv_series_local_data_source.dart';
import 'package:core/data/datasources/tv_series/tv_series_remote_data_source.dart';
import 'package:core/data/models/tv_series_table.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/entities/tv_series_detail.dart';
import 'package:core/domain/repositories/tv_series_repository.dart';

class TvSeriesRepositoryImpl extends TvSeriesRepository {
  final TvSeriesRemoteDataSource remoteDataSource;
  final TvSeriesLocalDataSource localDataSource;

  TvSeriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries() async {
    try {
      final result = await remoteDataSource.getNowPlayingTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } on ServerException {
      return const Left(ServerFailure('Failed to connect to the server'));
    } on TlsException catch (e) {
      return Left(CertificateFailure('Certificated Not Valid:\n${e.message}'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() async {
    try {
      final result = await remoteDataSource.getPopularTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } on ServerException {
      return const Left(ServerFailure('Failed to connect to the server'));
    } on TlsException catch (e) {
      return Left(CertificateFailure('Certificated Not Valid:\n${e.message}'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() async {
    try {
      final result = await remoteDataSource.getTopRatedTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } on ServerException {
      return const Left(ServerFailure('Failed to connect to the server'));
    } on TlsException catch (e) {
      return Left(CertificateFailure('Certificated Not Valid:\n${e.message}'));
    }
  }

  @override
  Future<Either<Failure, TvSeriesDetail>> getTvSeriesDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesDetail(id);
      return Right(result.toEntity());
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } on ServerException {
      return const Left(ServerFailure('Failed to connect to the server'));
    } on TlsException catch (e) {
      return Left(CertificateFailure('Certificated Not Valid:\n${e.message}'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(
      int id) async {
    try {
      final result = await remoteDataSource.getTvSeriesRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } on ServerException {
      return const Left(ServerFailure('Failed to connect to the server'));
    } on TlsException catch (e) {
      return Left(CertificateFailure('Certificated Not Valid:\n${e.message}'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> searchTvSeries(String query) async {
    try {
      final result = await remoteDataSource.searchTvSeries(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    } on ServerException {
      return const Left(ServerFailure('Failed to connect to the server'));
    } on TlsException catch (e) {
      return Left(CertificateFailure('Certificated Not Valid:\n${e.message}'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() async {
    final result = await localDataSource.getWatchlistTvSeries();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<bool> isAddedToWatchlistTvSeries(int id) async {
    final result = await localDataSource.getTvSeriesById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlistTvSeries(
      TvSeriesDetail tvSeries) async {
    try {
      final result = await localDataSource
          .removeWatchlistTvSeries(TvSeriesTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlistTvSeries(
      TvSeriesDetail tvSeries) async {
    try {
      final result = await localDataSource
          .insertWatchlistTvSeries(TvSeriesTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }
}
