import 'package:flutter/material.dart';

import '../../widgets/frosted_panel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FrostedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Salvar filtros favoritos'),
            subtitle: const Text(
                'Mantém suas combinações de data, plataforma e gênero prontas para reuso.'),
          ),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: const Text('Animações fluidas'),
            subtitle: const Text(
                'Ativa transições, hover scale e brilho suave nos widgets.'),
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf_rounded),
            title: const Text('Exportar PDF'),
            subtitle:
                const Text('Preparado para relatório executivo dos gráficos.'),
            trailing:
                FilledButton(onPressed: () {}, child: const Text('Exportar')),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_rounded),
            title: const Text('Exportar CSV'),
            subtitle:
                const Text('Baixe o histórico filtrado para análise externa.'),
            trailing:
                FilledButton.tonal(onPressed: () {}, child: const Text('CSV')),
          ),
        ],
      ),
    );
  }
}
