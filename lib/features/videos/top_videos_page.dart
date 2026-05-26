import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/history_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/filter_bar.dart';
import '../../widgets/frosted_panel.dart';

class TopVideosPage extends ConsumerWidget {
  const TopVideosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videos = ref.watch(topVideosProvider).take(50).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterBar(),
        const SizedBox(height: 18),
        FrostedPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                      child: Text('Top Videos',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w900))),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.sort_rounded),
                      tooltip: 'Ordenar'),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download_rounded),
                      tooltip: 'Exportar CSV'),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  dataRowMinHeight: 72,
                  dataRowMaxHeight: 82,
                  headingTextStyle: TextStyle(
                      color: Colors.white.withOpacity(.62),
                      fontWeight: FontWeight.w800),
                  columns: const [
                    DataColumn(label: Text('Nome')),
                    DataColumn(label: Text('Autor')),
                    DataColumn(label: Text('Tempo')),
                    /*
                    DataColumn(label: Text('Data')),
                    DataColumn(label: Text('Plataforma')),
                    */
                    DataColumn(label: Text('Plays')),
                  ],
                  rows: videos.map((video) {
                    return DataRow(cells: [
                      DataCell(Row(
                        children: [
                          _Thumb(id: video.videoId),
                          const SizedBox(width: 12),
                          SizedBox(
                              width: 320,
                              child: Text(video.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis)),
                        ],
                      )),
                      DataCell(Text(video.channel)),
                      DataCell(Text('${video.minutes} min')),
                      /* DataCell(Text(DateFormat('dd/MM/yyyy HH:mm')
                          .format(video.lastWatched.toLocal()))),
                      DataCell(Chip(
                          label: Text(video.isMusic ? 'Music' : 'YouTube'))),*/
                      DataCell(Text('${video.plays}')),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final hasId = id.isNotEmpty;
    return Container(
      width: 82,
      height: 48,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: AppTheme.panelSoft, borderRadius: BorderRadius.circular(8)),
      child: hasId
          ? Image.network('https://img.youtube.com/vi/$id/mqdefault.jpg',
              fit: BoxFit.cover)
          : const Icon(Icons.play_circle_outline_rounded),
    );
  }
}
