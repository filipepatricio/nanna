abstract class UserDatabase {
  Future<String> getUserLoggedIn();

  Future<void> setUserLoggedIn(String userUuid);

  Future<void> clearUserLoggedIn();
}
