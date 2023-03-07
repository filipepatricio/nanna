import 'package:better_informed_mobile/domain/daily_brief_badge/badge_info_repository.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/should_show_daily_brief_state_notifier.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class ShouldShowDailyBriefBadgeUseCase {
  ShouldShowDailyBriefBadgeUseCase(
    this._badgeInfoRepository,
    this._notifier,
    this._getActiveSubscriptionUseCase,
  );
  final BadgeInfoRepository _badgeInfoRepository;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  final ShouldShowDailyBriefBadgeStateNotifier _notifier;

  Future<bool> call() async {
    final activeSubscription = await _getActiveSubscriptionUseCase();
    return activeSubscription.isFree ? Future.value(true) : _badgeInfoRepository.shouldShowDailyBriefBadge();
  }

  Stream<bool> get stream {
    return Rx.combineLatest2(
        Rx.concat(
          [
            _getActiveSubscriptionUseCase().asStream(),
            _getActiveSubscriptionUseCase.stream,
          ],
        ),
        _notifier.stream, (activeSubscription, shouldShowDailyBriefBadge) {
      if (activeSubscription.isFree) {
        return true;
      } else {
        return shouldShowDailyBriefBadge;
      }
    });
  }
}
