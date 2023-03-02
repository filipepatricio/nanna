import 'package:better_informed_mobile/domain/daily_brief_badge/badge_info_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/should_show_daily_brief_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShouldShowDailyBriefBadgeUseCase {
  ShouldShowDailyBriefBadgeUseCase(this._badgeInfoRepository, this._notifier);
  final BadgeInfoRepository _badgeInfoRepository;

  final ShouldShowDailyBriefBadgeStateNotifier _notifier;

  Future<bool> call() => _badgeInfoRepository.shouldShowDailyBriefBadge();

  Stream<bool> get stream {
    return _notifier.stream;
  }
}
