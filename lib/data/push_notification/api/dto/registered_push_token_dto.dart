import 'package:json_annotation/json_annotation.dart';

part 'registered_push_token_dto.g.dart';

@JsonSerializable()
class RegisteredPushTokenDTO {
  final String token;
  final String updatedAt;

  RegisteredPushTokenDTO(this.token, this.updatedAt);

  factory RegisteredPushTokenDTO.fromJson(Map<String, dynamic> json) => _$RegisteredPushTokenDTOFromJson(json);

  Map<String, dynamic> toJson() => _$RegisteredPushTokenDTOToJson(this);
}