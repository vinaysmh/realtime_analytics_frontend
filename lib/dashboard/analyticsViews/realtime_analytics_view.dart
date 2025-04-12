import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/realtime_analytics_bloc.dart';
import '../analytics_widgets_layout.dart';
import '../indicatorWidgets/failure_widget.dart';
import '../indicatorWidgets/progress_widget.dart';

class RealtimeAnalyticsView extends StatelessWidget {
  const RealtimeAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<RealtimeAnalyticsBloc, RealtimeAnalyticsState>(
        builder: (context, ras) {
          if (ras is RealtimeAnalyticsSuccess && ras.dataList.isNotEmpty) {
            return AnalyticsWidgetsLayout(ras.dataList);
          } else if (ras is RealtimeAnalyticsFailure) {
            return FailureWidget();
          } else {
            return ProgressWidget();
          }
        },
      ),
    );
  }
}
