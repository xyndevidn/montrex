import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/blocs/movie/search_movies/search_movies_bloc.dart';
import 'package:core/presentation/pages/movie/search_movie_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/movie/dummy_objects.dart';

class MockSearchMoviesBloc
    extends MockBloc<SearchMoviesEvent, SearchMoviesState>
    implements SearchMoviesBloc {}

class FakeSearchMoviesEvent extends Fake implements SearchMoviesEvent {}

class FakeSearchMoviesState extends Fake implements SearchMoviesState {}

void main() {
  late MockSearchMoviesBloc mockSearchMoviesBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchMoviesEvent());
    registerFallbackValue(FakeSearchMoviesState());
  });

  setUp(() {
    mockSearchMoviesBloc = MockSearchMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchMoviesBloc>.value(
      value: mockSearchMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('Search Movie Page --> ', () {
    testWidgets('should display when initial', (WidgetTester tester) async {
      when(() => mockSearchMoviesBloc.state).thenReturn(SearchMoviesInitial());

      final textErrorBarFinder = find.byType(Container);

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      expect(textErrorBarFinder, findsOneWidget);
    });

    testWidgets('should display center progress bar when loading',
        (WidgetTester tester) async {
      when(() => mockSearchMoviesBloc.state).thenReturn(SearchMoviesLoading());

      final progressBarFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      expect(progressBarFinder, findsOneWidget);
    });

    testWidgets('should display listView when data is loaded',
        (WidgetTester tester) async {
      when(() => mockSearchMoviesBloc.state)
          .thenReturn(SearchMoviesHasData(testMovieList));

      final formSearch = find.byType(TextField);
      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      await tester.enterText(formSearch, 'spiderman');
      await tester.pump();

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('should display text when data is empty',
        (WidgetTester tester) async {
      when(() => mockSearchMoviesBloc.state).thenReturn(SearchMoviesEmpty());

      final textErrorBarFinder = find.text('Search Not Found');

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      expect(textErrorBarFinder, findsOneWidget);
    });

    testWidgets('should display text with message when Error',
        (WidgetTester tester) async {
      when(() => mockSearchMoviesBloc.state)
          .thenReturn(const SearchMoviesError('Error message'));

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(makeTestableWidget(const SearchMoviePage()));

      expect(textFinder, findsOneWidget);
    });
  });
}
