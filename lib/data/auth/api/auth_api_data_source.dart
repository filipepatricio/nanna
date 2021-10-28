import 'package:better_informed_mobile/data/auth/api/dto/login_response_dto.dart';

abstract class AuthApiDataSource {
  Future<LoginResponseDTO> signInWithProvider(String token, String provider);

  Future<void> sendMagicLink(String email);
}
