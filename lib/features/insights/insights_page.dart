import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/history_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/filter_bar.dart';
import '../../widgets/frosted_panel.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(analyticsSnapshotProvider).insights;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterBar(),
        const SizedBox(height: 18),
        const Text('Insights Inteligentes',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
        const SizedBox(height: 14),
        ...insights.map((insight) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: FrostedPanel(
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                        color: AppTheme.violet.withOpacity(.17),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.auto_awesome_rounded,
                        color: AppTheme.cyan),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(insight.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 6),
                        Text(insight.detail,
                            style: TextStyle(
                                color: Colors.white.withOpacity(.66))),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 84,
                    child: CircularProgressIndicator(
                        value: insight.score,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(.08)),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
