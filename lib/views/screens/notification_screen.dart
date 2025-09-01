import 'package:flood_monitoring/constants/app_colors.dart';
import 'package:flood_monitoring/controllers/notification_history_controller.dart';
import 'package:flood_monitoring/models/notification_history.dart';
import 'package:flood_monitoring/views/widgets/card.dart';
import 'package:flood_monitoring/views/widgets/notification_item.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationScreen> {
  final _notificationHistoryController = NotificationHistoryController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    await _notificationHistoryController.displayNotifications();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<NotificationHistory> notifications =
        _notificationHistoryController.notificationHistory;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Notifications',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 20),

                // ✅ Loading state
                if (_isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        color: AppColors.accentBlue,
                      ),
                    ),
                  )
                // ✅ Empty state
                else if (notifications.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: const [
                          Icon(Icons.notifications_off_outlined,
                              size: 50, color: AppColors.textGrey),
                          SizedBox(height: 10),
                          Text(
                            'No notifications yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                // ✅ Use NotificationItem widget
                else
                  ListView.builder(
                    itemCount: notifications.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return NotificationItem(
                        notification: notification,
                        onDismiss: () async {
                          await _notificationHistoryController
                              .dismissNotification(notification.id);
                          await _loadNotifications();
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
