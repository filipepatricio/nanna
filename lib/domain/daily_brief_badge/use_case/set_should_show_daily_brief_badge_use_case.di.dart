import 'package:better_informed_mobile/domain/daily_brief_badge/badge_info_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/update_should_show_daily_brief_badge_state_notifier_use_case.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class SetShouldShowDailyBriefBadgeUseCase {
  SetShouldShowDailyBriefBadgeUseCase(
    this._badgeInfoRepository,
    this._updateShouldShowDailyBriefBadgeStateNotifierUseCase,
  );
  final BadgeInfoRepository _badgeInfoRepository;
  final UpdateShouldShowDailyBriefBadgeStateNotifierUseCase _updateShouldShowDailyBriefBadgeStateNotifierUseCase;

  Future<void> call(bool shouldShowDailyBriefBadge) async {
    final shouldShowBadge = await _badgeInfoRepository.setShouldShowDailyBriefBadge(shouldShowDailyBriefBadge);
    _updateShouldShowDailyBriefBadgeStateNotifierUseCase.call(shouldShowBadge);
  }
}
