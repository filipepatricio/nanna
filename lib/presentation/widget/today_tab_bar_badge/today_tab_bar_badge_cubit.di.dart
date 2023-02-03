import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/use_case/get_brief_unseen_count_state_stream_use_case.di.dart';
import 'package:better_informed_mobile/presentation/widget/today_tab_bar_badge/today_tab_bar_badge_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class TodayTabBarBadgeCubit extends Cubit<TodayTabBarBadgeState> {
  TodayTabBarBadgeCubit(
    this._getBriefUnseenCountStateStreamUseCase,
  ) : super(TodayTabBarBadgeState.initializing());

  final GetBriefUnseenCountStateStreamUseCase _getBriefUnseenCountStateStreamUseCase;

  StreamSubscription? _shouldBriefUnseenCountStateSubscription;

  @override
  Future<void> close() {
    _shouldBriefUnseenCountStateSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _shouldBriefUnseenCountStateSubscription = _getBriefUnseenCountStateStreamUseCase().listen((unseenCount) {
      emit(TodayTabBarBadgeState.idle(unseenCount));
    });
  }
}
