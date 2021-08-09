import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:better_informed_mobile/domain/auth/data/sign_in_provider.dart';

abstract class AuthRepository {
  Future<void> requestMagicLink(String email);

  Future<AuthToken> signInWithDefaultProvider();

  Future<void> logout();
}
