class NotificationHistory {
  final String id;
  final String message;
  final String status;
  final DateTime timestamp;
  final String? details;

  NotificationHistory({
    required this.id,
    required this.message,
    required this.status,
    required this.timestamp,
    this.details,
  });

  factory NotificationHistory.fromMap(Map<String, dynamic> map) {
    return NotificationHistory(
      id: map['id'],
      message: map['message'],
      status: map['status'],
      timestamp: map['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'status': status,
      'timestamp': timestamp,
    };
  }

  // static List<NotificationHistory> dummyNotifications = [
  //   NotificationHistory(
  //     id: 'n1',
  //     message: 'Flood warning successfully sent to 1,200 subscribers.',
  //     status: 'Delivered',
  //     timestamp: DateTime(2025, 6, 21, 16, 35, 0),
  //   ),
  //   NotificationHistory(
  //     id: 'n2',
  //     message: 'Failed to send alert to 5 subscribers due to network error.',
  //     status: 'Failed',
  //     timestamp: DateTime(2025, 6, 21, 16, 36, 15),
  //     details: '(Details: SMS gateway timeout)',
  //   ),
  //   NotificationHistory(
  //     id: 'n3',
  //     message: 'New system configuration saved by Admin Name.',
  //     status: 'Info',
  //     timestamp: DateTime(2025, 6, 20, 2, 10, 0),
  //     details: '(Threshold update)',
  //   ),
  // ];
}
