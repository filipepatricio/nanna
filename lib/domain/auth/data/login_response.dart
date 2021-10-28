import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';

class LoginResponse {
  final AuthToken tokens;
  final User user;

  LoginResponse(this.tokens, this.user);
}
