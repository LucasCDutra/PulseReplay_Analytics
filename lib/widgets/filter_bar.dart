import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/analytics_models.dart';
import '../shared/providers/history_provider.dart';
import 'frosted_panel.dart';

class FilterBar extends ConsumerWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyControllerProvider);
    final controller = ref.read(historyControllerProvider.notifier);

    return FrostedPanel(
      padding: const EdgeInsets.all(14),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _Menu<DatePreset>(
            icon: Icons.calendar_month_rounded,
            label: 'Período',
            values: const {
              DatePreset.today: 'Hoje',
              DatePreset.yesterday: 'Ontem',
              DatePreset.sevenDays: '7 dias',
              DatePreset.thirtyDays: '30 dias',
              DatePreset.threeMonths: '3 meses',
              DatePreset.sixMonths: '6 meses',
              DatePreset.year: '1 ano',
              DatePreset.custom: 'Tudo',
            },
            onSelected: controller.setPreset,
          ),
          _Menu<PlatformFilter>(
            icon: Icons.smart_display_rounded,
            label: switch (state.platform) {
              PlatformFilter.all => 'Ambos',
              PlatformFilter.youtube => 'YouTube',
              PlatformFilter.music => 'Music',
            },
            values: const {
              PlatformFilter.all: 'Ambos',
              PlatformFilter.youtube: 'YouTube',
              PlatformFilter.music: 'YouTube Music',
            },
            onSelected: controller.setPlatform,
          ),
          _Menu<String>(
            icon: Icons.graphic_eq_rounded,
            label: state.genre.isEmpty ? 'Gênero' : state.genre,
            values: const {
              '': 'Todos',
              'rap': 'Rap',
              'rock': 'Rock',
              'trap': 'Trap',
              'funk': 'Funk',
              'podcast': 'Podcast',
              'gameplay': 'Gameplay',
              'vlog': 'Vlog',
            },
            onSelected: controller.setGenre,
          ),
          FilledButton.icon(
            onPressed: controller.importJson,
            icon: const Icon(Icons.upload_file_rounded),
            label: const Text('Importar JSON'),
          ),
          if (state.loading)
            const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2)),
          if (state.error != null)
            Text(state.error!, style: const TextStyle(color: Colors.redAccent)),
        ],
      ),
    );
  }
}

class _Menu<T> extends StatelessWidget {
  const _Menu({
    required this.icon,
    required this.label,
    required this.values,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final Map<T, String> values;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return OutlinedButton.icon(
          onPressed: () =>
              controller.isOpen ? controller.close() : controller.open(),
          icon: Icon(icon, size: 18),
          label: Text(label),
        );
      },
      menuChildren: values.entries.map((entry) {
        return MenuItemButton(
          onPressed: () => onSelected(entry.key),
          child: Text(entry.value),
        );
      }).toList(),
    );
  }
}
