import 'package:better_informed_mobile/domain/user/data/user.dart';

abstract class UserRepository {
  Future<User> getUser();
}
