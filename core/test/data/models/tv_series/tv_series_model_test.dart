import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/tv_series_model.dart';
import 'package:core/domain/entities/tv_series.dart';

void main() {
  const tTvSeriesModel = TvSeriesModel(
    backdropPath: "/8cyB9YCbV5CfOyZUUjg2e8U9s1R.jpg",
    firstAirDate: "2023-09-20",
    genreIds: [18],
    id: 235138,
    name: "Against The Light",
    popularity: 1797.668,
    posterPath: "/7LWNDuzouwBsAQ45wGxbjforxRZ.jpg",
    originCountry: ["CN"],
    originalLanguage: "zh",
    originalName: "流光之下",
    overview: "",
    voteAverage: 9,
    voteCount: 1,
  );

  final tTvSeries = TvSeries(
    backdropPath: "/8cyB9YCbV5CfOyZUUjg2e8U9s1R.jpg",
    firstAirDate: "2023-09-20",
    genreIds: const [18],
    id: 235138,
    name: "Against The Light",
    popularity: 1797.668,
    posterPath: "/7LWNDuzouwBsAQ45wGxbjforxRZ.jpg",
    originCountry: const ["CN"],
    originalLanguage: "zh",
    originalName: "流光之下",
    overview: "",
    voteAverage: 9,
    voteCount: 1,
  );

  test('should be a subclass of TV Series entity', () {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });
}
