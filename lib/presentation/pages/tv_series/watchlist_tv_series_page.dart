import 'package:flutter/material.dart';
import 'package:montrex/common/state_enum.dart';
import 'package:montrex/common/utils.dart';
import 'package:montrex/presentation/provider/tv_series/watchlist_tv_series_notifier.dart';
import 'package:montrex/presentation/widgets/tv_card_list.dart';
import 'package:provider/provider.dart';

class WatchListTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';
  const WatchListTvSeriesPage({super.key});

  @override
  State<WatchListTvSeriesPage> createState() => _WatchListTvSeriesPageState();
}

class _WatchListTvSeriesPageState extends State<WatchListTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistTvSeriesNotifier>(context, listen: false)
            .fetchWatchlistTvSeries());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistTvSeriesNotifier>(context, listen: false)
        .fetchWatchlistTvSeries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<WatchlistTvSeriesNotifier>(
          builder: (context, data, child) {
            if (data.watchlistState == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.watchlistState == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.watchlistTvSeries[index];
                  return TvSeriesCard(tvSeries);
                },
                itemCount: data.watchlistTvSeries.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
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
