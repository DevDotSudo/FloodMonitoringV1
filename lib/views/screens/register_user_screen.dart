import 'package:flood_monitoring/constants/app_colors.dart';
import 'package:flood_monitoring/controllers/subscriber_controller.dart';
import 'package:flood_monitoring/models/subscriber.dart';
import 'package:flood_monitoring/views/widgets/button.dart';
import 'package:flood_monitoring/views/widgets/card.dart';
import 'package:flood_monitoring/views/widgets/confirmation_dialog.dart';
import 'package:flood_monitoring/views/widgets/message_dialog.dart';
import 'package:flood_monitoring/views/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _subscriberController = SubscriberController();
  final _uuid = Uuid();
  bool _isLoading = false;
  String? selectedGender;
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      if (!mounted) return;
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showSuccessDialog() async {
    final result = await CustomConfirmationDialog.show(
      context: context,
      title: 'Add User',
      message: 'Do you want to add this user?',
      confirmText: 'Ok',
      cancelText: 'Cancel',
      confirmColor: Colors.red,
    );
    if (result == true) {
      _subscriberController.addSubscriber(
        Subscriber(
          id: _uuid.v4(),
          name: _fullNameController.text.trim(),
          age: _ageController.text.trim(),
          gender: selectedGender ?? 'Other',
          address: _addressController.text.trim(),
          phone: _phoneNumberController.text.trim(),
          registeredDate: DateFormat(
            'MMMM d, yyyy - h:mm a',
          ).format(DateTime.now()),
          viaSMS: 'yes',
        ),
      );

      await MessageDialog.show(
        context: context,
        title: "Registered Successfully",
        message: 'Subscriber added successfully.',
      );
      clearForm();
    }
  }

  void clearForm() {
    setState(() {
      _fullNameController.text = "";
      _ageController.text = "";
      _phoneNumberController.text = "";
      _addressController.text = "";
      selectedGender = null;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: CustomCard(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Register New User',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 4,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: AppColors.accentBlue,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFormField(
                    label: 'Full Name',
                    controller: _fullNameController,
                    hintText: 'e.g., John Doe',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Age',
                    controller: _ageController,
                    hintText: 'e.g., 30',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      final age = int.tryParse(value!);
                      if (age == null || age <= 0 || age > 75) {
                        return 'Enter valid age (1-75)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildGenderDropdown(),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Phone Number',
                    controller: _phoneNumberController,
                    hintText: 'e.g., +63 912 345 6789',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Required';
                      final phoneRegex = RegExp(
                        r'^\+?\d{1,3}[-\s]?\d{1,4}[-\s]?\d{3,4}[-\s]?\d{4}$',
                      );
                      if (!phoneRegex.hasMatch(value!) && value.length > 11 ||
                          value.length < 11) {
                        return 'Enter valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Address',
                    controller: _addressController,
                    hintText: 'e.g., Brgy. Libertad, Banate, Iloilo City',
                    maxLines: 2,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: 'Register User',
                      onPressed: _isLoading ? null : _submitForm,
                      color: AppColors.accentBlue,
                      isLoading: _isLoading,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextFormField(
          controller: controller,
          hintText: hintText,
          keyboardType: keyboardType,
          fillColor: Colors.grey.shade50,
          borderRadius: 12,
          validator: validator,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey(selectedGender),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            hintText: 'Select Gender',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
          value: selectedGender,
          items: _genderOptions.map((String gender) {
            return DropdownMenuItem<String>(value: gender, child: Text(gender));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() => selectedGender = newValue);
          },
          validator: (value) => value == null ? 'Please select a gender' : null,
        ),
      ],
    );
  }
}
