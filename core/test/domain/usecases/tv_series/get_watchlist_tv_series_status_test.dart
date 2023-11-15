import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:core/domain/usecases/tv_series/get_watchlist_tv_series_status.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchListTvSeriesStatus usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetWatchListTvSeriesStatus(mockTvSeriesRepository);
  });

  test('should get watchlist tv series status from repository', () async {
    // arrange
    when(mockTvSeriesRepository.isAddedToWatchlistTvSeries(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
