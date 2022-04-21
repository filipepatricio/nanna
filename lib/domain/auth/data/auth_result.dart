import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';

class AuthResult {
  final AuthToken authToken;
  final String method;
  final User user;

  AuthResult(this.authToken, this.method, this.user);
}
