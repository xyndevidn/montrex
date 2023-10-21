import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/domain/usecases/tv_series/get_top_rated_movies.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvSeries usecase;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    usecase = GetTopRatedTvSeries(mockTvSeriesRepository);
  });

  final tTvSeries = <TvSeries>[];

  test('should get list of tv series from repository', () async {
    // arrange
    when(mockTvSeriesRepository.getTopRatedTvSeries())
        .thenAnswer((_) async => Right(tTvSeries));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvSeries));
  });
}
