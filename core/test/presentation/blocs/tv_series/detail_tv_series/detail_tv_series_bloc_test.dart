import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:core/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:core/domain/usecases/tv_series/get_watchlist_tv_series_status.dart';
import 'package:core/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:core/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:core/presentation/blocs/tv_series/detail_tv_series/detail_tv_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/tv_series/dummy_objects.dart';
import 'detail_tv_series_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListTvSeriesStatus,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late DetailTvSeriesBloc detailTvSeriesBloc;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late MockGetWatchListTvSeriesStatus mockGetWatchListTvSeriesStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlistTvSeries;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlistTvSeries;

  setUp(() {
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchListTvSeriesStatus = MockGetWatchListTvSeriesStatus();
    mockSaveWatchlistTvSeries = MockSaveWatchlistTvSeries();
    mockRemoveWatchlistTvSeries = MockRemoveWatchlistTvSeries();
    detailTvSeriesBloc = DetailTvSeriesBloc(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
      saveWatchlistTvSeries: mockSaveWatchlistTvSeries,
      removeWatchlistTvSeries: mockRemoveWatchlistTvSeries,
      getWatchListTvSeriesStatus: mockGetWatchListTvSeriesStatus,
    );
  });

  const tId = 1;

  group('Get Detail Tv Series & Get Recommendation --> ', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [DetailTvSeriesError] when get detail TvSeries failed',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed')));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [DetailTvSeriesLoading, RecomendationLoading, DetailTvSeriesLoaded, RecommendationError] when get recommendation tv series failed',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ConnectionFailure('Failed')));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesRecommendationsState: RequestState.loading,
          tvSeriesDetailState: RequestState.loaded,
          tvSeriesDetail: testTvSeriesDetail,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.loaded,
          tvSeriesDetail: testTvSeriesDetail,
          tvSeriesRecommendationsState: RequestState.error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [DetailTvSeriesLoading, DetailTvSeriesLoaded, RecommendationEmpty] when get recommendation tv series empty',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => const Right([]));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesRecommendationsState: RequestState.loading,
          tvSeriesDetailState: RequestState.loaded,
          tvSeriesDetail: testTvSeriesDetail,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.loaded,
          tvSeriesDetail: testTvSeriesDetail,
          tvSeriesRecommendationsState: RequestState.empty,
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [DetailTvSeriesLoading, DetailTvSeriesLoaded, RecomendationLoading, RecommendationLoaded] when get detail tv series and recommendation tv series success',
      build: () {
        when(mockGetTvSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvSeriesDetail));
        when(mockGetTvSeriesRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchDetailTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.loading,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesRecommendationsState: RequestState.loading,
          tvSeriesDetailState: RequestState.loaded,
          tvSeriesDetail: testTvSeriesDetail,
        ),
        DetailTvSeriesState.initial().copyWith(
          tvSeriesDetailState: RequestState.loaded,
          tvSeriesDetail: testTvSeriesDetail,
          tvSeriesRecommendationsState: RequestState.loaded,
          tvSeriesRecommendations: testTvSeriesList,
        ),
      ],
      verify: (_) {
        verify(mockGetTvSeriesDetail.execute(tId));
        verify(mockGetTvSeriesRecommendations.execute(tId));
      },
    );
  });

  group('Load Watchlist Tv Series Status --> ', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistStatusTvSeries] is true',
      build: () {
        when(mockGetWatchListTvSeriesStatus.execute(tId))
            .thenAnswer((_) async => true);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatusTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) => verify(mockGetWatchListTvSeriesStatus.execute(tId)),
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistStatusTvSeries] is false',
      build: () {
        when(mockGetWatchListTvSeriesStatus.execute(tId))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(LoadWatchlistStatusTvSeries(tId)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(isAddedToWatchlist: false),
      ],
      verify: (_) => verify(mockGetWatchListTvSeriesStatus.execute(tId)),
    );
  });

  group('Added To Watchlist Tv Series --> ', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistTvSeriesMessage, isAddedToWatchlistTvSeries] when success added to watchlist',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListTvSeriesStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
        ),
        DetailTvSeriesState.initial().copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchListTvSeriesStatus.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistTvSeriesMessage, isAddedToWatchlistTvSeries] when failed added to watchlist',
      build: () {
        when(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchListTvSeriesStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(AddWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchListTvSeriesStatus.execute(testTvSeriesDetail.id));
      },
    );
  });

  group('Remove From Watchlist Tv Series --> ', () {
    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistTvSeriesMessage, isAddedToWatchlist] when success removed from watchlist',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(mockGetWatchListTvSeriesStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(
          watchlistMessage: 'Removed from Watchlist',
          isAddedToWatchlist: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchListTvSeriesStatus.execute(testTvSeriesDetail.id));
      },
    );

    blocTest<DetailTvSeriesBloc, DetailTvSeriesState>(
      'Should emit [WatchlistTvSeriesMessage, isAddedToWatchlist] when failed removed from watchlist',
      build: () {
        when(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchListTvSeriesStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return detailTvSeriesBloc;
      },
      act: (bloc) => bloc.add(RemoveFromWatchlistTvSeries(testTvSeriesDetail)),
      expect: () => [
        DetailTvSeriesState.initial().copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTvSeries.execute(testTvSeriesDetail));
        verify(mockGetWatchListTvSeriesStatus.execute(testTvSeriesDetail.id));
      },
    );
  });
}
