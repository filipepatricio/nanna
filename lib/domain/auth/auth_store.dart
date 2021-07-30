import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';

abstract class AuthStore {
  Future<void> save(AuthToken token);

  Future<AuthToken?> read();

  Future<void> delete();
}
