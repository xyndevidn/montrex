import 'package:dartz/dartz.dart';
import '../../../domain/entities/tv_series.dart';
import '../../../domain/repositories/tv_series_repository.dart';
import '../../../utils/failure.dart';

class GetNowPlayingTvSeries {
  final TvSeriesRepository repository;

  GetNowPlayingTvSeries(this.repository);

  Future<Either<Failure, List<TvSeries>>> execute() {
    return repository.getNowPlayingTvSeries();
  }
}
