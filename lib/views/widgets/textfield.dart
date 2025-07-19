import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final bool autofocus;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final double borderRadius;
  final InputBorder? border;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.autofocus = false,
    this.focusNode,
    this.textInputAction,
    this.style,
    this.hintStyle,
    this.fillColor,
    this.contentPadding,
    this.borderRadius = 12,
    this.border,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      focusNode: focusNode,
      textInputAction: textInputAction,
      enabled: enabled,
      style: style ?? const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: fillColor ?? Colors.white,
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: border ?? _buildDefaultBorder(),
        enabledBorder: border ?? _buildDefaultBorder(),
        focusedBorder: border ?? _buildFocusedBorder(context),
        disabledBorder: border ?? _buildDefaultBorder(),
      ),
    );
  }

  InputBorder _buildDefaultBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
    );
  }

  InputBorder _buildFocusedBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
    );
  }
}
