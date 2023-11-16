import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:core/presentation/blocs/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../dummy_data/tv_series/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late WatchlistTvSeriesBloc watchlistTvSeriesBloc;
  late MockGetWatchlistTvSeries mockGetWatchlistTvSeries;

  setUp(() {
    mockGetWatchlistTvSeries = MockGetWatchlistTvSeries();
    watchlistTvSeriesBloc = WatchlistTvSeriesBloc(mockGetWatchlistTvSeries);
  });

  final tTvSeriesList = <TvSeries>[testWatchListTvSeries];

  group('Watchlist Tv Series Bloc --> ', () {
    test('initial state should be empty', () {
      expect(watchlistTvSeriesBloc.state, WatchlistTvSeriesEmpty());
    });

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'Should emit [Loading, Empty] when data watchlist tv series is empty',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => const Right([]));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesEmpty(),
      ],
      verify: (bloc) => verify(mockGetWatchlistTvSeries.execute()),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'Should emit [Loading, HasData] when data watchlist tv series is gotten successfully',
      build: () {
        when(mockGetWatchlistTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesHasData(tTvSeriesList),
      ],
      verify: (bloc) => verify(mockGetWatchlistTvSeries.execute()),
    );

    blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
      'Should emit [Loading, Error] when get watchlist tv series is unsuccessful',
      build: () {
        when(mockGetWatchlistTvSeries.execute()).thenAnswer(
            (_) async => const Left(DatabaseFailure('Database Failure')));
        return watchlistTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTvSeries()),
      expect: () => [
        WatchlistTvSeriesLoading(),
        WatchlistTvSeriesError('Database Failure'),
      ],
      verify: (bloc) => verify(mockGetWatchlistTvSeries.execute()),
    );
  });
}
