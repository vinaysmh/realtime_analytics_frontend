class AnalyticsData {
  final int pageViews;
  final int activeUsers;
  final DateTime timestamp;
  final String avgSessionDuration;

  AnalyticsData({
    required this.pageViews,
    required this.timestamp,
    required this.activeUsers,
    required this.avgSessionDuration,
  });

  /// Factory method to parse only valid responses
  static AnalyticsData? tryParse(Map<String, dynamic> json) {
    // Validate keys and length
    if (json.length != 4 ||
        !json.containsKey("page_views") ||
        !json.containsKey("active_users") ||
        !json.containsKey("timestamp") ||
        !json.containsKey("avg_session_duration")) {
      return null;
    }

    try {
      return AnalyticsData(
        pageViews: json["page_views"],
        activeUsers: json["active_users"],
        timestamp: DateTime.parse(json["timestamp"]),
        avgSessionDuration: json["avg_session_duration"],
      );
    } catch (e) {
      // If any field is malformed or parsing fails
      return null;
    }
  }
}
