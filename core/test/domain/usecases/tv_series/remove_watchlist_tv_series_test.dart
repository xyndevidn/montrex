import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:core/domain/usecases/tv_series/remove_watchlist_tv_series.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late RemoveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = RemoveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    // arrange
    when(mockTvSeriesRepository.removeWatchlistTvSeries(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockTvSeriesRepository.removeWatchlistTvSeries(testTvSeriesDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
