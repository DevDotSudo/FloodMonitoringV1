import 'package:flood_monitoring/services/warning_service/send_sms_service.dart';
import 'package:flutter/material.dart';

class SendWarningController with ChangeNotifier {
  String _alertStatusMessage = '';
  bool _isLoading = false;

  String get alertStatusMessage => _alertStatusMessage;
  bool get isLoading => _isLoading;

  final SendWarningSMS _smsService = SendWarningSMS();

  Future<void> sendWarningAlert({
    required String message,
    required String recipient,
  }) async {
    if (message.trim().isEmpty) {
      _alertStatusMessage = 'Please enter a message.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _alertStatusMessage = 'Sending SMS...';
    notifyListeners();

    try {
      await _smsService.sendSms(message, recipient);
      _alertStatusMessage = 'SMS sent successfully.';
    } catch (e) {
      _alertStatusMessage = 'Failed to send SMS: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
