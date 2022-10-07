import 'dart:async';
import 'dart:math';

import 'package:better_informed_mobile/domain/auth/use_case/get_token_expiration_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/deep_link/use_case/subscribe_for_deep_link_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/use_paid_subscription_change_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/language/language_code.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_navigation_stream_use_case.di.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/maybe_register_push_notification_token_use_case.di.dart';
import 'package:better_informed_mobile/domain/release_notes/use_case/get_current_release_note_use_case.di.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dt.dart';
import 'package:better_informed_mobile/presentation/routing/main_router.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainCubit extends Cubit<MainState> {
  MainCubit(
    this._getTokenExpirationStreamUseCase,
    this._maybeRegisterPushNotificationTokenUseCase,
    this._incomingPushNavigationStreamUseCase,
    this._subscribeForDeepLinkUseCase,
    this._getCurrentReleaseNoteUseCase,
    this._usePaidSubscriptionChangeStreamUseCase,
  ) : super(const MainState.init());

  final GetTokenExpirationStreamUseCase _getTokenExpirationStreamUseCase;
  final MaybeRegisterPushNotificationTokenUseCase _maybeRegisterPushNotificationTokenUseCase;
  final IncomingPushNavigationStreamUseCase _incomingPushNavigationStreamUseCase;
  final SubscribeForDeepLinkUseCase _subscribeForDeepLinkUseCase;
  final GetCurrentReleaseNoteUseCase _getCurrentReleaseNoteUseCase;
  final UsePaidSubscriptionChangeStreamUseCase _usePaidSubscriptionChangeStreamUseCase;

  StreamSubscription? _incomingPushNavigationSubscription;
  StreamSubscription? _tokenExpirationSubscription;
  StreamSubscription? _deepLinkSubscription;
  StreamSubscription? _usePaidSubscriptionFlagChangeSubscription;

  @override
  Future<void> close() async {
    await _incomingPushNavigationSubscription?.cancel();
    await _tokenExpirationSubscription?.cancel();
    await _deepLinkSubscription?.cancel();
    await _usePaidSubscriptionFlagChangeSubscription?.cancel();
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

    try {
      await _maybeRegisterPushNotificationTokenUseCase();
    } catch (e, s) {
      Fimber.e('Push token registration failed', ex: e, stacktrace: s);
    }

    await _getReleaseNote();
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
    final uri = Uri.parse(path);

    if (uri.pathSegments.any((segment) => segment == magicLinkSegment)) {
      return MainState.navigate(const MainPageRoute().path);
    }

    final articleIndex = uri.pathSegments.indexOf(articlePathSegment);

    if (articleIndex > 0) {
      final topicSlug = _findTopicSlug(path);

      if (topicSlug != null) {
        final topicSegment = '${const MainPageRoute().path}/${uri.pathSegments.take(max(0, articleIndex)).join('/')}';
        final articleSegment = '${const MainPageRoute().path}/${uri.pathSegments.skip(max(0, articleIndex)).join('/')}';

        final articleUri = Uri(path: articleSegment, queryParameters: {'topicSlug': topicSlug});
        return MainState.multiNavigate([topicSegment, articleUri.toString()]);
      }
    }

    return MainState.navigate(const MainPageRoute().path + path);
  }

  String? _findTopicSlug(String path) {
    final uri = Uri.parse(path);
    final topicsSegment = uri.pathSegments.firstWhere((segment) => segment == topicsPathSegment, orElse: () => '');
    final topicSegmentIndex = uri.pathSegments.indexOf(topicsSegment);

    if (topicSegmentIndex != -1 && uri.pathSegments.length > topicSegmentIndex + 1) {
      return uri.pathSegments[topicSegmentIndex + 1];
    }

    return null;
  }
}
