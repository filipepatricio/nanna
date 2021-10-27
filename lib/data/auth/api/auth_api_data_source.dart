import 'package:better_informed_mobile/data/auth/api/dto/auth_token_dto.dart';
import 'package:better_informed_mobile/domain/user/data/user_meta.dart';

abstract class AuthApiDataSource {
  Future<AuthTokenDTO> signInWithProvider(String token, String provider, UserMeta? userMeta);

  Future<void> sendMagicLink(String email);
}
