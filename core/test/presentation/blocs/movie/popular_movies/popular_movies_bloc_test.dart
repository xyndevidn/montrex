import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/movie/get_popular_movies.dart';
import 'package:core/presentation/blocs/movie/popular_movies/popular_movies_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/movie/dummy_objects.dart';
import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc popularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });

  final tMoviesList = <Movie>[testMovie];

  group('Popular Movies Bloc -->', () {
    test('initial state should be empty', () {
      expect(popularMoviesBloc.state, PopularMoviesEmpty());
    });

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'Should emit [Loading, Empty] when get popular movies is empty',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => const Right([]));
        return popularMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        PopularMoviesLoading(),
        PopularMoviesEmpty(),
      ],
      verify: (bloc) => verify(mockGetPopularMovies.execute()),
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'Should emit [Loading, HasData] when get popular movies is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMoviesList));
        return popularMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        PopularMoviesLoading(),
        PopularMoviesHasData(tMoviesList),
      ],
      verify: (bloc) => verify(mockGetPopularMovies.execute()),
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'Should emit [Loading, Error] when get popular movies is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return popularMoviesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        PopularMoviesLoading(),
        PopularMoviesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetPopularMovies.execute()),
    );
  });
}
