import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';

class NotificationPreferences {
  final List<NotificationPreferencesGroup> groups;

  NotificationPreferences({
    required this.groups,
  });
}
