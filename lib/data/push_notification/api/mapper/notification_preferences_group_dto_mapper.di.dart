import 'package:better_informed_mobile/data/mapper.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_preferences_group_dto.dt.dart';
import 'package:better_informed_mobile/data/push_notification/api/mapper/notification_channel_dto_mapper.di.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_preferences_group.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationPreferencesGroupDTOMapper
    implements Mapper<NotificationPreferencesGroupDTO, NotificationPreferencesGroup> {
  NotificationPreferencesGroupDTOMapper(this._notificationChannelDTOMapper);

  final NotificationChannelDTOMapper _notificationChannelDTOMapper;

  @override
  NotificationPreferencesGroup call(NotificationPreferencesGroupDTO data) {
    return NotificationPreferencesGroup(
      name: data.name,
      channels: data.channels.map(_notificationChannelDTOMapper.to).toList(),
    );
  }
}
