import 'package:json_annotation/json_annotation.dart';

part 'notification_channel_dto.dt.g.dart';

@JsonSerializable()
class NotificationChannelDTO {
  NotificationChannelDTO(
    this.id,
    this.name,
    this.description,
    this.emailEnabled,
    this.pushEnabled,
  );

  factory NotificationChannelDTO.fromJson(Map<String, dynamic> json) => _$NotificationChannelDTOFromJson(json);
  final String id;
  final String name;
  final String description;
  final bool emailEnabled;
  final bool pushEnabled;

  Map<String, dynamic> toJson() => _$NotificationChannelDTOToJson(this);
}
