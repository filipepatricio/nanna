abstract class UserStore {
  Future<String> getCurrentUserUuid();

  Future<void> setCurrentUserUuid(String userUuid);

  Future<void> clearCurrentUserUuid();
}
