import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:montrex/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  group('Testing App', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    final watchlistButton = find.byKey(const Key('watchlistButton'));
    final iconCheck = find.byIcon(Icons.check);
    final iconBack = find.byKey(const Key('iconBack'));
    final iconMenuWatchlistMovie = find.byIcon(Icons.bookmark);
    final iconMenuWatchlistTvSeries = find.byIcon(Icons.bookmark);

    testWidgets('Verify watchlist movies & tv series',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // click movie item
      final movieItem = find.byKey(const Key('movieInkWell')).first;
      await tester.tap(movieItem);
      await tester.pumpAndSettle();

      // click watchlist button
      await tester.tap(watchlistButton);
      await tester.pumpAndSettle();
      expect(iconCheck, findsOneWidget);

      // back to home page
      await tester.tap(iconBack);
      await tester.pumpAndSettle();

      // click watchlist menu in movie page
      await tester.tap(iconMenuWatchlistMovie);
      await tester.pumpAndSettle();

      // check save movie item in watchlist page
      expect(find.byType(MovieCard), findsOneWidget);

      // back to movie page
      await tester.tap(iconBack);
      await tester.pumpAndSettle();

      // click tv series menu
      final iconMenuTvSeries = find.byIcon(Icons.tv);
      await tester.tap(iconMenuTvSeries);
      await tester.pumpAndSettle();

      // click tv series item
      final tvSeriesItem = find.byKey(const Key('tvSeriesInkWell')).first;
      await tester.tap(tvSeriesItem);
      await tester.pumpAndSettle();

      // click watchlist button
      await tester.tap(watchlistButton);
      await tester.pumpAndSettle();
      expect(iconCheck, findsOneWidget);

      // back to tv series page
      await tester.tap(iconBack);
      await tester.pumpAndSettle();

      // click watchlist tv series
      await tester.tap(iconMenuWatchlistTvSeries);
      await tester.pumpAndSettle();
      expect(find.byType(TvSeriesCard), findsOneWidget);
    });
  });
}
