import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/polled_analytics_bloc.dart';
import '../analytics_widgets_layout.dart';
import '../indicatorWidgets/failure_widget.dart';
import '../indicatorWidgets/progress_widget.dart';

class PolledAnalyticsView extends StatelessWidget {
  const PolledAnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<PolledAnalyticsBloc, PolledAnalyticsState>(
        builder: (context, pas) {
          if (pas is PolledAnalyticsSuccess && pas.dataList.isNotEmpty) {
            return AnalyticsWidgetsLayout(pas.dataList);
          } else if (pas is PolledAnalyticsFailure) {
            return FailureWidget();
          } else {
            return ProgressWidget();
          }
        },
      ),
    );
  }
}
