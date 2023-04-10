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
  Future<void> updateBadgeCount(int badgeCount) async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      await FlutterAppBadger.updateBadgeCount(badgeCount);
    }
  }

  @override
  Future<void> setNeedsRefreshDailyBrief(bool needsRefreshDailyBrief) async {
    await _badgeInfoDataSource.needsRefreshDailyBrief(needsRefreshDailyBrief);
  }

  @override
  Future<bool> setShouldShowDailyBriefBadge(bool shouldShowDailyBriefBadge) async {
    await _badgeInfoDataSource.setShouldShowDailyBriefBadge(shouldShowDailyBriefBadge);
    return shouldShowDailyBriefBadge;
  }

  @override
  Future<bool> shouldShowDailyBriefBadge() async {
    return await _badgeInfoDataSource.isShowingDailyBriefBadge();
  }
}
