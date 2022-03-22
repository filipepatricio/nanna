import 'package:better_informed_mobile/data/push_notification/api/dto/notification_channel_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_group_dto.dart';

class MockDTO {
  static final notificationPreferences = NotificationPreferencesDTO(
    [
      NotificationPreferencesGroupDTO(
        'News Updates',
        [
          NotificationChannelDTO('daily_brief', 'New Daily Brief', false, true),
          NotificationChannelDTO('new_topic', 'Incoming New Topic', true, true),
        ],
      ),
      NotificationPreferencesGroupDTO(
        'Product Updates',
        [
          NotificationChannelDTO('new_features', 'New features & improvements', false, true),
        ],
      ),
    ],
  );
}
