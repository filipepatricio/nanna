import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/user_store/user_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: UserStore, env: mockEnvs)
class UserStoreMock implements UserStore {
  @override
  Future<String> getCurrentUserUuid() async {
    return '';
  }

  @override
  Future<void> clearCurrentUserUuid() async {}

  @override
  Future<void> setCurrentUserUuid(String userUuid) async {}

  @override
  Future<void> clearGuestMode() async {}

  @override
  Future<bool> isGuestMode() async {
    return false;
  }

  @override
  Future<void> setGuestMode() async {}

  // @override
  // Stream<bool> get isGuestModeStream => Stream.value(false);

  // @override
  // Future<void> dispose() async {}
}
