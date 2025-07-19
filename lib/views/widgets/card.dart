import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;
  final Border? border;

  const CustomCard({
    super.key,
    required this.child,
    this.width,
    this.padding = const EdgeInsets.all(20.0),
    this.backgroundColor = Colors.white,
    this.boxShadow,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border:
            border ?? Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        boxShadow: boxShadow ?? _defaultShadow(),
      ),
      child: child,
    );
  }

  static List<BoxShadow> _defaultShadow() {
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 8,
        spreadRadius: 0,
        offset: const Offset(0, 2),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.02),
        blurRadius: 2,
        spreadRadius: 0,
        offset: const Offset(0, 1),
      ),
    ];
  }
}
