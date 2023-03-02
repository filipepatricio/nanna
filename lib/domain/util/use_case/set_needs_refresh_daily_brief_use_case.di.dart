import 'package:better_informed_mobile/domain/daily_brief_badge/badge_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetNeedsRefreshDailyBriefUseCase {
  SetNeedsRefreshDailyBriefUseCase(this._badgeInfoRepository);

  final BadgeInfoRepository _badgeInfoRepository;

  Future<void> call(int badgeCount) => _badgeInfoRepository.needsRefreshDailyBrief(badgeCount);
}
