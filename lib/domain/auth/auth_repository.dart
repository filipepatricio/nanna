import 'package:better_informed_mobile/domain/auth/data/auth_result.dart';

abstract class AuthRepository {
  Future<void> requestMagicLink(String email);

  Future<AuthResult> signInWithGoogle();

  Future<AuthResult> signInWithApple();

  Future<AuthResult> signInWithLinkedin();

  Future<AuthResult> signInWithMagicLinkToken(String token);

  Stream<void> tokenExpirationStream();
}
