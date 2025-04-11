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
  static const int maxVisiblePoints = 30;
  bool _isBar = false;

  List<AnalyticsData> _getTrimmedData(List<AnalyticsData> fullData) {
    if (fullData.length >= maxVisiblePoints) {
      return fullData.sublist(fullData.length - maxVisiblePoints);
    }
    final paddingCount = maxVisiblePoints - fullData.length;
    final padded = List.generate(
      paddingCount,
      (_) => AnalyticsData(
        pageViews: 0,
        activeUsers: 0,
        avgSessionDuration: "0",
        timestamp: DateTime.now(),
      ),
    );
    return [...padded, ...fullData];
  }

  List<FlSpot> _generateLineSpots(List<AnalyticsData> data) {
    return data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.pageViews.toDouble())).toList();
  }

  List<BarChartGroupData> _generateBarData(List<AnalyticsData> data) {
    return data
        .asMap()
        .entries
        .map(
          (e) => BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.pageViews.toDouble(),
                color: Colors.blue,
                width: 10,
              ),
            ],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final trimmedData = _getTrimmedData(widget.data);
    final maxY = trimmedData.map((e) => e.pageViews).reduce((a, b) => a > b ? a : b).toDouble() + 10;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          value: _isBar,
          onChanged: (val) => setState(() => _isBar = val),
          title: const Text('Page Views (last 90 seconds)'),
          subtitle: Text(_isBar ? 'Switch to Line Chart' : 'Switch to Bar Chart'),
        ),
        SizedBox(
          height: size.height * 0.3,
          child: _isBar
              ? BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: maxY,
                    barGroups: _generateBarData(trimmedData),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: true),
                    gridData: FlGridData(show: true),
                  ),
                )
              : LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: maxVisiblePoints - 1,
                    minY: 0,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: _generateLineSpots(trimmedData),
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: true),
                    gridData: FlGridData(show: true),
                  ),
                ),
        ),
      ],
    );
  }
}
