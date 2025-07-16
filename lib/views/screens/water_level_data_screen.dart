import 'package:flood_monitoring/constants/app_colors.dart';
import 'package:flood_monitoring/controllers/dashboard_controller.dart';
import 'package:flood_monitoring/views/widgets/card.dart';
import 'package:flood_monitoring/views/widgets/water_level_graph.dart';
import 'package:flutter/material.dart';

class WaterLevelDataScreen extends StatelessWidget {
  final _waterLevelController = DashboardController();

  WaterLevelDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detailed Water Level Data',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 600,
                  child: _waterLevelController.liveWaterLevelData.isNotEmpty
                      ? WaterLevelGraph(
                          dataPoints: _waterLevelController.liveWaterLevelData,
                        )
                      : const Center(child: Text('No data available')),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recent Readings',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                _buildDataTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: DataTable(
          border: TableBorder(
            top: BorderSide(
              width: 1,
              color: AppColors.textGrey
            ),
            left: BorderSide(
              width: 1,
              color: AppColors.textGrey
            ),
            bottom: BorderSide(
              width: 1,
              color: AppColors.textGrey
            ),
            right: BorderSide(
              width: 1,
              color: AppColors.textGrey
            ),
            verticalInside: BorderSide(
              width: 1,
              color: AppColors.textGrey
            )
          ),
          columnSpacing: 24,
          horizontalMargin: 16,
          dataRowMinHeight: 54,
          dataRowMaxHeight: 54,
          headingRowHeight: 54,
          headingRowColor: WidgetStateColor.resolveWith(
            (states) => Colors.grey.shade50,
          ),
          columns: const [
            DataColumn(
              label: Text(
                'Time',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.textGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Level (m)',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.textGrey,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.textGrey,
                ),
              ),
            ),
          ],
          rows: List<DataRow>.generate(
            5,
            (index) => DataRow(
              cells: [
                DataCell(
                  Text(
                    ['16:45', '16:15', '15:45', '15:15', '14:45'][index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                DataCell(
                  Text(
                    ['1.5', '1.6', '1.7', '1.8', '1.9'][index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.statusNormalBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Normal',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.statusNormalText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
