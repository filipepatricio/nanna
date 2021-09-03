import 'package:json_annotation/json_annotation.dart';

part 'registered_push_token_dto.g.dart';

@JsonSerializable()
class RegisteredPushTokenDTO {
  final String token;
  final String updatedAt;

  RegisteredPushTokenDTO(this.token, this.updatedAt);
}