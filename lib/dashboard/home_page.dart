import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../logic/bloc/polled_analytics_bloc.dart';
import '../logic/bloc/realtime_analytics_bloc.dart';
import '../logic/bloc/unified_analytics_stream_bloc.dart';
import 'widgets/active_user_card.dart';
import 'widgets/page_view_chart.dart';
import 'widgets/session_duration_gauge.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    context.read<PolledAnalyticsBloc>().add(StartAnalyticsPolling());
    context.read<RealtimeAnalyticsBloc>().add(StartRealtimeAnalytics());
    context.read<UnifiedAnalyticsBloc>().add(StartUnifiedAnalytics());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Real-Time Website Analytics"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(child: BlocBuilder<UnifiedAnalyticsBloc, UnifiedAnalyticsState>(
              builder: (context, uas) {
                if (uas is UnifiedAnalyticsSuccess && uas.dataList.isNotEmpty) {
                  final latestData = uas.dataList.last;

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ActiveUsersCard(activeUsers: latestData.activeUsers),
                          SessionDurationGauge(latestData: uas.dataList.last),
                        ],
                      ),
                      const SizedBox(height: 16),
                      PageViewsChart(data: uas.dataList),
                    ],
                  );
                } else if (uas is UnifiedAnalyticsFailure) {
                  return const Center(child: Text("Failed to fetch data"));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
