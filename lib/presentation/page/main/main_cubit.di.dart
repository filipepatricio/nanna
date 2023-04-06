import 'dart:async';
import 'dart:math';

import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/auth/use_case/get_token_expiration_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/daily_brief/use_case/notify_brief_use_case.di.dart';
import 'package:better_informed_mobile/domain/deep_link/use_case/subscribe_for_deep_link_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/use_paid_subscription_change_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/language/language_code.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_navigation_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/maybe_register_push_notification_token_use_case.di.dart';
import 'package:better_informed_mobile/domain/release_notes/use_case/get_current_release_note_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/initialize_synchronization_engine_use_case.di.dart';
import 'package:better_informed_mobile/domain/synchronization/use_case/synchronize_on_connection_change_use_case.di.dart';
import 'package:better_informed_mobile/domain/util/use_case/should_refresh_daily_brief_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dt.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

const _backgroundRefreshInterval = Duration(minutes: 10);

@injectable
class MainCubit extends Cubit<MainState> {
  MainCubit(
    this._getTokenExpirationStreamUseCase,
    this._maybeRegisterPushNotificationTokenUseCase,
    this._incomingPushNavigationStreamUseCase,
    this._subscribeForDeepLinkUseCase,
    this._getCurrentReleaseNoteUseCase,
    this._usePaidSubscriptionChangeStreamUseCase,
    this._initializeSynchronizationEngineUseCase,
    this._synchronizeOnConnectionChangeUseCase,
    this._updateBriefNotifierUseCase,
    this._shouldRefreshDailyBriefUseCase,
  ) : super(const MainState.init());

  final GetTokenExpirationStreamUseCase _getTokenExpirationStreamUseCase;
  final MaybeRegisterPushNotificationTokenUseCase _maybeRegisterPushNotificationTokenUseCase;
  final IncomingPushNavigationStreamUseCase _incomingPushNavigationStreamUseCase;
  final SubscribeForDeepLinkUseCase _subscribeForDeepLinkUseCase;
  final GetCurrentReleaseNoteUseCase _getCurrentReleaseNoteUseCase;
  final UsePaidSubscriptionChangeStreamUseCase _usePaidSubscriptionChangeStreamUseCase;
  final InitializeSynchronizationEngineUseCase _initializeSynchronizationEngineUseCase;
  final SynchronizeOnConnectionChangeUseCase _synchronizeOnConnectionChangeUseCase;
  final UpdateBriefNotifierUseCase _updateBriefNotifierUseCase;
  final ShouldRefreshDailyBriefUseCase _shouldRefreshDailyBriefUseCase;

  StreamSubscription? _incomingPushNavigationSubscription;
  StreamSubscription? _tokenExpirationSubscription;
  StreamSubscription? _deepLinkSubscription;
  StreamSubscription? _usePaidSubscriptionFlagChangeSubscription;
  StreamSubscription? _syncOnConnectionChangeSubscription;

  DateTime? _movedToBackgroundAt;

  @override
  Future<void> close() async {
    await _incomingPushNavigationSubscription?.cancel();
    await _tokenExpirationSubscription?.cancel();
    await _deepLinkSubscription?.cancel();
    await _usePaidSubscriptionFlagChangeSubscription?.cancel();
    await _syncOnConnectionChangeSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    await DateFormatUtil.setJiffyLocale(availableLocales.values.first);
    _tokenExpirationSubscription = _getTokenExpirationStreamUseCase().listen((event) {
      emit(const MainState.tokenExpired());
    });

    _subscribeToPushNavigationStream();
    _subscribeToDeepLinkStream();
    _subscribeToPaidSubscriptionChangeStream();

    unawaited(_maybeRegisterPushNotificationTokenUseCase());
    unawaited(_getReleaseNote());
    unawaited(_initializeSynchronizationEngine());
  }

  void appMovedToBackground() {
    _movedToBackgroundAt ??= clock.now();
  }

