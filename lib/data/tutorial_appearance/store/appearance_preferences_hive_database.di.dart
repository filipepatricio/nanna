import 'package:better_informed_mobile/data/tutorial_appearance/store/appearance_preferences_database.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const _hiveBoxName = 'appearancePreferencesBox';
const _textScaleFactorKey = 'textScaleFactor';

const _defaultScaleFactor = 1.0;

@LazySingleton(as: AppearancePreferencesDatabase, env: defaultEnvs)
class AppearancePreferencesHiveDatabase implements AppearancePreferencesDatabase {
  Future<Box<dynamic>> _openUserBox(String userUuid, String hiveBoxName) async {
    final box = await Hive.openBox('${userUuid}_$hiveBoxName');
    return box;
  }

  @override
  Future<double> getPreferredArticleTextScaleFactor(String userUuid) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    final textScaleFactor = box.get(_textScaleFactorKey) as double?;
    return textScaleFactor ?? _defaultScaleFactor;
  }

  @override
  Future<void> resetUserAppearancePreferences(String userUuid) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    await box.clear();
  }

  @override
  Future<void> setPreferredArticleTextScaleFactor(String userUuid, double textScaleFactor) async {
    final box = await _openUserBox(userUuid, _hiveBoxName);
    await box.put(_textScaleFactorKey, textScaleFactor);
  }
}
