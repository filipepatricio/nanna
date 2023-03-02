import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/use_case/get_brief_unseen_count_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/should_show_daily_brief_badge_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief_badge/use_case/should_show_daily_brief_badge_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/today_tab_bar_badge/today_tab_bar_badge_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TodayTabBarBadgeCubit extends Cubit<TodayTabBarBadgeState> {
  TodayTabBarBadgeCubit(
    this._getBriefUnseenCountStateStreamUseCase,
    this._shouldShowDailyBriefBadgeUseCase,
    this._shouldShowDailyBriefBadgeStateStreamUseCase,
  ) : super(TodayTabBarBadgeState.initializing());

  final GetBriefUnseenCountStateStreamUseCase _getBriefUnseenCountStateStreamUseCase;
  final ShouldShowDailyBriefBadgeUseCase _shouldShowDailyBriefBadgeUseCase;
  final ShouldShowDailyBriefBadgeStateStreamUseCase _shouldShowDailyBriefBadgeStateStreamUseCase;

  StreamSubscription? _updateBriefUnseenCountStateSubscription;
  StreamSubscription? _shouldShowDailyBriefBadgeStateSubscription;

  @override
  Future<void> close() {
    _updateBriefUnseenCountStateSubscription?.cancel();
    _shouldShowDailyBriefBadgeStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _updateBriefUnseenCountStateSubscription = _getBriefUnseenCountStateStreamUseCase().listen((unseenCount) async {
      final shouldShowBadge = await _shouldShowDailyBriefBadgeUseCase();
      emit(TodayTabBarBadgeState.idle(unseenCount, shouldShowBadge));
    });

    _shouldShowDailyBriefBadgeStateSubscription =
        _shouldShowDailyBriefBadgeStateStreamUseCase().listen((shouldShowBadge) {
      state.mapOrNull(
        idle: (state) {
          emit(TodayTabBarBadgeState.idle(state.unseenCount, shouldShowBadge));
        },
      );
    });
  }
}
