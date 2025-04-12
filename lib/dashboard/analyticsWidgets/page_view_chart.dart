import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/analytics_data.dart';

class PageViewsChart extends StatefulWidget {
  final List<AnalyticsData> data;

  const PageViewsChart({super.key, required this.data});

  @override
  State<PageViewsChart> createState() => _PageViewsChartState();
}

class _PageViewsChartState extends State<PageViewsChart> {
  List<AnalyticsData> _getTrimmedData(List<AnalyticsData> fullData, int visibleCount) {
    List<AnalyticsData> trimmed;

    if (fullData.length >= visibleCount) {
      trimmed = fullData.sublist(fullData.length - visibleCount);
    } else {
      trimmed = [...fullData];
    }

    final paddingCount = visibleCount - trimmed.length;
    final padded = List.generate(
      paddingCount,
      (_) => AnalyticsData(
        pageViews: 0,
        activeUsers: 0,
        avgSessionDuration: 0,
        timestamp: DateTime.now(),
      ),
    );

    return [...padded, ...trimmed]; // Guaranteed to be length == visibleCount
  }

  List<BarChartGroupData> _generateBarData(List<AnalyticsData> data) {
    return data.asMap().entries.map((e) {
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: e.value.pageViews.toDouble(),
            color: Colors.green,
            width: 10,
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const double barWidth = 10.0;
            const double barSpacing = 4.0;
            const int maxVisiblePoints = 30;

            final availableWidth = constraints.maxWidth;
            final double totalBarUnitWidth = (barWidth + barSpacing) * 3;
            final int barCount = (availableWidth / totalBarUnitWidth).floor().clamp(5, maxVisiblePoints); // clamp for min 5 bars

            final visibleData = _getTrimmedData(widget.data, barCount);
            final maxY = visibleData.isNotEmpty ? visibleData.map((e) => e.pageViews).reduce((a, b) => a > b ? a : b).toDouble() + 10 : 10.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Page Views (Last $barCount Records)",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: BarChart(
                    BarChartData(
                        minY: 0,
                        maxY: maxY,
                        barGroups: _generateBarData(visibleData),
                        titlesData: FlTitlesData(
                          show: true,
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: true),
                        gridData: FlGridData(show: true)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
