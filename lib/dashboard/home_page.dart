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
    super.initState();
    context.read<PolledAnalyticsBloc>().add(StartAnalyticsPolling());
    context.read<RealtimeAnalyticsBloc>().add(StartRealtimeAnalytics());
    context.read<UnifiedAnalyticsBloc>().add(StartUnifiedAnalytics());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Real-Time Analytics Dashboard"),
      ),
      body: SafeArea(
        child: BlocBuilder<UnifiedAnalyticsBloc, UnifiedAnalyticsState>(
          builder: (context, uas) {
            if (uas is UnifiedAnalyticsSuccess && uas.dataList.isNotEmpty) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final gridWidgets = [
                          const SessionDurationGauge(),
                          const ActiveUsersCard(),
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
                      child: PageViewsChart(data: uas.dataList),
                    ),
                  ],
                ),
              );
            } else if (uas is UnifiedAnalyticsFailure) {
              return const Center(
                child: Text("Failed to fetch data\nPlease try again later"),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 80),
                    Text(
                      "Loading...\nSince the backend is deployed on a free version of render.com, it may take a while to load if the app is idle for a long time.\nJust for the first run by you, please bear until data loads",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
