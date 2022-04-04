import 'package:json_annotation/json_annotation.dart';

part 'notification_channel_dto.dt.g.dart';

@JsonSerializable()
class NotificationChannelDTO {
  final String id;
  final String name;
  final bool emailEnabled;
  final bool pushEnabled;

  NotificationChannelDTO(
    this.id,
    this.name,
    this.emailEnabled,
    this.pushEnabled,
  );

  factory NotificationChannelDTO.fromJson(Map<String, dynamic> json) => _$NotificationChannelDTOFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationChannelDTOToJson(this);
}
