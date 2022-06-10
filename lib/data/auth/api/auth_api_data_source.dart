import 'package:better_informed_mobile/data/auth/api/dto/login_response_dto.dt.dart';
import 'package:better_informed_mobile/data/user/api/dto/user_meta_dto.dt.dart';

abstract class AuthApiDataSource {
  Future<LoginResponseDTO> signInWithProvider(String token, String provider, [UserMetaDTO? userMeta]);

  Future<void> sendMagicLink(String email);
}
