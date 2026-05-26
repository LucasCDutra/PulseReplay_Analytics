import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/analytics_models.dart';
import '../theme/app_theme.dart';
import 'frosted_panel.dart';

class ConsumptionLineChart extends StatelessWidget {
  const ConsumptionLineChart({required this.points, super.key});
  final List<DailyPoint> points;

  @override
  Widget build(BuildContext context) {
    final safePoints = points.isEmpty
        ? [DailyPoint(DateTime.now(), 1)]
        : points.take(40).toList();
    return FrostedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ChartTitle(
              title: 'Consumo por período', icon: Icons.show_chart_rounded),
          const SizedBox(height: 18),
          SizedBox(
            height: 270,
            child: LineChart(
              LineChartData(
                minY: 0,
                gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                        color: Colors.white.withOpacity(.07), strokeWidth: 1)),
                titlesData: const FlTitlesData(
                    leftTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false))),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < safePoints.length; i++)
                        FlSpot(i.toDouble(), safePoints[i].count.toDouble())
                    ],
                    isCurved: true,
                    color: AppTheme.cyan,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                        show: true, color: AppTheme.cyan.withOpacity(.12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenreBarChart extends StatelessWidget {
  const GenreBarChart({required this.items, super.key});
  final List<RankedItem> items;

  @override
  Widget build(BuildContext context) {
    final data = items.take(7).toList();
    final maxValue =
        data.isEmpty ? 1 : data.map((e) => e.count).reduce(max).toDouble();
    return FrostedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ChartTitle(
              title: 'Top gêneros', icon: Icons.bar_chart_rounded),
          const SizedBox(height: 18),
          ...data.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  SizedBox(
                      width: 86,
                      child: Text(item.name, overflow: TextOverflow.ellipsis)),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: item.count / maxValue,
                        minHeight: 10,
                        backgroundColor: Colors.white.withOpacity(.07),
                        valueColor:
                            const AlwaysStoppedAnimation(AppTheme.violet),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${item.count}'),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class PlatformDonutChart extends StatelessWidget {
  const PlatformDonutChart(
      {required this.music, required this.video, super.key});
  final int music;
  final int video;

  @override
  Widget build(BuildContext context) {
    return FrostedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ChartTitle(
              title: 'YouTube vs Music', icon: Icons.donut_large_rounded),
          const SizedBox(height: 18),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 58,
                sectionsSpace: 3,
                sections: [
                  PieChartSectionData(
                      value: video.toDouble(),
                      title: 'YT',
                      color: AppTheme.pink,
                      radius: 42),
                  PieChartSectionData(
                      value: music.toDouble(),
                      title: 'Music',
                      color: AppTheme.cyan,
                      radius: 42),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeatmapChart extends StatelessWidget {
  const HeatmapChart({required this.buckets, super.key});
  final List<int> buckets;

  @override
  Widget build(BuildContext context) {
    final maxValue =
        buckets.isEmpty ? 1 : buckets.reduce(max).clamp(1, 999999).toInt();
    return FrostedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ChartTitle(
              title: 'Horários mais ativos', icon: Icons.grid_on_rounded),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 24,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.55),
            itemBuilder: (context, index) {
              final value = buckets.length > index ? buckets[index] : 0;
              return Tooltip(
                message: '$index:00 - $value plays',
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppTheme.violet
                        .withOpacity(.08 + (.52 * value / maxValue)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(.06)),
                  ),
                  child: Text('${index}h',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChartTitle extends StatelessWidget {
  const _ChartTitle({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.cyan, size: 20),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      ],
    );
  }
}
