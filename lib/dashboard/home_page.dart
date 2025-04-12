import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/polled_analytics_bloc.dart';
import '../blocs/realtime_analytics_bloc.dart';
import 'analyticsViews/polled_analytics_view.dart';
import 'analyticsViews/realtime_analytics_view.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  @override
  void initState() {
    context.read<PolledAnalyticsBloc>().add(StartAnalyticsPolling());
    context.read<RealtimeAnalyticsBloc>().add(StartRealtimeAnalytics());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text("Analytics Dashboard"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Realtime Data"),
              Tab(text: "Polled Data"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Realtime tab content
            RealtimeAnalyticsView(),
            // Polled tab content
            PolledAnalyticsView(),
          ],
        ),
      ),
    );
  }
}
