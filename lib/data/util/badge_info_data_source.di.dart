import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _shouldRefreshBriefKey = "shouldRefreshBriefKey";
const _shouldShowDailyBriefBadgeKey = "shouldShowDailyBriefBadgeKey";

@lazySingleton
class BadgeInfoDataSource {
  BadgeInfoDataSource(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  Future<bool> shouldRefreshDailyBrief() async {
    final shouldRefreshBrief = _sharedPreferences.getBool(_shouldRefreshBriefKey) ?? false;
    await _sharedPreferences.setBool(_shouldRefreshBriefKey, false);
    return shouldRefreshBrief;
  }

  Future<void> needsRefreshDailyBrief() async {
    await _sharedPreferences.setBool(_shouldRefreshBriefKey, true);
  }

  Future<void> setShouldShowDailyBriefBadge(bool shouldShowDailyBriefBadge) async {
    await _sharedPreferences.setBool(_shouldShowDailyBriefBadgeKey, shouldShowDailyBriefBadge);
  }

  Future<bool> isShowingDailyBriefBadge() async {
    final isShowingDailyBriefBadge = _sharedPreferences.getBool(_shouldShowDailyBriefBadgeKey);
    if (isShowingDailyBriefBadge == null) {
      await setShouldShowDailyBriefBadge(true);
    }

    return isShowingDailyBriefBadge ?? true;
  }
}
