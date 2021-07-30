import 'package:better_informed_mobile/domain/auth/data/sign_in_provider.dart';

abstract class AuthRepository {
  Future<void> requestMagicLink(String email);

  Future<void> signInWithProvider(String token, SignInProvider provider);

  Future<void> logout();
}
