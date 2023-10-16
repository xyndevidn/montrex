import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:montrex/common/failure.dart';
import 'package:montrex/common/state_enum.dart';
import 'package:montrex/domain/entities/tv_series.dart';
import 'package:montrex/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:montrex/presentation/provider/tv_series/now_playing_tv_series_notifier.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';
import 'now_playing_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries])
void main() {
  late MockGetNowPlayingTvSeries mockGetNowPlayingTvSeries;
  late NowPlayingTvSeriesNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTvSeries = MockGetNowPlayingTvSeries();
    notifier = NowPlayingTvSeriesNotifier(mockGetNowPlayingTvSeries)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTvSeriesist = <TvSeries>[testTvSerives];

  test('should change movies data when data is gotten successfully', () async {
    // arrange
    when(mockGetNowPlayingTvSeries.execute())
        .thenAnswer((_) async => Right(tTvSeriesist));
    // act
    await notifier.fetchNowPlayingTvSeries();
    // assert
    expect(notifier.state, RequestState.loaded);
    expect(notifier.tvSeries, tTvSeriesist);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetNowPlayingTvSeries.execute())
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchNowPlayingTvSeries();
    // assert
    expect(notifier.state, RequestState.error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
