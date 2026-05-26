import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/history_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/filter_bar.dart';
import '../../widgets/frosted_panel.dart';

class TopArtistsPage extends ConsumerWidget {
  const TopArtistsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artists = ref.watch(analyticsSnapshotProvider).topArtists;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterBar(),
        const SizedBox(height: 18),
        const Text('Top Artists',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 1180
                ? 3
                : constraints.maxWidth > 720
                    ? 2
                    : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: artists.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 2.15),
              itemBuilder: (context, index) {
                final artist = artists[index];
                return FrostedPanel(
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [
                            AppTheme.violet.withOpacity(.9),
                            AppTheme.cyan.withOpacity(.8)
                          ]),
                        ),
                        child: Text('#${index + 1}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w900)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(artist.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 6),
                            Text(
                                '${artist.count} plays • ${artist.minutes} min',
                                style: TextStyle(
                                    color: Colors.white.withOpacity(.62))),
                            const SizedBox(height: 10),
                            LinearProgressIndicator(
                                value:
                                    artist.growth.clamp(0, 60).toDouble() / 60,
                                minHeight: 6),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                          '${artist.growth >= 0 ? '+' : ''}${artist.growth.toStringAsFixed(0)}%',
                          style: const TextStyle(
                              color: AppTheme.green,
                              fontWeight: FontWeight.w900)),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
