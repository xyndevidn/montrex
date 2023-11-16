import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_top_rated_movies.dart';
import 'package:core/presentation/blocs/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../../dummy_data/tv_series/dummy_objects.dart';

import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTvSeries])
void main() {
  late TopRatedTvSeriesBloc topRatedTvSeriesBloc;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;

  final tTvSeriesList = <TvSeries>[testTvSeries];

  setUp(() {
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    topRatedTvSeriesBloc = TopRatedTvSeriesBloc(mockGetTopRatedTvSeries);
  });

  group('Top Rated Tv Series Bloc --> ', () {
    test('initial state should be empty', () {
      expect(topRatedTvSeriesBloc.state, TopRatedTvSeriesEmpty());
    });

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'Should emit [Loading, Empty] when get top rated tv series is empty',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => const Right([]));
        return topRatedTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesEmpty(),
      ],
      verify: (bloc) => verify(mockGetTopRatedTvSeries.execute()),
    );

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'Should emit [Loading, HasData] when get top rated tv series is gotten succesfully',
      build: () {
        when(mockGetTopRatedTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return topRatedTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesHasData(tTvSeriesList),
      ],
      verify: (bloc) => verify(mockGetTopRatedTvSeries.execute()),
    );

    blocTest<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
      'Should emit [Loading, Error] when get top rated tv series is unsuccessful',
      build: () {
        when(mockGetTopRatedTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return topRatedTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvSeries()),
      expect: () => [
        TopRatedTvSeriesLoading(),
        TopRatedTvSeriesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetTopRatedTvSeries.execute()),
    );
  });
}
