import 'package:flood_monitoring/constants/app_colors.dart';
import 'package:flood_monitoring/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onDismiss;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor, statusBgColor, statusTextColor) = _getStatusData();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  if (notification.details != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      notification.details!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey.withOpacity(0.8),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  _buildStatusRow(statusBgColor, statusTextColor),
                ],
              ),
            ),
            if (onDismiss != null)
              IconButton(
                icon: Icon(Icons.close, size: 20, color: Colors.grey.shade500),
                onPressed: onDismiss,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ),
    );
  }

  (IconData, Color, Color, Color) _getStatusData() {
    switch (notification.status) {
      case 'Delivered':
        return (
          Icons.check_circle_rounded,
          Colors.green.shade500,
          AppColors.statusNormalBg,
          AppColors.statusNormalText,
        );
      case 'Failed':
        return (
          Icons.error_outline_rounded,
          Colors.red.shade500,
          AppColors.statusAlertBg,
          AppColors.statusAlertText,
        );
      case 'Info':
      default:
        return (
          Icons.info_outline_rounded,
          Colors.blue.shade500,
          AppColors.statusInfoBg,
          AppColors.statusInfoText,
        );
    }
  }

  Widget _buildStatusRow(Color bgColor, Color textColor) {
    return Row(
      children: [
        Text(
          'Status:',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            notification.status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          DateFormat('MMM d, y · h:mm a').format(notification.timestamp),
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
