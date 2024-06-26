import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_dto.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_preferences_group_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationPreferencesDTOMapper implements Mapper<NotificationPreferencesDTO, NotificationPreferences> {
  NotificationPreferencesDTOMapper(this._notificationPreferencesGroupDTOMapper);
  final NotificationPreferencesGroupDTOMapper _notificationPreferencesGroupDTOMapper;

  @override
  NotificationPreferences call(NotificationPreferencesDTO data) {
    return NotificationPreferences(
      groups: data.groups.map<NotificationPreferencesGroup>(_notificationPreferencesGroupDTOMapper).toList(),
    );
  }
}
