import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/is_showing_daily_brief_badge_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/set_should_show_daily_brief_badge_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/daily_brief_badge_switch/daily_brief_badge_switch_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DailyBriefBadgeSwitchCubit extends Cubit<DailyBriefBadgeSwitchState> {
  DailyBriefBadgeSwitchCubit(
    this._setShouldShowDailyBriefBadgeUseCase,
    this._isShowingDailyBriefBadgeUseCase,
  ) : super(DailyBriefBadgeSwitchState.notInitialized());

  final SetShouldShowDailyBriefBadgeUseCase _setShouldShowDailyBriefBadgeUseCase;
  final IsShowingDailyBriefBadgeUseCase _isShowingDailyBriefBadgeUseCase;

  Future<void> initialize() async {
    await _isShowingDailyBriefBadge();
  }

  Future<void> _isShowingDailyBriefBadge() async {
    final isShowingBadge = await _isShowingDailyBriefBadgeUseCase();
    emit(DailyBriefBadgeSwitchState.idle(isShowingBadge));
  }

  Future<void> setShouldShowDailyBriefBadge(bool shouldShow) async {
    await _setShouldShowDailyBriefBadgeUseCase(shouldShow);
    await _isShowingDailyBriefBadge();
  }
}
