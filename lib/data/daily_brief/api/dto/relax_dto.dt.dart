import 'package:better_informed_mobile/data/daily_brief/api/dto/call_to_action_dto.dt.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'relax_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class RelaxDTO {
  RelaxDTO(
    this.message,
    this.icon,
    this.callToAction,
    this.headline,
  );

  factory RelaxDTO.fromJson(Map<String, dynamic> json) => _$RelaxDTOFromJson(json);

  final String? icon;
  final String headline;
  final String message;
  final CallToActionDTO? callToAction;
}
