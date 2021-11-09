import 'package:better_informed_mobile/data/push_notification/api/dto/notification_channel_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_preferences_group_dto.g.dart';

@JsonSerializable()
class NotificationPreferencesGroupDTO {
  final String name;
  final List<NotificationChannelDTO> channels;

  NotificationPreferencesGroupDTO(this.name, this.channels);

  factory NotificationPreferencesGroupDTO.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesGroupDTOFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPreferencesGroupDTOToJson(this);
}
