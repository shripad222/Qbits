// lib/components/notifications/notification_card.dart

import 'package:flutter/material.dart';
import 'package:smart_blood_availability/components/CustomCard.dart';
import 'notification_item.dart';

class NotificationList extends StatelessWidget {
  final List<NotificationItem> notifications;
  final void Function(NotificationItem, bool)? onAction;
  final void Function(NotificationItem)? onDismiss;

  const NotificationList({
    super.key,
    required this.notifications,
    this.onAction,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Notifications",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text("Mark all read"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return _buildNotificationCard(context, notifications[index]);
          },
        ),
      ],
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem n) {
    final colors = _getNotificationColors(n.type);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            Container(
              width: 4,
              height: 80,
              decoration: BoxDecoration(
                color: colors['main'],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors['bg'],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(colors['icon'], color: colors['main'], size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (n.priority == Priority.high)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "URGENT",
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n.time,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            if (n.type == NotificationType.request) ...[
              IconButton(
                onPressed: () => onAction?.call(n, true),
                icon: const Icon(Icons.check_circle, color: Colors.green, size: 28),
              ),
              IconButton(
                onPressed: () => onAction?.call(n, false),
                icon: const Icon(Icons.cancel, color: Colors.red, size: 28),
              ),
            ] else
              IconButton(
                onPressed: () => onDismiss?.call(n),
                icon: Icon(Icons.close, color: Colors.grey.shade400),
              ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getNotificationColors(NotificationType type) {
    switch (type) {
      case NotificationType.request:
        return {
          'main': Colors.red,
          'bg': Colors.red.shade50,
          'icon': Icons.bloodtype,
        };
      case NotificationType.reminder:
        return {
          'main': Colors.blue,
          'bg': Colors.blue.shade50,
          'icon': Icons.alarm,
        };
      case NotificationType.alert:
        return {
          'main': Colors.orange,
          'bg': Colors.orange.shade50,
          'icon': Icons.warning_amber_rounded,
        };
      case NotificationType.info:
        return {
          'main': Colors.green,
          'bg': Colors.green.shade50,
          'icon': Icons.info_outline,
        };
    }
  }
}
