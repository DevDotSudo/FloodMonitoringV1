import 'package:flood_monitoring/constants/app_colors.dart';
import 'package:flood_monitoring/controllers/dashboard_controller.dart';
import 'package:flood_monitoring/controllers/subscriber_controller.dart';
import 'package:flood_monitoring/models/water_level_data.dart';
import 'package:flood_monitoring/shared_pref.dart';
import 'package:flood_monitoring/views/widgets/card.dart';
import 'package:flood_monitoring/views/widgets/water_level_graph.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SubscriberController _subscriberController = SubscriberController();
  final DashboardController _dashboardController = DashboardController();
  
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
    int? total;
    total = await _subscriberController.countTotalSubscribers;
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
    Provider.of<SubscriberController>(context, listen: false).startListenerAfterBuild();
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
                          value: totalSubscribers.toString().isEmpty
                              ? '0'
                              : totalSubscribers.toString(),
                        ),
                        _buildMetricCard(
                          icon: Icons.water_drop_outlined,
                          iconColor: Colors.teal.shade600,
                          bgColor: Colors.teal.shade50,
                          label: 'Current Water Level',
                          value:
                              '${_dashboardController.currentWaterLevel.toString()}m',
                        ),
                        _buildMetricCard(
                          icon: Icons.warning_amber_outlined,
                          iconColor: _getStatusColor(
                            WaterLevelDataPoint.getWaterStatus(),
                          ),
                          bgColor: _getStatusColor(
                            WaterLevelDataPoint.getWaterStatus(),
                          ).withOpacity(0.1),
                          label: 'River Status',
                          value: _dashboardController.riverStatus,
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
                  child: _dashboardController.liveWaterLevelData.isNotEmpty
                      ? WaterLevelGraph(
                          dataPoints: _dashboardController.liveWaterLevelData,
                        )
                      : const Center(child: Text('No data available')),
                ),
              ],
            ),
          ),
        ],
      ),
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
                  fontSize: 18,
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
    final status = _dashboardController.riverStatus;
    if (status.isEmpty || status.contains('No readings.')) return Colors.blue;
    return status == "Normal"
        ? Colors.green
        : status == "Warning"
        ? Colors.orange
        : Colors.red;
  }
}
