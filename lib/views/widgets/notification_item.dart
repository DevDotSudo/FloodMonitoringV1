import 'dart:async';

import 'package:flood_monitoring/models/notification_history.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationItem extends StatefulWidget {
  final NotificationHistory notification;
  final VoidCallback? onDismiss;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onDismiss,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  late String _relativeTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _relativeTime = _getRelativeTime();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _relativeTime = _getRelativeTime();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (statusColor, statusOpacity) = _getStatusColors();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              widget.notification.message,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _relativeTime,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (widget.notification.details != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.notification.details!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(statusOpacity),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.notification.status.toLowerCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onDismiss != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey.shade400,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: widget.onDismiss,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  (Color, double) _getStatusColors() {
    switch (widget.notification.status.toLowerCase()) {
      case 'delivered':
        return (const Color(0xFF10B981), 0.12);
      case 'failed':
        return (const Color(0xFFEF4444), 0.12);
      case 'info':
      default:
        return (const Color(0xFF3B82F6), 0.12);
    }
  }

  String _getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(widget.notification.timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, y').format(widget.notification.timestamp);
    }
  }
}