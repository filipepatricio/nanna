import 'package:better_informed_mobile/data/tutorial_appearance/store/appearance_preferences_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppearancePreferencesDatabase, env: mockEnvs)
class AppearancePreferencesMockDatabase implements AppearancePreferencesDatabase {
  @override
  Future<double> getPreferredArticleTextScaleFactor(String userUuid) async => 1.0;

  @override
  Future<void> resetUserAppearancePreferences(String userUuid) async {}

  @override
  Future<void> setPreferredArticleTextScaleFactor(String userUuid, double textScaleFactor) async {}
}
