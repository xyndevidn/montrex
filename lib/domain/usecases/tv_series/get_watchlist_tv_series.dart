import 'package:dartz/dartz.dart';
import 'package:montrex/common/failure.dart';
import 'package:montrex/domain/entities/tv_series.dart';
import 'package:montrex/domain/repositories/tv_series_repository.dart';

class GetWatchlistTvSeries {
  final TvSeriesRepository _repository;

  GetWatchlistTvSeries(this._repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return _repository.getWatchlistTvSeries();
  }
}
