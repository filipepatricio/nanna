import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_to_action_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class CallToActionDTO {
  CallToActionDTO(
    this.preText,
    this.actionText,
  );

  factory CallToActionDTO.fromJson(Map<String, dynamic> json) => _$CallToActionDTOFromJson(json);

  final String actionText;
  final String? preText;
}
