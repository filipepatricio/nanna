import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';

class NotificationPreferences {
  NotificationPreferences({
    required this.groups,
  });
  final List<NotificationPreferencesGroup> groups;
}
