import 'package:better_informed_mobile/domain/auth/data/auth_token.dart';
import 'package:better_informed_mobile/domain/auth/data/token_data.dart';

abstract class AuthStore {
  Future<void> save(AuthToken token);

  Future<AuthToken?> read();

  Future<TokenData?> accessTokenData();

  Future<void> delete();
}
