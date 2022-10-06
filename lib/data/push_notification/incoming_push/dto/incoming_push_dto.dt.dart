import 'package:better_informed_mobile/data/push_notification/incoming_push/dto/incoming_push_action_dto.dt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incoming_push_dto.dt.g.dart';

@JsonSerializable()
class IncomingPushDTO {
  IncomingPushDTO(this.actions, this.meta);

  factory IncomingPushDTO.fromJson(Map<String, dynamic> json) => _$IncomingPushDTOFromJson(json);

  final List<IncomingPushActionDTO> actions;
  final Map<String, dynamic> meta;

  Map<String, dynamic> toJson() => _$IncomingPushDTOToJson(this);
}
