import 'package:flutter/material.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/domain/entities/tv_series.dart';
import 'package:core/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:core/presentation/provider/tv_series/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([TvSeriesDetailNotifier])
void main() {
  late MockTvSeriesDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTvSeriesDetailNotifier();
  });

  Widget makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<TvSeriesDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlistTvSeries).thenReturn(false);

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlistTvSeries).thenReturn(true);

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlistTvSeries).thenReturn(false);
    when(mockNotifier.watchlistMessage)
        .thenReturn('Added to Watchlist Tv Series');

    final watchlistButton = find.byType(ElevatedButton);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist Tv Series'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    when(mockNotifier.tvSeriesState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvSeries).thenReturn(testTvSeriesDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvSeriesRecommendations).thenReturn(<TvSeries>[]);
    when(mockNotifier.isAddedToWatchlistTvSeries).thenReturn(false);
    when(mockNotifier.watchlistMessage).thenReturn('Failed');

    final watchlistButton = find.byType(ElevatedButton);

    await tester
        .pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
