import 'package:dartz/dartz.dart';
import 'package:montrex/common/failure.dart';
import 'package:montrex/domain/entities/tv_series_detail.dart';
import 'package:montrex/domain/repositories/tv_series_repository.dart';

class RemoveWatchlistTvSeries {
  final TvSeriesRepository repository;

  RemoveWatchlistTvSeries(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail tvSeries) {
    return repository.removeWatchlistTvSeries(tvSeries);
  }
}
