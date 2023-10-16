import 'package:montrex/data/models/tv_series_table.dart';
import 'package:montrex/domain/entities/genre.dart';
import 'package:montrex/domain/entities/season.dart';
import 'package:montrex/domain/entities/tv_series.dart';
import 'package:montrex/domain/entities/tv_series_detail.dart';

final testTvSerives = TvSeries(
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

final testTvSeriesList = [testTvSerives];

const testTvSeriesDetail = TvSeriesDetail(
  backdropPath: "/gmECX1DvFgdUPjtio2zaL8BPYPu.jpg",
  firstAirDate: "2020-10-03",
  genres: [
    Genre(id: 16, name: "Animation"),
    Genre(id: 10759, name: "Action & Adventure"),
    Genre(id: 10765, name: "Sci-Fi & Fantas"),
  ],
  id: 95479,
  lastAirDate: "2023-10-12",
  name: "Jujutsu Kaisen",
  numberOfEpisodes: 47,
  numberOfSeasons: 1,
  overview:
      "Yuji Itadori is a boy with tremendous physical strength, though he lives a completely ordinary high school life. One day, to save a classmate who has been attacked by curses, he eats the finger of Ryomen Sukuna, taking the curse into his own soul. From then on, he shares one body with Ryomen Sukuna. Guided by the most powerful of sorcerers, Satoru Gojo, Itadori is admitted to Tokyo Jujutsu High School, an organization that fights the curses... and thus begins the heroic tale of a boy who became a curse to exorcise a curse, a life from which he could never turn back.",
  posterPath: "/hFWP5HkbVEe40hrXgtCeQxoccHE.jpg",
  seasons: [
    Season(
      airDate: "2021-01-09",
      episodeCount: 4,
      id: 175591,
      name: "Specials",
      overview: "",
      posterPath: "/lUWSkuen0Vu9Xnn1r1SPcucx60e.jpg",
      seasonNumber: 0,
      voteAverage: 0,
    ),
    Season(
      airDate: "2020-10-03",
      episodeCount: 47,
      id: 135856,
      name: "Season 1",
      overview: "",
      posterPath: "/hFWP5HkbVEe40hrXgtCeQxoccHE.jpg",
      seasonNumber: 1,
      voteAverage: 8,
    )
  ],
  status: "Returning Series",
  tagline: "A boy fights... for \"the right death.\"",
  type: "Scripted",
  voteAverage: 8.565,
  voteCount: 2812,
);

const tTvSeriesDetail = TvSeriesDetail(
  backdropPath: 'backdropPath',
  firstAirDate: '2022-10-10',
  genres: [Genre(id: 1, name: 'Drama')],
  id: 1,
  lastAirDate: '2022-10-10',
  name: 'name',
  numberOfEpisodes: 12,
  numberOfSeasons: 6,
  overview: 'overview',
  posterPath: 'posterPath',
  seasons: [
    Season(
      airDate: '2022-10-10',
      episodeCount: 15,
      id: 1,
      name: 'name',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 10,
      voteAverage: 1,
    ),
  ],
  status: 'status',
  tagline: 'tagline',
  type: 'type',
  voteAverage: 8.3,
  voteCount: 1200,
);

final testWatchListTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'name': 'name',
  'posterPath': 'posterPath',
  'overview': 'overview',
};
