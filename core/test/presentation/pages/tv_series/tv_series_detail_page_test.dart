import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/state_enum.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/blocs/tv_series/detail_tv_series/detail_tv_series_bloc.dart';
import 'package:core/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';

class MockDetailTvSeriesBloc
    extends MockBloc<DetailTvSeriesEvent, DetailTvSeriesState>
    implements DetailTvSeriesBloc {}

class FakeDetailTvSeriesEvent extends Fake implements DetailTvSeriesEvent {}

class FakeDetailTvSeriesState extends Fake implements DetailTvSeriesState {}

void main() {
  late MockDetailTvSeriesBloc mockDetailTvSeriesBloc;

  setUpAll(() {
    registerFallbackValue(FakeDetailTvSeriesEvent());
    registerFallbackValue(FakeDetailTvSeriesState());
  });

  setUp(() {
    mockDetailTvSeriesBloc = MockDetailTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<DetailTvSeriesBloc>.value(
      value: mockDetailTvSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tId = 1;

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockDetailTvSeriesBloc.state).thenReturn(
      DetailTvSeriesState.initial().copyWith(
        tvSeriesDetailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        tvSeriesRecommendationsState: RequestState.loaded,
        tvSeriesRecommendations: <TvSeries>[],
        isAddedToWatchlist: false,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockDetailTvSeriesBloc.state).thenReturn(
      DetailTvSeriesState.initial().copyWith(
        tvSeriesDetailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        tvSeriesRecommendationsState: RequestState.loaded,
        tvSeriesRecommendations: [testTvSeries],
        isAddedToWatchlist: true,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: tId)));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Show display snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockDetailTvSeriesBloc,
      Stream.fromIterable([
        DetailTvSeriesState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        DetailTvSeriesState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist Tv Series',
        ),
      ]),
      initialState: DetailTvSeriesState.initial(),
    );

    final snackbar = find.byType(SnackBar);
    final textMessage = find.text('Added to Watchlist Tv Series');

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: tId)));

    expect(snackbar, findsNothing);
    expect(textMessage, findsNothing);

    await tester.pump();

    expect(snackbar, findsOneWidget);
    expect(textMessage, findsOneWidget);
  });

  testWidgets('Show display alert dialog when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
      mockDetailTvSeriesBloc,
      Stream.fromIterable([
        DetailTvSeriesState.initial().copyWith(
          isAddedToWatchlist: false,
        ),
        DetailTvSeriesState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed Add to Watchlist',
        ),
      ]),
      initialState: DetailTvSeriesState.initial(),
    );

    final alertDialog = find.byType(AlertDialog);
    final textMessage = find.text('Failed Add to Watchlist');

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: tId)));

    expect(alertDialog, findsNothing);
    expect(textMessage, findsNothing);

    await tester.pump();

    expect(alertDialog, findsOneWidget);
    expect(textMessage, findsOneWidget);
  });

  testWidgets(
      'Detail TvSeries page should display error text when no internet network',
      (WidgetTester tester) async {
    when(() => mockDetailTvSeriesBloc.state).thenReturn(
      DetailTvSeriesState.initial().copyWith(
        tvSeriesDetailState: RequestState.error,
        message: 'Failed to connect to the network',
      ),
    );

    final textErrorBarFinder = find.text('Failed to connect to the network');

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets(
      'Movie Recommendations should display error text when data is empty',
      (WidgetTester tester) async {
    when(() => mockDetailTvSeriesBloc.state).thenReturn(
      DetailTvSeriesState.initial().copyWith(
        tvSeriesDetailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        tvSeriesRecommendationsState: RequestState.empty,
        isAddedToWatchlist: false,
      ),
    );

    final textErrorBarFinder = find.text('No Recommendations');

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });

  testWidgets(
      'Movie Recommendations should display error text when get data is unsuccesful',
      (WidgetTester tester) async {
    when(() => mockDetailTvSeriesBloc.state).thenReturn(
      DetailTvSeriesState.initial().copyWith(
        tvSeriesDetailState: RequestState.loaded,
        tvSeriesDetail: testTvSeriesDetail,
        tvSeriesRecommendationsState: RequestState.error,
        message: 'Error',
        isAddedToWatchlist: false,
      ),
    );

    final textErrorBarFinder = find.text('Error');

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });
}
