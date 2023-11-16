import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:core/presentation/blocs/movie/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/movie/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMoviesBloc watchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMoviesBloc = WatchlistMoviesBloc(mockGetWatchlistMovies);
  });

  final tMoviesList = <Movie>[testWatchlistMovie];

  group('Watchlist Movie Bloc --> ', () {
    test('initial state should be empty', () {
      expect(watchlistMoviesBloc.state, WatchlistMoviesEmpty());
    });

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Empty] when data watchlist movie is empty',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesEmpty(),
      ],
      verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, HasData] when data watchlist movie is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(tMoviesList));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesHasData(tMoviesList),
      ],
      verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
    );

    blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
      'Should emit [Loading, Error] when get watchlist movie is unsuccessful',
      build: () {
        when(mockGetWatchlistMovies.execute()).thenAnswer(
            (_) async => const Left(DatabaseFailure('Database Failure')));
        return watchlistMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMoviesLoading(),
        WatchlistMoviesError('Database Failure'),
      ],
      verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
    );
  });
}