  void appMovedToForeground() {
    final movedToBackgroundAt = _movedToBackgroundAt;
    if (movedToBackgroundAt != null) {
      _movedToBackgroundAt = null;

      final duration = clock.now().difference(movedToBackgroundAt);

      if (duration > _backgroundRefreshInterval) {
        scheduleMicrotask(() {
          _shouldRefreshDailyBriefUseCase();
          _updateBriefNotifierUseCase();
        });
      }
    }
  }

  void _subscribeToPushNavigationStream() {
    _incomingPushNavigationSubscription = _incomingPushNavigationStreamUseCase().listen((event) {
      emit(_handleNavigationAction(event.path));
      emit(const MainState.init());
    });
  }

  void _subscribeToDeepLinkStream() {
    _deepLinkSubscription = _subscribeForDeepLinkUseCase().listen((path) async {
      emit(_handleNavigationAction(path));
      emit(const MainState.init());
    });
  }

  void _subscribeToPaidSubscriptionChangeStream() {
    _usePaidSubscriptionFlagChangeSubscription = _usePaidSubscriptionChangeStreamUseCase().listen((event) {
      emit(const MainState.resetRouteStack());
      emit(const MainState.init());
    });
  }

  Future<void> _initializeSynchronizationEngine() async {
    if (!kIsTest) {
      await Future.delayed(const Duration(seconds: 5));
      if (isClosed) return;
    }

    try {
      await _initializeSynchronizationEngineUseCase();
    } finally {
      _syncOnConnectionChangeSubscription = _synchronizeOnConnectionChangeUseCase();
    }
  }

  Future<void> _getReleaseNote() async {
    try {
      final releaseNote = await _getCurrentReleaseNoteUseCase();
      if (releaseNote != null) {
        emit(MainState.showReleaseNote(releaseNote));
        emit(const MainState.init());
      }
    } catch (e, s) {
      Fimber.e('Getting release note failed', ex: e, stacktrace: s);
    }
  }

  MainState _handleNavigationAction(String path) {
    if (path.isEmpty) {
      return state;
    }

    final uri = Uri.parse(path);

    if (uri.pathSegments.any((segment) => segment == magicLinkSegment)) {
      return MainState.navigate(const MainPageRoute().path);
    }

    if (uri.pathSegments.any((segment) => segment == unsubscribeNotificationsPath)) {
      return MainState.multiNavigate(
        [
          const MainPageRoute().path,
          const ProfileTabGroupRouter().path,
          const SettingsMainPageRoute().path,
          const SettingsNotificationsPageRoute().path,
        ],
      );
    }

    final articleIndex = uri.pathSegments.indexOf(articlePath);
    final topicSlug = _findTopicSlug(path);

    if (articleIndex >= 0) {
      if (topicSlug != null) {
        final topicSegment = uri.pathSegments.take(max(0, articleIndex)).join('/');
        final articleSegment = uri.pathSegments.skip(max(0, articleIndex)).join('/');

        final articleUri = Uri(path: articleSegment, queryParameters: {'topicSlug': topicSlug});

        return MainState.multiNavigate([
          const MainPageRoute().path,
          const DailyBriefTabGroupRouter().path,
          topicSegment,
          articleUri.toString(),
        ]);
      }

      return MainState.navigate(const MainPageRoute().path + path);
    }

    if (topicSlug != null) return MainState.navigate(const MainPageRoute().path + path);

    final finalPath = path.split('/');
    if (finalPath.length > 1) {
      return MainState.multiNavigate(
        [
          const MainPageRoute().path,
          ...finalPath,
        ],
      );
    }

    return MainState.navigate(const MainPageRoute().path + path);
  }

  String? _findTopicSlug(String path) {
    final uri = Uri.parse(path);
    final topicsSegment = uri.pathSegments.firstWhere((segment) => segment == topicsPath, orElse: () => '');
    final topicSegmentIndex = uri.pathSegments.indexOf(topicsSegment);

    if (topicSegmentIndex != -1 && uri.pathSegments.length > topicSegmentIndex + 1) {
      return uri.pathSegments[topicSegmentIndex + 1];
    }

    return null;
  }
}
