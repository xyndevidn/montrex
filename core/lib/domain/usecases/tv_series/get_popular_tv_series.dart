import 'package:dartz/dartz.dart';
import '../../../domain/entities/tv_series.dart';
import '../../../domain/repositories/tv_series_repository.dart';
import '../../../utils/failure.dart';

class GetPopularTvSeries {
  final TvSeriesRepository repository;

  GetPopularTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getPopularTvSeries();
  }
}
