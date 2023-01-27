import 'package:better_informed_mobile/domain/user/data/user.dart';

abstract class UserLocalRepository {
  Future<void> saveUser(User user);

  Future<User?> loadUser();

  Future<void> deleteUser();
}
