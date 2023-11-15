import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:core/data/models/tv_series_model.dart';
import 'package:core/data/models/tv_series_response.dart';

import '../../../json_reader.dart';

void main() {
  const tTvSeriesModel = TvSeriesModel(
    backdropPath: "/path.jpg",
    firstAirDate: "2023-10-15",
    genreIds: [1, 2, 3],
    id: 12,
    name: "name",
    popularity: 22.1,
    posterPath: "/path.jpg",
    originCountry: ["id", "en"],
    originalLanguage: "original language",
    originalName: "original name",
    overview: "Overview",
    voteAverage: 3,
    voteCount: 3,
  );

  const tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_series/now_playing.json'));
      // act
      final result = TvSeriesResponse.fromJson(jsonMap);
      // assert
      expect(result, tTvSeriesResponseModel);
    });

    test('should return a JSON map containing proper data', () async {
      // arrange
      // act
      final result = tTvSeriesResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "results": [
          {
            "backdrop_path": "/path.jpg",
            "first_air_date": "2023-10-15",
            "genre_ids": [1, 2, 3],
            "id": 12,
            "name": "name",
            "popularity": 22.1,
            "poster_path": "/path.jpg",
            "origin_country": ["id", "en"],
            "original_language": "original language",
            "original_name": "original name",
            "overview": "Overview",
            "vote_average": 3,
            "vote_count": 3
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });
}
