import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/set_should_show_daily_brief_badge_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/should_show_daily_brief_badge_use_case.di.dart';
import 'package:better_informed_mobile/domain/subscription/data/active_subscription.dt.dart';
import 'package:better_informed_mobile/domain/subscription/use_case/get_active_subscription_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/notifications/daily_brief_badge_switch/daily_brief_badge_switch_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class DailyBriefBadgeSwitchCubit extends Cubit<DailyBriefBadgeSwitchState> {
  DailyBriefBadgeSwitchCubit(
    this._setShouldShowDailyBriefBadgeUseCase,
    this._shouldShowDailyBriefBadgeUseCase,
    this._getActiveSubscriptionUseCase,
  ) : super(const DailyBriefBadgeSwitchState.loading());

  final SetShouldShowDailyBriefBadgeUseCase _setShouldShowDailyBriefBadgeUseCase;
  final ShouldShowDailyBriefBadgeUseCase _shouldShowDailyBriefBadgeUseCase;
  final GetActiveSubscriptionUseCase _getActiveSubscriptionUseCase;

  StreamSubscription? _activeSubscriptionStreamSubscription;

  @override
  Future<void> close() async {
    await _activeSubscriptionStreamSubscription?.cancel();
    await super.close();
  }

  Future<void> initialize() async {
    await _emitIdleState(await _getActiveSubscriptionUseCase());
    _activeSubscriptionStreamSubscription = _getActiveSubscriptionUseCase.stream.listen(_emitIdleState);
  }

  Future<void> setShouldShowDailyBriefBadge(bool shouldShow) async {
    await state.mapOrNull(
      premiumOrTrial: (_) async {
        await _setShouldShowDailyBriefBadgeUseCase(shouldShow);
        await _emitIdleState(await _getActiveSubscriptionUseCase());
      },
    );
  }

  Future<void> _emitIdleState(ActiveSubscription activeSubscription) async {
    final isShowingBadge = await _shouldShowDailyBriefBadgeUseCase();
    emit(
      activeSubscription.maybeMap<DailyBriefBadgeSwitchState>(
        free: (_) => DailyBriefBadgeSwitchState.free(isShowingBadge),
        orElse: () => DailyBriefBadgeSwitchState.premiumOrTrial(isShowingBadge),
      ),
    );
  }
}
