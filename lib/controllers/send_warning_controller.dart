import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart'
    as http; 

class SendWarningController with ChangeNotifier {
  String _alertStatusMessage = '';
  bool _isLoading = false;

  String get alertStatusMessage => _alertStatusMessage;
  bool get isLoading => _isLoading;

  Future<void> sendWarningAlert({
    required String message,
    required bool sendOnApp,
    required bool sendSms,
  }) async {
    if (message.trim().isEmpty) {
      _alertStatusMessage = 'Please enter a message to send.';
      notifyListeners();
      return;
    }

    if (!sendOnApp && !sendSms) {
      _alertStatusMessage =
          'Please select at least one delivery method (Notify on App or Send SMS).';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _alertStatusMessage = 'Sending warning... Please wait.';
    notifyListeners();

    String deliveryMethods = '';
    if (sendOnApp) {
      deliveryMethods += 'Notify on App';
    }
    if (sendOnApp && sendSms) {
      deliveryMethods += ' and ';
    }
    if (sendSms) {
      deliveryMethods += 'Send SMS';
    }

    String prompt =
        """
      You are an emergency alert system. Based on the following message and recipient type, 
      generate a concise status update (max 100 words) for the admin dashboard. 
      Indicate if the message was successfully "sent" or if there was a "failure" and why.

      Message: "$message"
      Recipients: "All Subscribers"
      Delivery Methods: $deliveryMethods
    """;

    try {
      // This is a placeholder for your actual Gemini API call.
      // Replace with your actual API key and endpoint if needed.
      // For a real Flutter app, you'd integrate with a backend that calls Gemini,
      // or use a secure way to manage API keys if calling directly.
      const apiKey = ""; // Canvas will provide this at runtime for web demo
      final apiUrl = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
      );

      final payload = {
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': prompt},
            ],
          },
        ],
      };

      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['candidates'] != null && result['candidates'].isNotEmpty) {
          final statusText =
              result['candidates'][0]['content']['parts'][0]['text'];
          _alertStatusMessage = statusText;
        } else {
          _alertStatusMessage =
              'Failed to get status update from AI: Unexpected API response.';
        }
      } else {
        _alertStatusMessage =
            'Failed to send alert: HTTP Error ${response.statusCode}.';
      }
    } catch (e) {
      _alertStatusMessage = 'Error sending alert: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
