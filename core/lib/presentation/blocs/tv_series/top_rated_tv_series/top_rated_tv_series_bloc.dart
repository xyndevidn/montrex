import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/tv_series.dart';
import '../../../../domain/usecases/tv_series/get_top_rated_movies.dart';

part 'top_rated_tv_series_event.dart';
part 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc
    extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this._getTopRatedTvSeries)
      : super(TopRatedTvSeriesEmpty()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(TopRatedTvSeriesLoading());

      final result = await _getTopRatedTvSeries.execute();

      result.fold(
        (failure) => emit(TopRatedTvSeriesError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(TopRatedTvSeriesEmpty());
          } else {
            emit(TopRatedTvSeriesHasData(data));
          }
        },
      );
    });
  }
}
