import 'package:flutter/material.dart';

import '../models/analytics_data.dart';
import '../utils/analytics_data_utils.dart';
import 'analyticsWidgets/active_user_card.dart';
import 'analyticsWidgets/page_view_chart.dart';
import 'analyticsWidgets/session_duration_gauge.dart';

class AnalyticsWidgetsLayout extends StatelessWidget {
  const AnalyticsWidgetsLayout(this.dataList, {super.key});
  final List<AnalyticsData> dataList;

  @override
  Widget build(BuildContext context) {
    final utils = AnalyticsDataUtils(dataList);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final gridWidgets = [
                SessionDurationGauge(sessionProgress: utils.sessionProgress, avgSessionDuration: utils.averageSessionDurationInSeconds),
                ActiveUsersCard(activeUsers: utils.activeUsers),
              ];

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: gridWidgets.map((widget) {
                  double cardWidth = constraints.maxWidth < 600 ? constraints.maxWidth : (constraints.maxWidth - 20) / 2;

                  return SizedBox(
                    width: cardWidth,
                    child: widget,
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: PageViewsChart(data: dataList),
          ),
        ],
      ),
    );
  }
}
