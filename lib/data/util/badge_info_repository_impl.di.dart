import 'package:better_informed_mobile/data/util/badge_info_data_source.di.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/badge_info_repository.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BadgeInfoRepository, env: liveEnvs)
class BadgeInfoRepositoryImpl implements BadgeInfoRepository {
  BadgeInfoRepositoryImpl(this._badgeInfoDataSource);

  final BadgeInfoDataSource _badgeInfoDataSource;

  @override
  Future<bool> shouldRefreshDailyBrief() async {
    final shouldRefreshDailyBrief = _badgeInfoDataSource.shouldRefreshDailyBrief();
    await FlutterAppBadger.removeBadge();
    return shouldRefreshDailyBrief;
  }

  @override
  Future<void> needsRefreshDailyBrief(int badgeCount) async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      await FlutterAppBadger.updateBadgeCount(badgeCount);
    }
    await _badgeInfoDataSource.needsRefreshDailyBrief();
  }

  @override
  Future<void> setShouldShowDailyBriefBadge(bool shouldShowDailyBriefBadge) async {
    await _badgeInfoDataSource.setShouldShowDailyBriefBadge(shouldShowDailyBriefBadge);
  }

  @override
  Future<bool> isShowingDailyBriefBadge() async {
    return await _badgeInfoDataSource.isShowingDailyBriefBadge();
  }
}
