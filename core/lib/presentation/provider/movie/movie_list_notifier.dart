import 'package:flutter/material.dart';
import '../../../domain/entities/movie.dart';
import '../../../common/state_enum.dart';
import '../../../domain/usecases/movie/get_top_rated_movies.dart';

class MovieListNotifier extends ChangeNotifier {
  var _topRatedMovies = <Movie>[];
  List<Movie> get topRatedMovies => _topRatedMovies;

  RequestState _topRatedMoviesState = RequestState.empty;
  RequestState get topRatedMoviesState => _topRatedMoviesState;

  String _message = '';
  String get message => _message;

  MovieListNotifier({
    required this.getTopRatedMovies,
  });

  final GetTopRatedMovies getTopRatedMovies;

  Future<void> fetchTopRatedMovies() async {
    _topRatedMoviesState = RequestState.loading;
    notifyListeners();

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) {
        _topRatedMoviesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _topRatedMoviesState = RequestState.loaded;
        _topRatedMovies = moviesData;
        notifyListeners();
      },
    );
  }
}
