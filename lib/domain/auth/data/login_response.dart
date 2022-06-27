import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';

class LoginResponse {
  LoginResponse(this.tokens, this.user);
  final AuthToken tokens;
  final User user;
}
