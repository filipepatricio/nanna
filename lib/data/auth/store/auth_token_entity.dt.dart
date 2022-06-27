import 'package:json_annotation/json_annotation.dart';

part 'auth_token_entity.dt.g.dart';

@JsonSerializable()
class AuthTokenEntity {
  AuthTokenEntity({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokenEntity.fromJson(Map<String, dynamic> json) => _$AuthTokenEntityFromJson(json);
  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toJson() => _$AuthTokenEntityToJson(this);
}
