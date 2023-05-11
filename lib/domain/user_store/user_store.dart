abstract class UserStore {
  Future<String> getCurrentUserUuid();

  Future<void> setCurrentUserUuid(String userUuid);

  Future<void> clearCurrentUserUuid();

  Future<void> setGuestMode();

  Future<bool> isGuestMode();

  Future<void> clearGuestMode();

  // Stream<bool> get isGuestModeStream;

  // Future<void> dispose();
}
