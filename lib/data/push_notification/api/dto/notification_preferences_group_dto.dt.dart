import 'package:better_informed_mobile/data/push_notification/api/dto/notification_channel_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_preferences_group_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class NotificationPreferencesGroupDTO {
  NotificationPreferencesGroupDTO(this.name, this.channels);

  factory NotificationPreferencesGroupDTO.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesGroupDTOFromJson(json);
  final String name;
  final List<NotificationChannelDTO> channels;
}
