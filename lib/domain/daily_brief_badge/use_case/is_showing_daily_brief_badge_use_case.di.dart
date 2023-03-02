import 'package:better_informed_mobile/domain/daily_brief_badge/badge_info_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class IsShowingDailyBriefBadgeUseCase {
  IsShowingDailyBriefBadgeUseCase(this._badgeInfoRepository);
  final BadgeInfoRepository _badgeInfoRepository;

  Future<bool> call() => _badgeInfoRepository.isShowingDailyBriefBadge();
}
