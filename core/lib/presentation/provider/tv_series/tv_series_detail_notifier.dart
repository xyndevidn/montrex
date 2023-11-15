import 'package:flutter/material.dart';
import '../../../common/state_enum.dart';
import '../../../domain/entities/tv_series.dart';
import '../../../domain/entities/tv_series_detail.dart';
import '../../../domain/usecases/tv_series/get_tv_series_detail.dart';
import '../../../domain/usecases/tv_series/get_tv_series_recommendations.dart';
import '../../../domain/usecases/tv_series/get_watchlist_tv_series_status.dart';
import '../../../domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import '../../../domain/usecases/tv_series/save_watchlist_tv_series.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist Tv Series';
  static const watchlistRemoveSuccessMessage =
      'Removed from Watchlist Tv Series';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListTvSeriesStatus getWatchListTvSeriesStatus;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListTvSeriesStatus,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  });

  late TvSeriesDetail _tvSeries;
  TvSeriesDetail get tvSeries => _tvSeries;

  RequestState _tvSeriesState = RequestState.empty;
  RequestState get tvSeriesState => _tvSeriesState;

  List<TvSeries> _tvSeriesRecommendations = [];
  List<TvSeries> get tvSeriesRecommendations => _tvSeriesRecommendations;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlistTvSeries = false;
  bool get isAddedToWatchlistTvSeries => _isAddedtoWatchlistTvSeries;

  Future<void> fetchTvSeriesDetail(int id) async {
    _tvSeriesState = RequestState.loading;
    notifyListeners();
    final detailResult = await getTvSeriesDetail.execute(id);
    final recommendationResult = await getTvSeriesRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _tvSeriesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvSeriesDetail) {
        _recommendationState = RequestState.loading;
        _tvSeries = tvSeriesDetail;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.error;
            _message = failure.message;
          },
          (tvSeries) {
            _recommendationState = RequestState.loaded;
            _tvSeriesRecommendations = tvSeries;
          },
        );
        _tvSeriesState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlistTvSeries(TvSeriesDetail tvSeries) async {
    final result = await saveWatchlistTvSeries.execute(tvSeries);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistTvSeriesStatus(tvSeries.id);
  }

  Future<void> removeFromWatchlistTvSeries(TvSeriesDetail tvSeries) async {
    final result = await removeWatchlistTvSeries.execute(tvSeries);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistTvSeriesStatus(tvSeries.id);
  }

  Future<void> loadWatchlistTvSeriesStatus(int id) async {
    final result = await getWatchListTvSeriesStatus.execute(id);
    _isAddedtoWatchlistTvSeries = result;
    notifyListeners();
  }
}
