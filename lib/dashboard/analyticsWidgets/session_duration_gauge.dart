import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SessionDurationGauge extends StatelessWidget {
  const SessionDurationGauge({
    super.key,
    required this.sessionProgress,
    required this.avgSessionDuration,
  });
  final double sessionProgress;
  final double avgSessionDuration;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double chartSize = constraints.maxWidth * 0.4;
        double fontSize = constraints.maxWidth < 300 ? 24 : 32;

        return Card(
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              runSpacing: 16,
              spacing: 16,
              children: [
                // Text group
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Avg. Session Duration',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "$avgSessionDuration seconds",
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.green,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                // Chart
                SizedBox(
                  width: chartSize,
                  height: chartSize,
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: 270,
                      sectionsSpace: 0,
                      centerSpaceRadius: chartSize * 0.15,
                      sections: [
                        PieChartSectionData(
                          value: sessionProgress,
                          color: Colors.green,
                          radius: chartSize * 0.2,
                          showTitle: false,
                        ),
                        PieChartSectionData(
                          value: 1 - sessionProgress,
                          color: Colors.grey.withValues(alpha: 0.2),
                          radius: chartSize * 0.2,
                          showTitle: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
