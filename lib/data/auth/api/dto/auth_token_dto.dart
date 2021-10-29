import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token_dto.g.dart';

@JsonSerializable()
class AuthTokenDTO {
  final String accessToken;
  final String refreshToken;

  AuthTokenDTO(this.accessToken, this.refreshToken);

  factory AuthTokenDTO.fromJson(Map<String, dynamic> json) => _$AuthTokenDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenDTOToJson(this);
}