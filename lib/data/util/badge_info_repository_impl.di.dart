import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/util/badge_info_repository.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _shouldRefreshBriefKey = "shouldRefreshBriefKey";

@LazySingleton(as: BadgeInfoRepository, env: liveEnvs)
class BadgeInfoRepositoryImpl implements BadgeInfoRepository {
  BadgeInfoRepositoryImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<bool> shouldRefreshDailyBrief() async {
    final shouldRefreshBrief = _sharedPreferences.get(_shouldRefreshBriefKey) as bool;
    await _sharedPreferences.setBool(_shouldRefreshBriefKey, false);
    await FlutterAppBadger.removeBadge();
    return shouldRefreshBrief;
  }

  @override
  Future<void> needsRefreshDailyBrief(int badgeCount) async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      await FlutterAppBadger.updateBadgeCount(badgeCount);
    }
    await _sharedPreferences.setBool(_shouldRefreshBriefKey, true);
  }
}
