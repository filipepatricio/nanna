import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';

class AuthResult {
  final AuthToken authToken;
  final String method;
  final int userId;

  AuthResult(this.authToken, this.method, this.userId);
}
