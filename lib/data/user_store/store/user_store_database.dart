abstract class UserDatabase {
  Future<String> getCurrentUserUuid();

  Future<void> setCurrentUserUuid(String userUuid);

  Future<void> clearCurrentUserUuid();
}
