import 'package:core/common/styles/color.dart';
import 'package:core/common/styles/text_style.dart';
import 'package:core/common/utils.dart';
import 'package:core/common/routes.dart';
import 'package:about/about_page.dart';
import 'package:core/presentation/blocs/movie/detail_movie/detail_movie_bloc.dart';
import 'package:core/presentation/blocs/movie/now_playing_movies/now_playing_movies_bloc.dart';
import 'package:core/presentation/blocs/movie/search_movies/search_movies_bloc.dart';
import 'package:core/presentation/blocs/movie/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:core/presentation/blocs/movie/watchlist_movies/watchlist_movies_bloc.dart';
import 'package:core/presentation/blocs/tv_series/detail_tv_series/detail_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/now_playing_tv_series/now_playing_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/search_tv_series/search_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:core/presentation/blocs/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:core/presentation/pages/tv_series/watchlist_tv_series_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/presentation/blocs/movie/popular_movies/popular_movies_bloc.dart';
import 'package:core/presentation/pages/movie/search_movie_page.dart';
import 'package:core/presentation/pages/movie/movie_detail_page.dart';
import 'package:core/presentation/pages/home_page.dart';
import 'package:core/presentation/pages/movie/popular_movies_page.dart';
import 'package:core/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:core/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:core/presentation/pages/tv_series/now_playing_tv_series_page.dart';
import 'package:core/presentation/pages/tv_series/search_tv_series_page.dart';
import 'package:core/presentation/pages/tv_series/popular_tv_series_page.dart';
import 'package:core/presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'package:core/presentation/pages/tv_series/tv_series_detail_page.dart';
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
        // Bloc Movie
        BlocProvider(
          create: (_) => di.locator<NowPlayingMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchMoviesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMoviesBloc>(),
        ),
        // Bloc Tv Series
        BlocProvider(
          create: (_) => di.locator<NowPlayingTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<DetailTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvSeriesBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvSeriesBloc>(),
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
        home: const HomePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomePage());
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            // Movie
            case popularMovieRoute:
              return MaterialPageRoute(
                  builder: (_) => const PopularMoviesPage());
            case topRatedMovieRoute:
              return MaterialPageRoute(
                  builder: (_) => const TopRatedMoviesPage());
            case detailMovieRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case watchlistMovieRoute:
              return MaterialPageRoute(
                  builder: (_) => const WatchlistMoviesPage());
            case searchMovieRoute:
              return CupertinoPageRoute(
                  builder: (_) => const SearchMoviePage());
            // Tv Series
            case nowPlayingTvSeriesRoutes:
              return CupertinoPageRoute(
                  builder: (_) => const NowPlayingTvSeriesPage());
            case popularTvSeriesRoutes:
              return CupertinoPageRoute(
                  builder: (_) => const PopularTvSeriesPage());
            case topRatedTvSeriesRoutes:
              return CupertinoPageRoute(
                  builder: (_) => const TopRatedTvSeriesPage());
            case detailTvSeriesRoutes:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case searchTvSeriesRoutes:
              return CupertinoPageRoute(
                  builder: (_) => const SearchTvSeriesPage());
            case watchlistTvSeriesRoutes:
              return MaterialPageRoute(
                  builder: (_) => const WatchlistTvSeriesPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
