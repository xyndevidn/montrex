import 'package:montrex/domain/repositories/tv_series_repository.dart';

class GetWatchListTvSeriesStatus {
  final TvSeriesRepository repository;

  GetWatchListTvSeriesStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlistTvSeries(id);
  }
}