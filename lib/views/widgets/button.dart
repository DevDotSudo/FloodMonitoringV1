import 'package:flutter/material.dart';
import 'package:flood_monitoring/constants/app_colors.dart'; // Import your AppColors

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color textColor;
  final Color? borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final double elevation;
  final bool isOutlined;
  final TextStyle? textStyle;
  final Widget? icon;
  final MainAxisAlignment iconAlignment;
  final double gapBetweenIconAndText;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 48.0, // Default height for consistent buttons
    this.color = AppColors.primary, // Default to your primary color
    this.textColor = Colors.white, // Default to white text
    this.borderColor,
    this.borderRadius = 12.0, // Consistent rounded corners
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0), // More vertical padding
    this.elevation = 2.0, // Default subtle elevation
    this.isOutlined = false,
    this.textStyle,
    this.icon,
    this.iconAlignment = MainAxisAlignment.center,
    this.gapBetweenIconAndText = 8.0,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null || isLoading;

    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: textColor, // Text color for outlined button
            side: BorderSide(color: borderColor ?? color, width: 1.5), // Use color as default border
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
            elevation: elevation,
            minimumSize: Size(width ?? double.infinity, height!),
            textStyle: textStyle ??
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: isDisabled ? color.withOpacity(0.6) : color, // Dimmed when disabled
            foregroundColor: isDisabled ? textColor.withOpacity(0.8) : textColor, // Text dimming for disabled
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding,
            elevation: elevation,
            shadowColor: color.withOpacity(0.3), // Consistent shadow color
            minimumSize: Size(width ?? double.infinity, height!),
            textStyle: textStyle ??
                const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          );

    Widget buildContent() {
      if (isLoading) {
        return SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(textColor), // Loading indicator matches text color
          ),
        );
      }

      if (icon == null) {
        return Text(text, textAlign: TextAlign.center);
      }

      return Row(
        mainAxisSize: MainAxisSize.min, // Wrap content tightly
        mainAxisAlignment: iconAlignment,
        children: [
          icon!,
          SizedBox(width: gapBetweenIconAndText),
          Text(text),
        ],
      );
    }

    // Determine which button type to use based on `isOutlined`
    final Widget buttonWidget = isOutlined
        ? OutlinedButton(
            onPressed: isDisabled ? null : onPressed,
            style: buttonStyle,
            child: buildContent(),
          )
        : ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: buttonStyle,
            child: buildContent(),
          );

    // If a specific width is provided and not infinity, wrap in SizedBox
    // Otherwise, the button's minimumSize handles the width
    if (width != null && width != double.infinity) {
      return SizedBox(
        width: width,
        height: height,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}