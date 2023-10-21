import 'package:dartz/dartz.dart';
import '../../../domain/entities/tv_series_detail.dart';
import '../../../domain/repositories/tv_series_repository.dart';
import '../../../utils/failure.dart';

class RemoveWatchlistTvSeries {
  final TvSeriesRepository repository;

  RemoveWatchlistTvSeries(this.repository);

  Future<Either<Failure, String>> execute(TvSeriesDetail tvSeries) {
    return repository.removeWatchlistTvSeries(tvSeries);
  }
}
