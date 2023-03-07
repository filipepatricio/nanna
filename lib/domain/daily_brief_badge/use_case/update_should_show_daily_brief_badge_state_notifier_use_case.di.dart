import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/should_show_daily_brief_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateShouldShowDailyBriefBadgeStateNotifierUseCase {
  const UpdateShouldShowDailyBriefBadgeStateNotifierUseCase(this._notifier);

  final ShouldShowDailyBriefBadgeStateNotifier _notifier;

  void call(bool shouldShowBadge) => _notifier.notify(shouldShowBadge);
}
