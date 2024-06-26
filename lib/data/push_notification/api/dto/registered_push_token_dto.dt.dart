import 'package:json_annotation/json_annotation.dart';

part 'registered_push_token_dto.dt.g.dart';

@JsonSerializable(createToJson: false)
class RegisteredPushTokenDTO {
  RegisteredPushTokenDTO(this.token, this.updatedAt);

  factory RegisteredPushTokenDTO.fromJson(Map<String, dynamic> json) => _$RegisteredPushTokenDTOFromJson(json);
  final String token;
  final String updatedAt;
}
