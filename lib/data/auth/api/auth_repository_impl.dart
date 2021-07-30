import 'package:better_informed_mobile/domain/auth/auth_repository.dart';
import 'package:better_informed_mobile/domain/auth/data/sign_in_provider.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {


  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> requestMagicLink(String email) {
    // TODO: implement requestMagicLink
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithProvider(String token, SignInProvider provider) {
    // TODO: implement signInWithProvider
    throw UnimplementedError();
  }
}
