import 'package:flood_monitoring/constants/app_colors.dart';
import 'package:flood_monitoring/views/widgets/button.dart';
import 'package:flood_monitoring/views/widgets/card.dart';
import 'package:flood_monitoring/views/widgets/textfield.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _systemActive = true;
  String _selectedLanguage = 'English';
  bool _emailNotifications = true;
  bool _smsNotifications = true;
  bool _pushNotifications = false;
  double _alertThreshold = 3.0;

  final TextEditingController _alertThresholdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _alertThresholdController.text = _alertThreshold.toString();
  }

  @override
  void dispose() {
    _alertThresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: CustomCard(
          padding: const EdgeInsets.all(32.0), // Increased padding
          child: SizedBox(
            width: 700, // Adjusted max width for better desktop form presentation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Settings',
                  style: TextStyle(
                    fontSize: 28, // Slightly larger title
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 32), // Increased spacing
                // General Settings
                _buildSettingsSection(
                  context,
                  title: 'General Settings',
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('System Active', style: TextStyle(color: AppColors.textDark, fontSize: 16)),
                        Switch(
                          value: _systemActive,
                          onChanged: (bool value) {
                            setState(() {
                              _systemActive = value;
                            });
                          },
                          activeColor: AppColors.accentBlue,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedLanguage,
                      decoration: InputDecoration(
                        labelText: 'Language',
                        labelStyle: const TextStyle(color: AppColors.textGrey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.lightGreyBackground,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      items: ['English', 'Spanish', 'French'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: AppColors.textDark)),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLanguage = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Notification Settings
                _buildSettingsSection(
                  context,
                  title: 'Notification Preferences',
                  children: [
                    CheckboxListTile(
                      title: const Text('Email Notifications', style: TextStyle(color: AppColors.textDark, fontSize: 16)),
                      value: _emailNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          _emailNotifications = value ?? false;
                        });
                      },
                      activeColor: AppColors.accentBlue,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: const Text('SMS Notifications', style: TextStyle(color: AppColors.textDark, fontSize: 16)),
                      value: _smsNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          _smsNotifications = value ?? false;
                        });
                      },
                      activeColor: AppColors.accentBlue,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: const Text('Desktop Push Notifications', style: TextStyle(color: AppColors.textDark, fontSize: 16)),
                      value: _pushNotifications,
                      onChanged: (bool? value) {
                        setState(() {
                          _pushNotifications = value ?? false;
                        });
                      },
                      activeColor: AppColors.accentBlue,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Flood Alert Threshold (meters)',
                      style: TextStyle(color: AppColors.textGrey, fontSize: 16.0),
                    ),
                    const SizedBox(height: 8.0),
                    CustomTextField( // Using CustomTextField
                      controller: _alertThresholdController,
                      keyboardType: TextInputType.number,
                      hintText: 'e.g., 3.0',
                      fillColor: AppColors.lightGreyBackground,
                      onChanged: (value) {
                        _alertThreshold = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Account Security
                _buildSettingsSection(
                  context,
                  title: 'Account Security',
                  children: [
                    Row(
                      children: [
                        Expanded( 
                          child: CustomButton( 
                            text: 'Change Password',
                            onPressed: () {
                              // Handle change password
                            },
                            color: Colors.grey.shade600,
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded( // Wrap CustomButton with Expanded
                          child: CustomButton( // Using CustomButton
                            text: 'Delete Account',
                            onPressed: () {
                              // Handle delete account
                            },
                            color: Colors.red.shade600,
                            textColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton( // Using CustomButton
                    text: 'Save Settings',
                    onPressed: () {
                      // Handle save settings
                    },
                    color: AppColors.accentBlue,
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14), // Larger button
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20), // Increased padding
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12), // More rounded corners
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20, // Slightly larger section title
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}