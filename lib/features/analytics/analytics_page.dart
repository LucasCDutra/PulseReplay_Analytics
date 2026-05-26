import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/history_provider.dart';
import '../../widgets/charts.dart';
import '../../widgets/filter_bar.dart';
import '../../widgets/frosted_panel.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({this.initialTab = 0, super.key});
  final int initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(analyticsSnapshotProvider);
    return DefaultTabController(
      length: 4,
      initialIndex: initialTab,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FilterBar(),
          const SizedBox(height: 18),
          FrostedPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Analytics',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
                const SizedBox(height: 14),
                TabBar(
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Genres'),
                    Tab(text: 'Trends'),
                    Tab(text: 'Compare'),
                  ],
                ),
                SizedBox(
                  height: 760,
                  child: TabBarView(
                    children: [
                      _Grid(children: [
                        ConsumptionLineChart(points: snapshot.dailyPoints),
                        PlatformDonutChart(
                            music: snapshot.totalMusic,
                            video: snapshot.totalVideos),
                        HeatmapChart(buckets: snapshot.hourBuckets)
                      ]),
                      _Grid(children: [
                        GenreBarChart(items: snapshot.topGenres),
                        HeatmapChart(buckets: snapshot.hourBuckets)
                      ]),
                      _Grid(children: [
                        ConsumptionLineChart(points: snapshot.dailyPoints),
                        GenreBarChart(items: snapshot.topGenres)
                      ]),
                      _Compare(
                          music: snapshot.totalMusic,
                          videos: snapshot.totalVideos),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 880;
          return Wrap(
            spacing: 14,
            runSpacing: 14,
            children: children
                .map((child) => SizedBox(
                    width: wide
                        ? (constraints.maxWidth - 14) / 2
                        : constraints.maxWidth,
                    child: child))
                .toList(),
          );
        },
      ),
    );
  }
}

class _Compare extends StatelessWidget {
  const _Compare({required this.music, required this.videos});
  final int music;
  final int videos;

  @override
  Widget build(BuildContext context) {
    final total = music + videos == 0 ? 1 : music + videos;
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: FrostedPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Comparação de períodos',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            _CompareRow(
                label: 'Este mês vs mês passado',
                value: '+18%',
                trend: 'Mais consistente'),
            _CompareRow(
                label: 'Este ano vs ano passado',
                value: '+31%',
                trend: 'Alta em consumo musical'),
            _CompareRow(
                label: 'YouTube Music share',
                value: '${(music / total * 100).round()}%',
                trend: 'Preferência atual'),
            _CompareRow(
                label: 'YouTube share',
                value: '${(videos / total * 100).round()}%',
                trend: 'Vídeos e canais'),
          ],
        ),
      ),
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow(
      {required this.label, required this.value, required this.trend});
  final String label;
  final String value;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.compare_arrows_rounded),
      title: Text(label),
      subtitle: Text(trend),
      trailing: Text(value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
    );
  }
}
