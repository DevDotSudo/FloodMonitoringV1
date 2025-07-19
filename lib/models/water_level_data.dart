class WaterLevelDataPoint {
  final String time;
  final double level;
  final String status;

  WaterLevelDataPoint({
    required this.time,
    required this.level,
    required this.status,
  });

  factory WaterLevelDataPoint.fromMap(Map<String, dynamic> map) {
    return WaterLevelDataPoint(
      time: map['time'] ?? '',
      level: (map['level'] ?? 0).toDouble(),
      status: map['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'level': level,
      'status': status,
    };
  }

  static double getCurrentWaterLevelFromList(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 0.0;
    final last = WaterLevelDataPoint.fromMap(data.last);
    return last.level;
  }

  static String getWaterStatusFromList(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return 'No readings.';
    final last = WaterLevelDataPoint.fromMap(data.last);
    return last.status;
  }
}
