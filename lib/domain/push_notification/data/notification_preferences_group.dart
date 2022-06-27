import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';

class NotificationPreferencesGroup {
  NotificationPreferencesGroup({
    required this.name,
    required this.channels,
  });
  final String name;
  final List<NotificationChannel> channels;
}
