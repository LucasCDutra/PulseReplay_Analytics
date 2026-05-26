import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/analytics_service.dart';
import '../../shared/providers/history_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/charts.dart';
import '../../widgets/filter_bar.dart';
import '../../widgets/frosted_panel.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/upload_drop_zone.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(analyticsSnapshotProvider);
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 1200
        ? 4
        : width > 760
            ? 2
            : 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FilterBar(),
        const SizedBox(height: 18),
        const UploadDropZone(),
        const SizedBox(height: 18),
        _Hero(snapshot: snapshot),
        const SizedBox(height: 18),
        GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: width > 760 ? 1.55 : 1.75,
          children: [
            MetricCard(
                label: 'Total assistido',
                value: '${snapshot.entries.length}',
                icon: Icons.play_circle_rounded,
                color: AppTheme.violet),
            MetricCard(
                label: 'Tempo total',
                value: '${(snapshot.totalMinutes / 60).toStringAsFixed(1)}h',
                icon: Icons.timer_rounded,
                color: AppTheme.cyan),
            MetricCard(
                label: 'Músicas diferentes',
                value: '${snapshot.uniqueMusic}',
                icon: Icons.library_music_rounded,
                color: AppTheme.amber),
            MetricCard(
                label: 'Top artista',
                value: snapshot.favoriteArtist,
                icon: Icons.mic_rounded,
                color: AppTheme.pink),
            MetricCard(
                label: 'Média diária',
                value: snapshot.averageDaily.toStringAsFixed(1),
                icon: Icons.today_rounded,
                color: AppTheme.green),
            MetricCard(
                label: 'Top canal',
                value: snapshot.favoriteChannel,
                icon: Icons.smart_display_rounded,
                color: AppTheme.amber),
            MetricCard(
                label: 'Top gênero',
                value: snapshot.favoriteGenre,
                icon: Icons.graphic_eq_rounded,
                color: AppTheme.violet),
            MetricCard(
                label: 'Streak',
                value: '${snapshot.streak} dias',
                icon: Icons.local_fire_department_rounded,
                color: AppTheme.pink),
            MetricCard(
                label: 'Plataforma mais usada',
                value: snapshot.totalMusic > snapshot.totalVideos
                    ? 'Music'
                    : 'YouTube',
                icon: Icons.hub_rounded,
                color: AppTheme.cyan),
          ],
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final twoColumns = constraints.maxWidth > 980;
            return Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                SizedBox(
                    width: twoColumns
                        ? (constraints.maxWidth - 14) * .62
                        : constraints.maxWidth,
                    child: ConsumptionLineChart(points: snapshot.dailyPoints)),
                SizedBox(
                    width: twoColumns
                        ? (constraints.maxWidth - 14) * .38
                        : constraints.maxWidth,
                    child: PlatformDonutChart(
                        music: snapshot.totalMusic,
                        video: snapshot.totalVideos)),
                SizedBox(
                    width: twoColumns
                        ? (constraints.maxWidth - 14) / 2
                        : constraints.maxWidth,
                    child: GenreBarChart(items: snapshot.topGenres)),
                SizedBox(
                    width: twoColumns
                        ? (constraints.maxWidth - 14) / 2
                        : constraints.maxWidth,
                    child: HeatmapChart(buckets: snapshot.hourBuckets)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.snapshot});
  final AnalyticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return FrostedPanel(
      padding: const EdgeInsets.all(28),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _WavePainter())),
          Wrap(
            spacing: 24,
            runSpacing: 18,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 620,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Analytics de consumo para YouTube e Music',
                        style: TextStyle(
                            color: AppTheme.cyan.withOpacity(.92),
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    const Text('Seu replay, mas com cérebro de produto SaaS.',
                        style: TextStyle(
                            fontSize: 38,
                            height: 1.05,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 14),
                    Text(
                      'Importe o JSON do Google Takeout, filtre hábitos, descubra padrões e compare tendências sem perder fluidez.',
                      style: TextStyle(
                          color: Colors.white.withOpacity(.68),
                          fontSize: 16,
                          height: 1.5),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _HeroPill(label: 'Vídeos', value: '${snapshot.totalVideos}'),
                  _HeroPill(label: 'Músicas', value: '${snapshot.totalMusic}'),
                  _HeroPill(
                      label: 'Diferentes', value: '${snapshot.uniqueMusic}'),
                  _HeroPill(
                      label: 'Horas',
                      value: '${(snapshot.totalMinutes / 60).round()}'),
                ],
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 420.ms)
        .scale(begin: const Offset(.985, .985), end: const Offset(1, 1));
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.white.withOpacity(.12),
          Colors.white.withOpacity(.045)
        ]),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(.62))),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
              colors: [AppTheme.violet, AppTheme.cyan, AppTheme.pink])
          .createShader(Offset.zero & size)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path();
    for (var x = 0.0; x < size.width; x += 16) {
      final y = size.height * .66 + (x % 64 - 32).abs() * .55;
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint..color = Colors.white.withOpacity(.2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
