import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/movie/watchlist_movies/watchlist_movies_bloc.dart';
import '../../widgets/movie_card_list.dart';

class WatchlistMoviesPage extends StatefulWidget {
  const WatchlistMoviesPage({super.key});

  @override
  State<WatchlistMoviesPage> createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistMoviesBloc>().add(FetchWatchlistMovies()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMoviesBloc>().add(FetchWatchlistMovies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistMoviesBloc, WatchlistMoviesState>(
          builder: (_, state) {
            if (state is WatchlistMoviesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistMoviesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is WatchlistMoviesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.visibility_off,
                      size: 32,
                    ),
                    SizedBox(height: 2),
                    Text('Empty Watchlist'),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
