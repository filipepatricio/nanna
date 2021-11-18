import 'dart:async';

import 'package:better_informed_mobile/domain/analytics/use_case/track_activity_use_case.dart';
import 'package:better_informed_mobile/domain/auth/use_case/get_token_expiration_stream_use_case.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/get_current_brief_use_case.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/maybe_register_push_notification_token_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainCubit extends Cubit<MainState> {
  final GetTokenExpirationStreamUseCase _getTokenExpirationStreamUseCase;
  final MaybeRegisterPushNotificationTokenUseCase _maybeRegisterPushNotificationTokenUseCase;
  final GetCurrentBriefUseCase _getCurrentBriefUseCase;
  final TrackActivityUseCase _trackActivityUseCase;

  StreamSubscription? _tokenExpirationSubscription;
  late String _currentBriefId;

  MainCubit(
    this._getTokenExpirationStreamUseCase,
    this._maybeRegisterPushNotificationTokenUseCase,
    this._getCurrentBriefUseCase,
    this._trackActivityUseCase,
  ) : super(const MainState.init());

  @override
  Future<void> close() async {
    await _tokenExpirationSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _currentBriefId = await _getCurrentBriefUseCase.getId();

    // Need to log the daily brief tab init here, because I depend on [_currentBriefId] to be set before logging
    trackTabView(TodayTabGroupRouter.name);

    _tokenExpirationSubscription = _getTokenExpirationStreamUseCase().listen((event) {
      emit(const MainState.tokenExpired());
    });

    try {
      await _maybeRegisterPushNotificationTokenUseCase();
    } catch (e, s) {
      Fimber.e('Push token registration failed', ex: e, stacktrace: s);
    }
  }

  void trackTabView(String name) {
    switch (name) {
      case TodayTabGroupRouter.name:
        return _trackActivityUseCase.trackDailyBriefPage(_currentBriefId);
      case ExploreTabGroupRouter.name:
        return _trackActivityUseCase.trackPage('Explore Section');
      case ProfileTabGroupRouter.name:
        return _trackActivityUseCase.trackPage('Profile');
      default:
        return;
    }
  }

  void trackTopicView(String topicId) {
    return _trackActivityUseCase.trackTopicPage(topicId);
  }

  void trackExploreAreaView(String areaId) {
    return _trackActivityUseCase.trackExploreAreaPage(areaId);
  }

  void trackPageView(String? name) {
    switch (name) {
      case SettingsMainPageRoute.name:
        return _trackActivityUseCase.trackPage('Settings');
      case SettingsAccountPageRoute.name:
        return _trackActivityUseCase.trackPage('Account Settings');
      case SettingsNotificationsPageRoute.name:
        return _trackActivityUseCase.trackPage('Notification Settings');
    }
  }
}
