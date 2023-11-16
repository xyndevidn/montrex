import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/styles/text_style.dart';
import '../../blocs/movie/search_movies/search_movies_bloc.dart';
import '../../widgets/movie_card_list.dart';

class SearchMoviePage extends StatelessWidget {
  const SearchMoviePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Search Movies'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (query) {
                  context.read<SearchMoviesBloc>().add(OnQueryChanged(query));
                },
                decoration: const InputDecoration(
                  hintText: 'Search title',
                  contentPadding: EdgeInsets.all(14),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                textInputAction: TextInputAction.search,
              ),
              const SizedBox(height: 16),
              Text(
                'Search Result',
                style: kHeading6,
              ),
              BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
                builder: (_, state) {
                  if (state is SearchMoviesLoading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is SearchMoviesHasData) {
                    final result = state.result;
                    return Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (_, index) {
                          final movie = result[index];
                          return MovieCard(movie);
                        },
                        itemCount: result.length,
                      ),
                    );
                  } else if (state is SearchMoviesEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 48),
                            const SizedBox(height: 2),
                            Text('Search Not Found', style: kSubtitle),
                          ],
                        ),
                      ),
                    );
                  } else if (state is SearchMoviesError) {
                    return Expanded(
                      child: Center(
                        key: const Key('error_message'),
                        child: Text(state.message),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
