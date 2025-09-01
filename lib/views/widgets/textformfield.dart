import 'package:flutter/material.dart';
import 'package:flood_monitoring/constants/app_colors.dart'; // Import your AppColors

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool autovalidate;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final InputBorder? border; // This property can override all default borders
  final bool enabled;
  final String? initialValue;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.autovalidate = false,
    this.focusNode,
    this.textInputAction,
    this.style,
    this.hintStyle,
    this.fillColor,
    this.contentPadding,
    this.borderRadius = 12, // Default rounded corners
    this.border,
    this.enabled = true,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      autovalidateMode: autovalidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      focusNode: focusNode,
      textInputAction: textInputAction,
      enabled: enabled,
      style: style ?? const TextStyle(fontSize: 15, color: AppColors.textDark), // Default text color
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ?? const TextStyle(color: AppColors.textGrey), // Default hint text color
        filled: true,
        fillColor: fillColor ?? AppColors.lightGreyBackground, // Default fill color
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        // Using the custom border builders for consistency
        border: border ?? _buildDefaultBorder(),
        enabledBorder: border ?? _buildDefaultBorder(),
        focusedBorder: border ?? _buildFocusedBorder(), // No need for context here if AppColors is used
        errorBorder: _buildErrorBorder(),
        focusedErrorBorder: _buildErrorBorder(),
        disabledBorder: border ?? _buildDefaultBorder(),
      ),
    );
  }

  InputBorder _buildDefaultBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: AppColors.lightBorder, width: 1), // Using AppColors.lightBorder
    );
  }

  InputBorder _buildFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: AppColors.accentBlue, width: 1.5), // Using AppColors.accentBlue
    );
  }

  InputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5), // Using AppColors.errorRed
    );
  }
}