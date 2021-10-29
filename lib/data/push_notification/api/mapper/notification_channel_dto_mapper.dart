import 'package:better_informed_mobile/data/bidirectional_mapper.dart';
import 'package:better_informed_mobile/data/push_notification/api/dto/notification_channel_dto.dart';
import 'package:better_informed_mobile/domain/push_notification/data/notification_channel.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationChannelDTOMapper implements BidirectionalMapper<NotificationChannelDTO, NotificationChannel> {
  @override
  NotificationChannelDTO from(NotificationChannel data) {
    return NotificationChannelDTO(
      data.id,
      data.name,
      data.emailEnabled,
      data.pushEnabled,
    );
  }

  @override
  NotificationChannel to(NotificationChannelDTO data) {
    return NotificationChannel(
      id: data.id,
      name: data.name,
      pushEnabled: data.pushEnabled,
      emailEnabled: data.emailEnabled,
    );
  }
}