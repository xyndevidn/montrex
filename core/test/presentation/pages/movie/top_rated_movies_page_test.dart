import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/blocs/movie/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:core/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/movie/dummy_objects.dart';

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

class FakeTopRatedMoviesEvent extends Fake implements TopRatedMoviesEvent {}

class FakeTopRatedMoviesState extends Fake implements TopRatedMoviesState {}

void main() {
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedMoviesEvent());
    registerFallbackValue(FakeTopRatedMoviesState());
  });

  setUp(() {
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockTopRatedMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesHasData([testMovie]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(TopRatedMoviesError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
