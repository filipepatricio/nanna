import 'package:json_annotation/json_annotation.dart';

part 'successful_response_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class SuccessfulResponseDTO {
  SuccessfulResponseDTO(this.successful);

  factory SuccessfulResponseDTO.fromJson(Map<String, dynamic> json) => _$SuccessfulResponseDTOFromJson(json);

  final bool successful;
}
