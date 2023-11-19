// coverage:ignore-file

part of 'popular_tv_series_bloc.dart';

abstract class PopularTvSeriesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchPopularTvSeries extends PopularTvSeriesEvent {}
