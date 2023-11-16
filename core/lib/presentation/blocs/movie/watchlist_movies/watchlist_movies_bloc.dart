import 'package:core/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/movie.dart';

part 'watchlist_movies_event.dart';
part 'watchlist_movies_state.dart';

class WatchlistMoviesBloc
    extends Bloc<WatchlistMoviesEvent, WatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;

  WatchlistMoviesBloc(this._getWatchlistMovies)
      : super(WatchlistMoviesEmpty()) {
    on<FetchWatchlistMovies>((event, emit) async {
      emit(WatchlistMoviesLoading());

      final result = await _getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(WatchlistMoviesError(failure.message)),
        (data) {
          if (data.isEmpty) {
            emit(WatchlistMoviesEmpty());
          } else {
            emit(WatchlistMoviesHasData(data));
          }
        },
      );
    });
  }
}
