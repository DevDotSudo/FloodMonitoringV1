import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationAlertService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final windowsSettings = WindowsInitializationSettings(
      appName: 'Flood Monitoring',
      appUserModelId: 'com.flood.monitoring',
      guid: '5f5f8477-4872-4bea-a123-84b4c8b52c43',
    );

    final initializationSettings = InitializationSettings(
      windows: windowsSettings,
    );

    await _plugin.initialize(initializationSettings);
  }

  Future<void> showAlert(String title, String message) async {
    const notificationDetails = NotificationDetails(
      windows: WindowsNotificationDetails(),
    );

    await _plugin.show(0, title, message, notificationDetails);
  }
}
