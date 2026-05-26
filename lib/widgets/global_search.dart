import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/providers/history_provider.dart';

class GlobalSearch extends ConsumerStatefulWidget {
  const GlobalSearch({super.key});

  @override
  ConsumerState<GlobalSearch> createState() => _GlobalSearchState();
}

class _GlobalSearchState extends ConsumerState<GlobalSearch> {
  Timer? debounce;

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyControllerProvider);
    final suggestions = ref
        .watch(historyControllerProvider)
        .entries
        .take(80)
        .map((entry) => entry.isMusic ? entry.creator : entry.cleanTitle)
        .toSet()
        .take(8)
        .toList();

    return SearchAnchor(
      viewBackgroundColor: const Color(0xFF10121B),
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          hintText: 'Buscar músicas, vídeos, artistas, canais e gêneros',
          leading: const Icon(Icons.search_rounded),
          trailing: [
            if (state.query.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Clear',
                onPressed: () {
                  controller.clear();
                  ref.read(historyControllerProvider.notifier).setQuery('');
                },
              ),
          ],
          onChanged: (value) {
            debounce?.cancel();
            debounce = Timer(const Duration(milliseconds: 260), () {
              ref.read(historyControllerProvider.notifier).setQuery(value);
            });
          },
          onTap: controller.openView,
        );
      },
      suggestionsBuilder: (context, controller) {
        final values = [
          ...state.recentSearches,
          ...suggestions.where((item) =>
              item.toLowerCase().contains(controller.text.toLowerCase())),
          'rap',
          'rock',
          'trap',
          'funk',
          'podcast',
          'gameplay',
          'vlog',
        ].toSet().take(10);
        return values.map((value) {
          return ListTile(
            leading: const Icon(Icons.manage_search_rounded),
            title: Text(value),
            onTap: () {
              controller.closeView(value);
              ref.read(historyControllerProvider.notifier).setQuery(value);
            },
          );
        });
      },
    );
  }
}
