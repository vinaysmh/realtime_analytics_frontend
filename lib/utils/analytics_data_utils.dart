import '../models/analytics_data.dart';

class AnalyticsDataUtils {
  final List<AnalyticsData> data;

  AnalyticsDataUtils(this.data);

  double get averageSessionDurationInSeconds {
    if (data.isEmpty) return 0;
    final total = data.fold<double>(0, (sum, e) => sum + e.avgSessionDuration);
    return (total / data.length * 60).roundToDouble();
  }

  double get sessionProgress {
    final value = averageSessionDurationInSeconds / 600;
    return value.clamp(0.0, 1.0);
  }

  int get activeUsers => data.isNotEmpty ? data.last.activeUsers : 0;

  List<AnalyticsData> get getFiniteList {
    return data.length <= 60 ? data : data.sublist(data.length - 60);
  }
}
