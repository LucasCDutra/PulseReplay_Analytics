import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../shared/providers/history_provider.dart';
import '../theme/app_theme.dart';
import 'frosted_panel.dart';

class UploadDropZone extends ConsumerWidget {
  const UploadDropZone({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyControllerProvider);
    final controller = ref.read(historyControllerProvider.notifier);

    return FrostedPanel(
      padding: const EdgeInsets.all(18),
      onTap: controller.importJson,
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppTheme.cyan.withOpacity(.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.cyan.withOpacity(.32)),
            ),
            child: const Icon(Icons.cloud_upload_rounded, color: AppTheme.cyan),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Arraste seu Takeout JSON ou clique para importar',
                    style: TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text(
                  'Aceita históricos do YouTube e YouTube Music, valida automaticamente e atualiza todos os gráficos.',
                  style: TextStyle(color: Colors.white.withOpacity(.62)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          if (state.loading)
            Shimmer.fromColors(
              baseColor: Colors.white24,
              highlightColor: Colors.white70,
              child: Container(
                  width: 112,
                  height: 38,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8))),
            )
          else
            FilledButton.icon(
              onPressed: controller.importJson,
              icon: const Icon(Icons.file_open_rounded),
              label: const Text('Selecionar'),
            ),
        ],
      ),
    );
  }
}
