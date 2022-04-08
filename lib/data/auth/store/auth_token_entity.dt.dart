import 'package:json_annotation/json_annotation.dart';

part 'auth_token_entity.dt.g.dart';

@JsonSerializable()
class AuthTokenEntity {
  final String accessToken;
  final String refreshToken;

  AuthTokenEntity({
    required this.accessToken,
    required this.refreshToken,
  });

  Map<String, dynamic> toJson() => _$AuthTokenEntityToJson(this);

  factory AuthTokenEntity.fromJson(Map<String, dynamic> json) => _$AuthTokenEntityFromJson(json);
}
