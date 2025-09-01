import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;
  final double elevation; // Add elevation property

  const CustomCard({
    super.key,
    required this.child,
    this.width,
    this.padding = const EdgeInsets.all(20.0),
    this.backgroundColor = Colors.white,
    this.boxShadow,
    this.borderRadius,
    this.border,
    this.elevation = 4.0, // Default elevation
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: border ??
            Border.all(
                color: Colors.grey.withOpacity(0.08),
                width: 0.5),
        boxShadow: boxShadow ?? _createDynamicShadow(elevation), // Use dynamic shadow
      ),
      child: child,
    );
  }

  // A method to create a dynamic shadow based on elevation
  List<BoxShadow> _createDynamicShadow(double currentElevation) {
    // You can customize this formula based on how you want elevation to affect the shadow
    return [
      BoxShadow(
        color: Colors.black.withOpacity(currentElevation * 0.01), // More opaque with higher elevation
        blurRadius: currentElevation * 2.5, // Increase blur with elevation
        spreadRadius: 0,
        offset: Offset(0, currentElevation * 0.8), // Increase offset with elevation
      ),
    ];
  }
}