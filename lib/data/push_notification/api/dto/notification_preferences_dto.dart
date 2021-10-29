import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_group_dto.dart';

class NotificationPreferencesDTO {
  final List<NotificationPreferencesGroupDTO> groups;

  NotificationPreferencesDTO(this.groups);
}
