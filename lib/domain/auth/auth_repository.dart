import 'package:better_informed_mobile/domain/auth/data/auth_result.dart';
import 'package:better_informed_mobile/domain/auth/data/sign_in_credentials.dart';

abstract class AuthRepository {
  Future<void> requestMagicLink(String email);

  Future<AuthResult> signInWithDefaultProvider();

  Future<AuthResult> signInWithMagicLinkToken(String token);

  Future<AuthResult> signInWithInviteCode(SignInCredentials credentials, String code);

  Stream<void> tokenExpirationStream();
}
