import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_group_dto.dt.dart';

class NotificationPreferencesDTO {
  NotificationPreferencesDTO(this.groups);
  final List<NotificationPreferencesGroupDTO> groups;
}
