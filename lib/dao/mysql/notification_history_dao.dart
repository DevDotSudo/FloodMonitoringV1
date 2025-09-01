import 'package:flood_monitoring/dao/mysql_connection.dart';
import 'package:flood_monitoring/models/notification_history.dart';

class NotificationHistoryDao {
  Future<void> createNotification(
    NotificationHistory notificationHistory,
  ) async {
    final conn = await MySQLService.getConnection();
    try {
      await conn.execute(
        'INSERT INTO notification_history (id, message, status, timestamp, details) '
        'VALUES (:id, :message, :status, :timestamp, :details)',
        {
          'id': notificationHistory.id,
          'message': notificationHistory.message,
          'status': notificationHistory.status,
          'timestamp': notificationHistory.timestamp,
          'details': notificationHistory.details,
        },
      );
    } catch (e) {
      print('Error storing notification: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> deleteNotification(String id) async {
    final conn = await MySQLService.getConnection();

    try {
      await conn.execute('DELETE FROM notification_history WHERE id = :id', {
        'id': id,
      });
    } catch (e) {
      print('Error deleting notification: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> deleteAllNotification() async {
    final conn = await MySQLService.getConnection();
    try {
      await conn.execute('DELETE FROM notification_history');
    } catch (e) {
      print('Error deleting notification: $e');
    } finally {
      await conn.close();
    }
  }

  Future<List<Map<String, String?>>> fetchAllNotifications() async {
    final conn = await MySQLService.getConnection();
    try {
      final result = await conn.execute('SELECT * FROM notification_history');

      List<Map<String, String?>> notifications = result.rows.map((row) {
        return {
          'id': row.colByName('id')?.toString(),
          'message': row.colByName('message')?.toString(),
          'status': row.colByName('status')?.toString(),
          'timestamp': row.colByName('timestamp')?.toString(),
          'details': row.colByName('details')?.toString(),
        };
      }).toList();
      return notifications;
    } catch (e) {
      print('Error fetching notifications : $e');
      rethrow;
    } finally {
      await conn.close();
    }
  }
}
