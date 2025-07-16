import 'package:flood_monitoring/models/water_level_data.dart';
import 'package:flutter/material.dart';

class DashboardController with ChangeNotifier {
  final int _totalSubscribers = 1234;
  final double _currentWaterLevel = WaterLevelDataPoint.getCurrentWaterLevel();
  final String _riverStatus = WaterLevelDataPoint.getWaterStatus();
  final List<WaterLevelDataPoint> _liveWaterLevelData =
      WaterLevelDataPoint.dummyHourlyData;
  String get riverStatus => _riverStatus;
  int get totalSubscribers => _totalSubscribers;
  double get currentWaterLevel => _currentWaterLevel;
  List<WaterLevelDataPoint> get liveWaterLevelData => _liveWaterLevelData;

  void fetchDashboardData() {
    // Simulate data fetching
    // _totalSubscribers = ...;
    // _currentWaterLevel = ...;
    // _liveWaterLevelData = ...;
    notifyListeners();
  }
}
