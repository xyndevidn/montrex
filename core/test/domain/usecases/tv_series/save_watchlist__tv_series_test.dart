import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:core/domain/usecases/tv_series/save_watchlist_tv_series.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late SaveWatchlistTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = SaveWatchlistTvSeries(mockTvSeriesRepository);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(mockTvSeriesRepository.saveWatchlistTvSeries(testTvSeriesDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTvSeriesDetail);
    // assert
    verify(mockTvSeriesRepository.saveWatchlistTvSeries(testTvSeriesDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
