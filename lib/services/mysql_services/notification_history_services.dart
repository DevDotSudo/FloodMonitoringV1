import 'package:flood_monitoring/dao/mysql/notification_history_dao.dart';
import 'package:flood_monitoring/models/notification_history.dart';

class NotificationHistoryService {
  final _notificationHistoryDao = NotificationHistoryDao();

  Future<void> storeNotification(
    NotificationHistory notificationHistory,
  ) async {
    try {
      final createNotification = NotificationHistory(
        id: notificationHistory.id,
        message: notificationHistory.message,
        status: notificationHistory.status,
        timestamp: notificationHistory.timestamp,
        details: notificationHistory.details
      );
      await _notificationHistoryDao.createNotification(createNotification);
    } catch (e) {
      print('Error : $e');
    }
  }

  Future<void> dismissNotification(String id) async {
    await _notificationHistoryDao.deleteNotification(id);
  }

  Future<void> dismissAllNotification() async {
    await _notificationHistoryDao.deleteAllNotification();
  }

  Future<List<NotificationHistory>> getAllNotifications() async {
    final list = await _notificationHistoryDao.fetchAllNotifications();
    return list
        .map(
          (data) => NotificationHistory.fromMap({
            'id': data['id'] ?? '',
            'message': data['message'] ?? '',
            'status': data['status'] ?? '',
            'timestamp': DateTime.parse(
              data['timestamp'] ?? DateTime.now().toString(),
            ),
            'details': data['details'] ?? '',
          }),
        )
        .toList();
  }
}
