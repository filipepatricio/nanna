import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/should_show_daily_brief_state_notifier.di.dart';
import 'package:injectable/injectable.dart';

@injectable
class ShouldShowDailyBriefBadgeStateStreamUseCase {
  ShouldShowDailyBriefBadgeStateStreamUseCase(this._notifier);

  final ShouldShowDailyBriefBadgeStateNotifier _notifier;

  Stream<bool> call() {
    return _notifier.stream;
  }
}
