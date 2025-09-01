import 'package:flood_monitoring/models/notification_history.dart';
import 'package:flood_monitoring/services/mysql_services/notification_history_services.dart';

class NotificationHistoryController {
  final _notificationHistoryService = NotificationHistoryService();
  List<NotificationHistory> notificationHistory = [];

  Future<List<NotificationHistory>> displayNotifications() async {
    final notifications = await _notificationHistoryService
        .getAllNotifications();
    return notificationHistory = notifications;
  }

  Future<void> createNotification(
    NotificationHistory notificationHistory,
  ) async {
    await _notificationHistoryService.storeNotification(notificationHistory);
  }

  Future<void> dismissNotification(String id) async {
    await _notificationHistoryService.dismissNotification(id);
  }

  Future<void> dismissAllNotification() async {
    await _notificationHistoryService.dismissAllNotification();
  }
}
