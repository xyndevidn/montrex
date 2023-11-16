import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:core/presentation/blocs/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../../dummy_data/tv_series/dummy_objects.dart';

import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late PopularTvSeriesBloc popularTvSeriesBloc;
  late MockGetPopularTvSeries mockGetPopularTvSeries;

  final tTvSeriesList = <TvSeries>[testTvSeries];

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    popularTvSeriesBloc = PopularTvSeriesBloc(mockGetPopularTvSeries);
  });

  group('Popular Tv Series Bloc --> ', () {
    test('initial state should be empty', () {
      expect(popularTvSeriesBloc.state, PopularTvSeriesEmpty());
    });

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'Should emit [Loading, Empty] when get popular tv series is empty',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => const Right([]));
        return popularTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        PopularTvSeriesLoading(),
        PopularTvSeriesEmpty(),
      ],
      verify: (bloc) => verify(mockGetPopularTvSeries.execute()),
    );

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'Should emit [Loading, HasData] when get popular tv series is gotten succesfully',
      build: () {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return popularTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        PopularTvSeriesLoading(),
        PopularTvSeriesHasData(tTvSeriesList),
      ],
      verify: (bloc) => verify(mockGetPopularTvSeries.execute()),
    );

    blocTest<PopularTvSeriesBloc, PopularTvSeriesState>(
      'Should emit [Loading, Error] when get popular tv series is unsuccessful',
      build: () {
        when(mockGetPopularTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return popularTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTvSeries()),
      expect: () => [
        PopularTvSeriesLoading(),
        PopularTvSeriesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetPopularTvSeries.execute()),
    );
  });
}
