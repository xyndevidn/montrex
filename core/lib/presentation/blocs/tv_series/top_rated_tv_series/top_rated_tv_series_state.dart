part of 'top_rated_tv_series_bloc.dart';

abstract class TopRatedTvSeriesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopRatedTvSeriesEmpty extends TopRatedTvSeriesState {}

class TopRatedTvSeriesLoading extends TopRatedTvSeriesState {}

class TopRatedTvSeriesHasData extends TopRatedTvSeriesState {
  final List<TvSeries> result;

  TopRatedTvSeriesHasData(this.result);

  @override
  List<Object?> get props => [result];
}

class TopRatedTvSeriesError extends TopRatedTvSeriesState {
  final String message;

  TopRatedTvSeriesError(this.message);

  @override
  List<Object?> get props => [message];
}
