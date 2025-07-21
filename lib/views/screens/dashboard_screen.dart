import 'package:flood_monitoring/constants/app_colors.dart';
import 'package:flood_monitoring/controllers/subscriber_controller.dart';
import 'package:flood_monitoring/controllers/water_level_data_controller.dart';
import 'package:flood_monitoring/models/water_level_data.dart';
import 'package:flood_monitoring/shared_pref.dart';
import 'package:flood_monitoring/views/widgets/card.dart';
import 'package:flood_monitoring/views/widgets/water_level_graph.dart';
import 'package:flutter/material.dart';
import 'package:flood_monitoring/services/alert_service/audio_alert_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final audioService = AudioPlayerService();
  final SubscriberController _subscriberController = SubscriberController();
  final WaterLevelDataController _waterLevelController =
      WaterLevelDataController();

  int? totalSubscribers;
  String? _adminName;
  bool _loadingName = true;

  @override
  void initState() {
    super.initState();
    _loadSubscribersCount();
    _loadAdminName();
  }

  Future<void> _loadSubscribersCount() async {
    int? total = await _subscriberController.countTotalSubscribers;
    setState(() {
      totalSubscribers = total;
    });
  }

  Future<void> _loadAdminName() async {
    final adminName = await SharedPref.getString('admin_name');
    if (mounted) {
      setState(() {
        _adminName = adminName;
        _loadingName = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<WaterLevelDataPoint>>(
      stream: _waterLevelController.watchWaterLevels(),
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
        final currentLevel = data.isNotEmpty ? data.last.level : 0.0;
        final status = data.isNotEmpty ? data.last.status : 'No readings.';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_loadingName)
                      const SizedBox(height: 40)
                    else
                      Text(
                        _adminName == null || _adminName!.isEmpty
                            ? 'Welcome Admin'
                            : 'Welcome, $_adminName',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                        ),
                      ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dashboard Overview',
                      style: TextStyle(fontSize: 24, color: AppColors.textDark),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = 3;
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 22,
                          childAspectRatio: crossAxisCount == 3 ? 3 : 4,
                          children: [
                            _buildMetricCard(
                              icon: Icons.group_outlined,
                              iconColor: Colors.blue.shade600,
                              bgColor: Colors.blue.shade50,
                              label: 'Total Subscribers',
                              value: totalSubscribers?.toString() ?? '0',
                            ),
                            _buildMetricCard(
                              icon: Icons.water_drop_outlined,
                              iconColor: Colors.teal.shade600,
                              bgColor: Colors.teal.shade50,
                              label: 'Current Water Level',
                              value: '${currentLevel.toStringAsFixed(2)}m',
                            ),
                            _buildMetricCard(
                              icon: Icons.warning_amber_outlined,
                              iconColor: _getStatusColor(status),
                              bgColor: _getStatusColor(status).withOpacity(0.1),
                              label: 'River Status',
                              value: status,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Water Level Monitoring',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 600,
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : data.isNotEmpty
                          ? WaterLevelGraph(dataPoints: data)
                          : const Center(child: Text('No data available')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 45),
              ),
              const SizedBox(width: 18),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status.isEmpty || status.contains('No readings.')) return Colors.blue;
    return status == "Normal"
        ? Colors.green
        : status == "Warning"
        ? Colors.orange
        : Colors.red;
  }
}
