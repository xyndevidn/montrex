part of 'now_playing_tv_series_bloc.dart';

abstract class NowPlayingTvSeriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NowPlayingTvSeriesEmpty extends NowPlayingTvSeriesState {}

class NowPlayingTvSeriesLoading extends NowPlayingTvSeriesState {}

class NowPlayingTvSeriesHasData extends NowPlayingTvSeriesState {
  final List<TvSeries> result;

  NowPlayingTvSeriesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class NowPlayingTvSeriesError extends NowPlayingTvSeriesState {
  final String message;

  NowPlayingTvSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}
