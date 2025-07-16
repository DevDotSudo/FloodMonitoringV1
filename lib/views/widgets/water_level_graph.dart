import 'package:flood_monitoring/constants/app_colors.dart';
import 'package:flood_monitoring/models/water_level_data.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WaterLevelGraph extends StatelessWidget {
  List<WaterLevelDataPoint> dataPoints = [];

  WaterLevelGraph({super.key, required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: LineChart(_buildChartData(dataPoints)),
    );
  }

  LineChartData _buildChartData(List<WaterLevelDataPoint> data) {
    if (data.isEmpty) {
      return LineChartData(
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [],
      );
    }

    final maxY = data.map((e) => e.level).reduce((a, b) => a > b ? a : b) * 1.2;
    final status = WaterLevelDataPoint.getWaterStatus();
    final lineColor = status == "Normal"
        ? AppColors.normalStatus
        : status == "Warning"
        ? AppColors.warningStatus
        : AppColors.criticalStatus;

    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (spots) => spots.map((spot) {
            return LineTooltipItem(
              '${data[spot.x.toInt()].time}\n',
              const TextStyle(color: Colors.white),
              children: [
                TextSpan(
                  text: '${spot.y.toStringAsFixed(1)}m',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            );
          }).toList(),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.shade200, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: _calculateBottomInterval(data.length),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= data.length) {
                return const SizedBox.shrink();
              }
              if (data.length <= 8) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    data[index].time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey,
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  data[index].time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: _calculateLeftInterval(maxY < 5 ? 5 : maxY),
            getTitlesWidget: (value, meta) {
              if (value < 0) return const SizedBox.shrink();
              return Text(
                '${value.toInt()}m',
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.shade300),
      ),
      minX: 0,
      maxX: data.length.toDouble() - 1,
      minY: 0,
      maxY: maxY < 5 ? 5 : maxY,
      lineBarsData: [
        LineChartBarData(
          spots: data
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.level))
              .toList(),
          isCurved: true,
          color: lineColor,
          barWidth: 3,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: lineColor.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  // Helper method to calculate appropriate interval for bottom titles (time)
  double _calculateBottomInterval(int dataLength) {
    // For small datasets (like your 8 data points), show all labels
    if (dataLength <= 8) return 1;
    if (dataLength <= 12) return 2;
    if (dataLength <= 24) return 3;
    return (dataLength / 6).ceil().toDouble();
  }

  // Helper method to calculate appropriate interval for left titles (meters)
  double _calculateLeftInterval(double maxY) {
    if (maxY <= 5) return 1;
    if (maxY <= 10) return 2;
    if (maxY <= 20) return 5;
    return (maxY / 5).ceil().toDouble();
  }
}