import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/user/data/user.dart';
import 'package:better_informed_mobile/domain/user/user_local_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserLocalRepository, env: mockEnvs)
class UserLocalRepositoryMock implements UserLocalRepository {
  @override
  Future<void> deleteUser() async {}

  @override
  Future<User?> loadUser() async {
    return null;
  }

  @override
  Future<void> saveUser(User user) async {}
}
