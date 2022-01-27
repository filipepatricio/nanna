import 'package:hive/hive.dart';

abstract class UserStore {
  Future<Box<E>> openBox<E>(String boxName);

  Future<void> setLoggedInUserUuid(String userUuid);

  Future<void> clear();
}
