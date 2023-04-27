import 'package:better_informed_mobile/data/tutorial_appearance/store/appearance_preferences_database.dart';
import 'package:better_informed_mobile/domain/appearance/appearance_preferences_store.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppearancePreferencesStore)
class AppearancePreferencesStoreImpl extends AppearancePreferencesStore {
  AppearancePreferencesStoreImpl(this._database);

  final AppearancePreferencesDatabase _database;

  @override
  Future<double> getPreferredArticleTextScaleFactor(String userUuid) async {
    return await _database.getPreferredArticleTextScaleFactor(userUuid);
  }

  @override
  Future<void> resetUserAppearancePreferences(String userUuid) async {
    return await _database.resetUserAppearancePreferences(userUuid);
  }

  @override
  Future<void> setPreferredArticleTextScaleFactor(String userUuid, double textScaleFactor) async {
    return await _database.setPreferredArticleTextScaleFactor(userUuid, textScaleFactor);
  }
}
