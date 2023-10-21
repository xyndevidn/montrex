import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class TvSeries extends Equatable {
  TvSeries({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.popularity,
    required this.posterPath,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
  });

  TvSeries.watchlist({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  String? backdropPath;
  String? firstAirDate;
  List<int>? genreIds;
  int id;
  String name;
  double? popularity;
  String? posterPath;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalName;
  String overview;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        genreIds,
        id,
        name,
        popularity,
        posterPath,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        voteAverage,
        voteCount,
      ];
}
