import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/usecases/movie/get_movie_detail.dart';
import 'package:core/domain/usecases/movie/get_movie_recommendations.dart';
import 'package:core/domain/usecases/movie/get_watchlist_movie_status.dart';
import 'package:core/domain/usecases/movie/remove_watchlist_movie.dart';
import 'package:core/domain/usecases/movie/save_watchlist_movie.dart';
import 'package:core/presentation/blocs/movie/detail_movie/detail_movie_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/movie/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListMovieStatus,
  SaveWatchlistMovie,
  RemoveWatchlistMovie,
])
void main() {
  late DetailMovieBloc detailMovieBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListMovieStatus mockGetWatchListMovieStatus;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListMovieStatus = MockGetWatchListMovieStatus();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    detailMovieBloc = DetailMovieBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      saveWatchlistMovie: mockSaveWatchlistMovie,
      removeWatchlistMovie: mockRemoveWatchlistMovie,
      getWatchListMovieStatus: mockGetWatchListMovieStatus,
    );
  });

  const tId = 1;

  group('Get Detail Movie & Get Recommendation --> ', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [DetailMovieError] when get detail movie failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed')));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(FetchDetailMovie(tId)),
      expect: () => [
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loading,
        ),
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [DetailMovieLoading, RecomendationLoading, DetailMovieLoaded, RecommendationError] when get recommendation movies failed',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed')));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(FetchDetailMovie(tId)),
      expect: () => [
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loading,
        ),
        DetailMovieState.initial().copyWith(
          movieRecommendationsState: RequestState.loading,
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
        ),
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationsState: RequestState.error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [DetailMovieLoading, DetailMovieLoaded, RecommendationEmpty] when get recommendation movies empty',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(FetchDetailMovie(tId)),
      expect: () => [
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loading,
        ),
        DetailMovieState.initial().copyWith(
          movieRecommendationsState: RequestState.loading,
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
        ),
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationsState: RequestState.empty,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [DetailMovieLoading, DetailMovieLoaded, RecomendationLoading, RecommendationLoaded] when get detail movie and recommendation movies success',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(FetchDetailMovie(tId)),
      expect: () => [
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loading,
        ),
        DetailMovieState.initial().copyWith(
          movieRecommendationsState: RequestState.loading,
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
        ),
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationsState: RequestState.loaded,
          movieRecommendations: testMovieList,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });

  group('Load Watchlist Movie Status --> ', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [WatchlistStatusMovie] is true',
      build: () {
        when(mockGetWatchListMovieStatus.execute(tId))
            .thenAnswer((_) async => true);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatusMovie(tId)),
      expect: () => [
        DetailMovieState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => verify(mockGetWatchListMovieStatus.execute(tId)),
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [WatchlistStatusMovie] is false',
      build: () {
        when(mockGetWatchListMovieStatus.execute(tId))
            .thenAnswer((_) async => false);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatusMovie(tId)),
      expect: () => [
        DetailMovieState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => verify(mockGetWatchListMovieStatus.execute(tId)),
    );
  });

  group('Added To Watchlist Movie --> ', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [WatchlistMovieMessage, isAddedToWatchlistMovie] when success added to watchlist',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        DetailMovieState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        DetailMovieState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [WatchlistMovieMessage, isAddedToWatchlistMovie] when failed added to watchlist',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistMovie(testMovieDetail)),
      expect: () => [
        DetailMovieState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
      },
    );
  });

  group('Remove From Watchlist Movie --> ', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [WatchlistMovieMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistMovie(testMovieDetail)),
      expect: () => [
        DetailMovieState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should emit [WatchlistMovieMessage, isAddedToWatchlist] when failed removed from watchlist',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistMovie(testMovieDetail)),
      expect: () => [
        DetailMovieState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
      },
    );
  });
}
