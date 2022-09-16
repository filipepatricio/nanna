import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_channel_dto.dt.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dt.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationChannelDTOMapper implements BidirectionalMapper<NotificationChannelDTO, NotificationChannel> {
  @override
  NotificationChannelDTO from(NotificationChannel data) {
    return NotificationChannelDTO(
      data.id,
      data.name,
      data.description,
      data.emailEnabled,
      data.pushEnabled,
    );
  }

  @override
  NotificationChannel to(NotificationChannelDTO data) {
    return NotificationChannel(
      id: data.id,
      name: data.name,
      description: data.description,
      pushEnabled: data.pushEnabled,
      emailEnabled: data.emailEnabled,
    );
  }
}
