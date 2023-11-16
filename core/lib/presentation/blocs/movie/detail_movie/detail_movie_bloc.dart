import 'package:core/domain/usecases/movie/get_movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:core/domain/usecases/movie/get_watchlist_movie_status.dart';
import 'package:core/domain/usecases/movie/remove_watchlist_movie.dart';
import 'package:core/domain/usecases/movie/save_watchlist_movie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/state_enum.dart';
import '../../../../domain/entities/movie.dart';
import '../../../../domain/entities/movie_detail.dart';

part 'detail_movie_event.dart';
part 'detail_movie_state.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final SaveWatchlistMovie saveWatchlistMovie;
  final RemoveWatchlistMovie removeWatchlistMovie;
  final GetWatchListMovieStatus getWatchListMovieStatus;

  DetailMovieBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.saveWatchlistMovie,
    required this.removeWatchlistMovie,
    required this.getWatchListMovieStatus,
  }) : super(DetailMovieState.initial()) {
    on<FetchDetailMovie>((event, emit) async {
      emit(state.copyWith(movieDetailState: RequestState.loading));

      final id = event.id;

      final detailMovieResult = await getMovieDetail.execute(id);
      final recommendationMoviesResult =
          await getMovieRecommendations.execute(id);

      detailMovieResult.fold(
        (failure) => emit(
          state.copyWith(
            movieDetailState: RequestState.error,
            message: failure.message,
          ),
        ),
        (movieDetail) {
          emit(
            state.copyWith(
              movieRecommendationsState: RequestState.loading,
              movieDetailState: RequestState.loaded,
              movieDetail: movieDetail,
            ),
          );
          recommendationMoviesResult.fold(
            (failure) => emit(
              state.copyWith(
                movieRecommendationsState: RequestState.error,
                message: failure.message,
              ),
            ),
            (movieRecommendations) {
              if (movieRecommendations.isEmpty) {
                emit(
                  state.copyWith(
                    movieRecommendationsState: RequestState.empty,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    movieRecommendationsState: RequestState.loaded,
                    movieRecommendations: movieRecommendations,
                  ),
                );
              }
            },
          );
        },
      );
    });

    on<AddWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await saveWatchlistMovie.execute(movieDetail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusMovie(movieDetail.id));
    });

    on<RemoveFromWatchlistMovie>((event, emit) async {
      final movieDetail = event.movieDetail;
      final result = await removeWatchlistMovie.execute(movieDetail);

      result.fold(
        (failure) => emit(state.copyWith(watchlistMessage: failure.message)),
        (successMessage) =>
            emit(state.copyWith(watchlistMessage: successMessage)),
      );

      add(LoadWatchlistStatusMovie(movieDetail.id));
    });

    on<LoadWatchlistStatusMovie>((event, emit) async {
      final status = await getWatchListMovieStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: status));
    });
  }
}
