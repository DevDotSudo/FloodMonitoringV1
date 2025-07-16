class AppNotification {
  final String id;
  final String message;
  final String status;
  final DateTime timestamp;
  final String? details;

  AppNotification({
    required this.id,
    required this.message,
    required this.status,
    required this.timestamp,
    this.details,
  });

  static List<AppNotification> dummyNotifications = [
    AppNotification(
      id: 'n1',
      message: 'Flood warning successfully sent to 1,200 subscribers.',
      status: 'Delivered',
      timestamp: DateTime(2025, 6, 21, 16, 35, 0),
    ),
    AppNotification(
      id: 'n2',
      message: 'Failed to send alert to 5 subscribers due to network error.',
      status: 'Failed',
      timestamp: DateTime(2025, 6, 21, 16, 36, 15),
      details: '(Details: SMS gateway timeout)',
    ),
    AppNotification(
      id: 'n3',
      message: 'New system configuration saved by Admin Name.',
      status: 'Info',
      timestamp: DateTime(2025, 6, 20, 2, 10, 0),
      details: '(Threshold update)',
    ),
  ];
}
