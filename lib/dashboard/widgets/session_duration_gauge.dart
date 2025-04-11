import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/unified_analytics_stream_bloc.dart';

class SessionDurationGauge extends StatelessWidget {
  const SessionDurationGauge({super.key});

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
                      BlocBuilder<UnifiedAnalyticsBloc, UnifiedAnalyticsState>(
                        builder: (context, uas) {
                          return Text(
                            uas is UnifiedAnalyticsSuccess ? "${uas.avgSessionDuration} seconds" : "...",
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.green,
                              fontWeight: FontWeight.w900,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Chart
                SizedBox(
                  width: chartSize,
                  height: chartSize,
                  child: BlocBuilder<UnifiedAnalyticsBloc, UnifiedAnalyticsState>(
                    builder: (context, uas) {
                      double progress = uas is UnifiedAnalyticsSuccess ? uas.sessionProgress : 0.0;
                      return PieChart(
                        PieChartData(
                          startDegreeOffset: 270,
                          sectionsSpace: 0,
                          centerSpaceRadius: chartSize * 0.15,
                          sections: [
                            PieChartSectionData(
                              value: progress,
                              color: Colors.green,
                              radius: chartSize * 0.2,
                              showTitle: false,
                            ),
                            PieChartSectionData(
                              value: 1 - progress,
                              color: Colors.grey.withValues(alpha: 0.2),
                              radius: chartSize * 0.2,
                              showTitle: false,
                            ),
                          ],
                        ),
                      );
                    },
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
