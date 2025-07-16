import 'package:flood_monitoring/constants/app_colors.dart';
import 'package:flood_monitoring/models/notification.dart';
import 'package:flood_monitoring/views/widgets/button.dart';
import 'package:flood_monitoring/views/widgets/card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Notifications',
                  style: TextStyle(
                    fontSize: 28, // Slightly larger title
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 24), // Increased spacing
                Column(
                  children: AppNotification.dummyNotifications.map((
                    notification,
                  ) {
                    IconData icon;
                    Color iconColor;
                    Color statusBgColor;
                    Color statusTextColor;

                    switch (notification.status) {
                      case 'Delivered':
                        icon = Icons.check_circle;
                        iconColor = Colors.green.shade500;
                        statusBgColor = AppColors.statusNormalBg;
                        statusTextColor = AppColors.statusNormalText;
                        break;
                      case 'Failed':
                        icon = Icons.error; // Changed to error icon for failed
                        iconColor = Colors.red.shade500;
                        statusBgColor = AppColors.statusAlertBg;
                        statusTextColor = AppColors.statusAlertText;
                        break;
                      case 'Info':
                      default:
                        icon = Icons.info;
                        iconColor = Colors.blue.shade500;
                        statusBgColor = AppColors.statusInfoBg;
                        statusTextColor = AppColors.statusInfoText;
                        break;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16), // Increased padding
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(
                            12,
                          ), // More rounded corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.08,
                              ), // Slightly more prominent shadow
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              icon,
                              color: iconColor,
                              size: 28,
                            ), // Larger icon
                            const SizedBox(width: 16), // Increased spacing
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.message,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.w600, // Slightly bolder
                                      color: AppColors.textDark,
                                      fontSize: 17, // Slightly larger font
                                    ),
                                  ),
                                  if (notification.details != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 6.0,
                                      ), // Increased spacing
                                      child: Text(
                                        notification.details!,
                                        style: TextStyle(
                                          fontSize: 13, // Slightly larger font
                                          color: AppColors.textGrey.withOpacity(
                                            0.8,
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 8,
                                  ), // Increased spacing
                                  Wrap(
                                    // Use Wrap for better responsiveness of status/timestamp
                                    spacing: 8.0, // Horizontal spacing
                                    runSpacing: 4.0, // Vertical spacing
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      Text(
                                        'Status: ',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ), // Larger padding
                                        decoration: BoxDecoration(
                                          color: statusBgColor,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          notification.status,
                                          style: TextStyle(
                                            fontSize:
                                                13, // Slightly larger font
                                            fontWeight:
                                                FontWeight.w700, // Bolder
                                            color: statusTextColor,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '| ${DateFormat('yyyy-MM-dd HH:mm:ss').format(notification.timestamp)} PST',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: AppColors.textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.textGrey,
                              ),
                              onPressed: () {
                                // Handle dismiss notification
                              },
                              tooltip: 'Dismiss',
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32), // Increased spacing
                Center(
                  child: CustomButton(
                    // Using CustomButton
                    text: 'View All Notifications',
                    onPressed: () {
                      // Handle view all notifications
                    },
                    color: Colors.grey.shade200,
                    textColor: AppColors.textDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ), // Larger button
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
