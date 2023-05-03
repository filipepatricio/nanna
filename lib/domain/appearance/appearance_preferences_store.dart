abstract class AppearancePreferencesStore {
  Future<double> getPreferredArticleTextScaleFactor(String userUuid);

  Future<void> setPreferredArticleTextScaleFactor(String userUuid, double textScaleFactor);

  Future<void> resetUserAppearancePreferences(String userUuid);
}
