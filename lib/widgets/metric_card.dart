import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';
import 'frosted_panel.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.points = const [2, 4, 3, 7, 5, 8, 9],
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final List<double> points;

  @override
  Widget build(BuildContext context) {
    return FrostedPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                    color: color.withOpacity(.18),
                    borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              Icon(Icons.trending_up_rounded,
                  color: AppTheme.green.withOpacity(.9), size: 20),
            ],
          ),
          const SizedBox(height: 18),
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(.62),
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          SizedBox(
            height: 34,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < points.length; i++)
                        FlSpot(i.toDouble(), points[i])
                    ],
                    isCurved: true,
                    color: color,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData:
                        BarAreaData(show: true, color: color.withOpacity(.12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 360.ms).slideY(begin: .05, end: 0);
  }
}
