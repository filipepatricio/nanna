import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';

abstract class AuthRepository {
  Future<void> requestMagicLink(String email);

  Future<AuthToken> signInWithDefaultProvider();

  Future<AuthToken> signInWithMagicLinkToken(String token);

  Future<void> logout();
}
