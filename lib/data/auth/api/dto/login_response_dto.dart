import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_dto.g.dart';

@JsonSerializable()
class LoginResponseDTO {
  final bool successful;
  final String? errorMessage;
  final AuthTokenDTO? tokens;
  final UserDTO account;

  LoginResponseDTO(
    this.successful,
    this.errorMessage,
    this.tokens,
    this.account,
  );

  factory LoginResponseDTO.fromJson(Map<String, dynamic> json) => _$LoginResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDTOToJson(this);
}
