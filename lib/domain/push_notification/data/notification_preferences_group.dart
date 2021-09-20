import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dart';

class NotificationPreferencesGroup {
  final String name;
  final List<NotificationChannel> channels;

  NotificationPreferencesGroup({
    required this.name,
    required this.channels,
  });
}
