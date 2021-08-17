import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dart';

abstract class AuthApiDataSource {
  Future<AuthTokenDTO> signInWithProvider(String token, String provider);

  Future<void> sendMagicLink(String email);
}
