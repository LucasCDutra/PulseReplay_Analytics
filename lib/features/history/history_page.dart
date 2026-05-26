import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../shared/providers/history_provider.dart';
import '../../widgets/filter_bar.dart';
import '../../widgets/frosted_panel.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({this.grouped = false, super.key});
  final bool grouped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(filteredEntriesProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterBar(),
        const SizedBox(height: 18),
        FrostedPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(grouped ? 'Timeline' : 'History Explorer',
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w900)),
              const SizedBox(height: 16),
              SizedBox(
                height: 720,
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final showHeader = grouped &&
                        (index == 0 ||
                            DateFormat('yyyy-MM-dd').format(
                                    entries[index - 1].time.toLocal()) !=
                                DateFormat('yyyy-MM-dd')
                                    .format(entry.time.toLocal()));
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showHeader)
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 4),
                            child: Text(
                                DateFormat('EEEE, dd MMM yyyy')
                                    .format(entry.time.toLocal()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900)),
                          ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(entry.isMusic
                              ? Icons.music_note_rounded
                              : Icons.smart_display_rounded),
                          title: Text(entry.cleanTitle,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text(
                              '${entry.creator} • ${DateFormat('HH:mm').format(entry.time.toLocal())}'),
                          trailing: Chip(
                              label: Text(entry.isMusic ? 'Music' : 'YouTube')),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
