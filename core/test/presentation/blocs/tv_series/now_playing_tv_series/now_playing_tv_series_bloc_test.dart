import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:core/presentation/blocs/tv_series/now_playing_tv_series/now_playing_tv_series_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import '../../../../dummy_data/tv_series/dummy_objects.dart';

import 'now_playing_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries])
void main() {
  late NowPlayingTvSeriesBloc nowPlayingTvSeriesBloc;
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;

  final tTvSeriesList = <TvSeries>[testTvSeries];

  setUp(() {
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    nowPlayingTvSeriesBloc = NowPlayingTvSeriesBloc(mockGetNowPlayingTvSeries);
  });

  group('Now Playing Tv Series Bloc --> ', () {
    test('initial state should be empty', () {
      expect(nowPlayingTvSeriesBloc.state, NowPlayingTvSeriesEmpty());
    });

    blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
      'Should emit [Loading, Empty] when get now playing tv series is empty',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => const Right([]));
        return nowPlayingTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        NowPlayingTvSeriesLoading(),
        NowPlayingTvSeriesEmpty(),
      ],
      verify: (bloc) => verify(mockGetNowPlayingTvSeries.execute()),
    );

    blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
      'Should emit [Loading, HasData] when get now playing tv series is gotten succesfully',
      build: () {
        when(mockGetNowPlayingTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));
        return nowPlayingTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        NowPlayingTvSeriesLoading(),
        NowPlayingTvSeriesHasData(tTvSeriesList),
      ],
      verify: (bloc) => verify(mockGetNowPlayingTvSeries.execute()),
    );

    blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
      'Should emit [Loading, Error] when get now playing tv series is unsuccessful',
      build: () {
        when(mockGetNowPlayingTvSeries.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return nowPlayingTvSeriesBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTvSeries()),
      expect: () => [
        NowPlayingTvSeriesLoading(),
        NowPlayingTvSeriesError('Server Failure'),
      ],
      verify: (bloc) => verify(mockGetNowPlayingTvSeries.execute()),
    );
  });
}
