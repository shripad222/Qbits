
enum NotificationType { request, reminder, alert, info }
enum Priority { high, medium, low }

class NotificationItem {
  final NotificationType type;
  final String title;
  final String message;
  final String time;
  final Priority priority;

  NotificationItem({
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.priority,
  });
}
