import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';

class AuthResult {
  AuthResult(this.authToken, this.method, this.userUuid);
  final AuthToken authToken;
  final String method;
  final String userUuid;
}
