import 'package:flood_monitoring/constants/app_colors.dart';
import 'package:flood_monitoring/controllers/send_warning_controller.dart';
import 'package:flood_monitoring/views/widgets/button.dart';
import 'package:flood_monitoring/views/widgets/card.dart';
import 'package:flood_monitoring/views/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendWarningAlertScreen extends StatefulWidget {
  const SendWarningAlertScreen({super.key});

  @override
  State<SendWarningAlertScreen> createState() => _SendWarningAlertScreenState();
}

class _SendWarningAlertScreenState extends State<SendWarningAlertScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _notifyOnApp = false;
  bool _sendSms = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SendWarningController>(
      builder: (context, controller, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: CustomCard(
              padding: const EdgeInsets.all(32.0),
              child: SizedBox(
                width: 700,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Send Warning Alert',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Message Content',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    CustomTextField(
                      maxLines: 8,
                      controller: _messageController,
                      hintText: 'Compose your warning message here...',
                      fillColor: AppColors.lightGreyBackground,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Character count: ${_messageController.text.length}/320 (SMS limit guidance)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Send To',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    DropdownButtonFormField<String>(
                      value: 'all-subscribers',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.lightGreyBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 12.0,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'all-subscribers',
                          child: Text(
                            'All Subscribers',
                            style: TextStyle(color: AppColors.textDark),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        // This dropdown is effectively static with one option
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text(
                              'Notify on App',
                              style: TextStyle(color: AppColors.textDark),
                            ),
                            value: _notifyOnApp,
                            onChanged: (bool? value) {
                              setState(() {
                                _notifyOnApp = value ?? false;
                              });
                            },
                            activeColor: AppColors.accentBlue,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text(
                              'Send SMS',
                              style: TextStyle(color: AppColors.textDark),
                            ),
                            value: _sendSms,
                            onChanged: (bool? value) {
                              setState(() {
                                _sendSms = value ?? false;
                              });
                            },
                            activeColor: AppColors.accentBlue,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ), // Increased spacing before button
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: controller.isLoading
                            ? 'Sending...'
                            : 'Send Warning Alert',
                        onPressed: controller.isLoading
                            ? () {}
                            : () {
                                controller.sendWarningAlert(
                                  message: _messageController.text,
                                  sendOnApp: _notifyOnApp,
                                  sendSms: _sendSms,
                                );
                              },
                        color: Colors.red.shade600,
                        textColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ), // Larger button padding
                      ),
                    ),
                    if (controller.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accentBlue,
                          ),
                        ),
                      ),
                    if (controller.alertStatusMessage.isNotEmpty &&
                        !controller.isLoading) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              controller.alertStatusMessage
                                  .toLowerCase()
                                  .contains('success')
                              ? Colors.green.shade100
                              : controller.alertStatusMessage
                                    .toLowerCase()
                                    .contains('fail')
                              ? Colors.red.shade100
                              : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          controller.alertStatusMessage,
                          style: TextStyle(
                            color:
                                controller.alertStatusMessage
                                    .toLowerCase()
                                    .contains('success')
                                ? Colors.green.shade800
                                : controller.alertStatusMessage
                                      .toLowerCase()
                                      .contains('fail')
                                ? Colors.red.shade800
                                : Colors.blue.shade800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
