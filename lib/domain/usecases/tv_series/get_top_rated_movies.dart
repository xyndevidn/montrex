import 'package:dartz/dartz.dart';
import 'package:montrex/common/failure.dart';
import 'package:montrex/domain/entities/tv_series.dart';
import 'package:montrex/domain/repositories/tv_series_repository.dart';

class GetTopRatedTvSeries {
  final TvSeriesRepository repository;

  GetTopRatedTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getTopRatedTvSeries();
  }
}
