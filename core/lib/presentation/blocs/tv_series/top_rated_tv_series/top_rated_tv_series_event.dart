// coverage:ignore-file

part of 'top_rated_tv_series_bloc.dart';

abstract class TopRatedTvSeriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTopRatedTvSeries extends TopRatedTvSeriesEvent {}
