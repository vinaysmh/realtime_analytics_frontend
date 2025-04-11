import 'package:flutter/material.dart';
import '../../models/analytics_data.dart';

class SessionDurationGauge extends StatelessWidget {
  final AnalyticsData latestData;

  const SessionDurationGauge({
    super.key,
    required this.latestData,
  });

  /// Converts decimal minutes to whole seconds
  int _toSeconds(String decimalMinutes) {
    final parsed = double.tryParse(decimalMinutes);
    return parsed != null ? (parsed * 60).round() : 0;
  }

  @override
  Widget build(BuildContext context) {
    final int seconds = _toSeconds(latestData.avgSessionDuration);
    const int maxSeconds = 600; // 10 minutes = 600 seconds
    final double progress = (seconds / maxSeconds).clamp(0.0, 1.0);
    Size size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width * 0.49,
      height: size.height * 0.4,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Avg. Session Duration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
                minHeight: 10,
              ),
              const SizedBox(height: 10),
              Text(
                "$seconds seconds",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
