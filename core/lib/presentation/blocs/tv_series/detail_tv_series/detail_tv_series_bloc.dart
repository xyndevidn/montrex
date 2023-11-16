import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/tv_series_detail.dart';
import '../../../../domain/usecases/tv_series/get_tv_series_recommendations.dart';
import '../../../../domain/usecases/tv_series/get_watchlist_tv_series_status.dart';
import '../../../../domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import '../../../../domain/usecases/tv_series/save_watchlist_tv_series.dart';

part 'detail_tv_series_event.dart';
part 'detail_tv_series_state.dart';

class DetailTvSeriesBloc
    extends Bloc<DetailTvSeriesEvent, DetailTvSeriesState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist Tv Series';
  static const watchlistRemoveSuccessMessage =
      'Removed from Watchlist Tv Series';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;
  final GetWatchListTvSeriesStatus getWatchListTvSeriesStatus;

  DetailTvSeriesBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
    required this.getWatchListTvSeriesStatus,
  }) : super(DetailTvSeriesState.initial()) {
    on<FetchDetailTvSeries>((event, emit) async {
      emit(state.copyWith(tvSeriesDetailState: RequestState.loading));

      final id = event.id;

      final detailTvSeriesResult = await getTvSeriesDetail.execute(id);
      final recommendationTvSeriessResult =
          await getTvSeriesRecommendations.execute(id);

      detailTvSeriesResult.fold(
        (failure) => emit(
          state.copyWith(
            tvSeriesDetailState: RequestState.error,
            message: failure.message,
          ),
        ),
        (tvSeriesDetail) {
          emit(
            state.copyWith(
              tvSeriesRecommendationsState: RequestState.loading,
              tvSeriesDetailState: RequestState.loaded,
              tvSeriesDetail: tvSeriesDetail,
            ),
          );
          recommendationTvSeriessResult.fold(
            (failure) => emit(
              state.copyWith(
                tvSeriesRecommendationsState: RequestState.error,
                message: failure.message,
              ),
            ),
            (tvSeriesRecommendations) {
              if (tvSeriesRecommendations.isEmpty) {
                emit(
                  state.copyWith(
                    tvSeriesRecommendationsState: RequestState.empty,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    tvSeriesRecommendationsState: RequestState.loaded,
                    tvSeriesRecommendations: tvSeriesRecommendations,
                  ),
                );
              }
            },
          );
        },
      );
    });

    on<AddWatchlistTvSeries>((event, emit) async {
      final tvSeriesDetail = event.tvSeriesDetail;
      final result = await saveWatchlistTvSeries.execute(tvSeriesDetail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusTvSeries(tvSeriesDetail.id));
    });

    on<RemoveFromWatchlistTvSeries>((event, emit) async {
      final tvSeriesDetail = event.tvSeriesDetail;
      final result = await removeWatchlistTvSeries.execute(tvSeriesDetail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusTvSeries(tvSeriesDetail.id));
    });

    on<LoadWatchlistStatusTvSeries>((event, emit) async {
      final status = await getWatchListTvSeriesStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });
  }
}
