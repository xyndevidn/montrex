part of 'detail_tv_series_bloc.dart';

abstract class DetailTvSeriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDetailTvSeries extends DetailTvSeriesEvent {
  final int id;

  FetchDetailTvSeries(this.id);
  @override
  List<Object?> get props => [id];
}

class AddWatchlistTvSeries extends DetailTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  AddWatchlistTvSeries(this.tvSeriesDetail);
  @override
  List<Object?> get props => [TvSeriesDetail];
}

class RemoveFromWatchlistTvSeries extends DetailTvSeriesEvent {
  final TvSeriesDetail tvSeriesDetail;

  RemoveFromWatchlistTvSeries(this.tvSeriesDetail);
  @override
  List<Object?> get props => [TvSeriesDetail];
}

class LoadWatchlistStatusTvSeries extends DetailTvSeriesEvent {
  final int id;

  LoadWatchlistStatusTvSeries(this.id);
  @override
  List<Object?> get props => [id];
}
