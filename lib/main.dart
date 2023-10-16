import 'package:montrex/common/constants.dart';
import 'package:montrex/common/utils.dart';
import 'package:montrex/presentation/pages/about_page.dart';
import 'package:montrex/presentation/pages/movie/search_movie_page.dart';
import 'package:montrex/presentation/pages/movie/movie_detail_page.dart';
import 'package:montrex/presentation/pages/movie/home_movie_page.dart';
import 'package:montrex/presentation/pages/movie/popular_movies_page.dart';
import 'package:montrex/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:montrex/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:montrex/presentation/pages/tv_series/home_tv_series_page.dart';
import 'package:montrex/presentation/pages/tv_series/now_playing_tv_series_page.dart';
import 'package:montrex/presentation/pages/tv_series/search_tv_series_page.dart';
import 'package:montrex/presentation/pages/tv_series/popular_tv_series_page.dart';
import 'package:montrex/presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'package:montrex/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:montrex/presentation/pages/tv_series/watchlist_tv_series_page.dart';
import 'package:montrex/presentation/provider/movie/movie_detail_notifier.dart';
import 'package:montrex/presentation/provider/movie/movie_list_notifier.dart';
import 'package:montrex/presentation/provider/movie/movie_search_notifier.dart';
import 'package:montrex/presentation/provider/movie/popular_movies_notifier.dart';
import 'package:montrex/presentation/provider/movie/top_rated_movies_notifier.dart';
import 'package:montrex/presentation/provider/movie/watchlist_movie_notifier.dart';
import 'package:montrex/presentation/provider/tv_series/now_playing_tv_series_notifier.dart';
import 'package:montrex/presentation/provider/tv_series/popular_tv_series_notifier.dart';
import 'package:montrex/presentation/provider/tv_series/top_rated_tv_series_notifier.dart';
import 'package:montrex/presentation/provider/tv_series/tv_series_detail_notifier.dart';
import 'package:montrex/presentation/provider/tv_series/tv_series_list_notifier.dart';
import 'package:montrex/presentation/provider/tv_series/tv_series_search_notifier.dart';
import 'package:montrex/presentation/provider/tv_series/watchlist_tv_series_notifier.dart';
import 'package:provider/provider.dart';
import 'package:montrex/injection.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider Movie
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<MovieSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularMoviesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistMovieNotifier>(),
        ),
        // Provider Tv Series
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesListNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesDetailNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TvSeriesSearchNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<NowPlayingTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<TopRatedTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<PopularTvSeriesNotifier>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.locator<WatchlistTvSeriesNotifier>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: const HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            // Movie
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedMoviesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const WatchlistMoviesPage());
            case SearchMoviePage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const SearchMoviePage());
            // Tv Series
            case '/home-tv':
              return MaterialPageRoute(
                  builder: (_) => const HomeTvSeriesPage());
            case NowPlayingTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const NowPlayingTvSeriesPage());
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const PopularTvSeriesPage());
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedTvSeriesPage());
            case TvSeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case SearchTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(
                  builder: (_) => const SearchTvSeriesPage());
            case WatchListTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(
                  builder: (_) => const WatchListTvSeriesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
