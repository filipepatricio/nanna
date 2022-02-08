import 'dart:async';
import 'dart:math';

import 'package:better_informed_mobile/domain/auth/use_case/get_token_expiration_stream_use_case.dart';
import 'package:better_informed_mobile/domain/deep_link/use_case/subscribe_for_deep_link_use_case.dart';
import 'package:better_informed_mobile/domain/language/language_code.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/incoming_push_navigation_stream_use_case.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/maybe_register_push_notification_token_use_case.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainCubit extends Cubit<MainState> {
  final GetTokenExpirationStreamUseCase _getTokenExpirationStreamUseCase;
  final MaybeRegisterPushNotificationTokenUseCase _maybeRegisterPushNotificationTokenUseCase;
  final IncomingPushNavigationStreamUseCase _incomingPushNavigationStreamUseCase;
  final SubscribeForDeepLinkUseCase _subscribeForDeepLinkUseCase;

  StreamSubscription? _incomingPushNavigationSubscription;
  StreamSubscription? _tokenExpirationSubscription;
  StreamSubscription? _deepLinkSubscription;

  MainCubit(
    this._getTokenExpirationStreamUseCase,
    this._maybeRegisterPushNotificationTokenUseCase,
    this._incomingPushNavigationStreamUseCase,
    this._subscribeForDeepLinkUseCase,
  ) : super(const MainState.init());

  @override
  Future<void> close() async {
    await _incomingPushNavigationSubscription?.cancel();
    await _tokenExpirationSubscription?.cancel();
    await _deepLinkSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    await DateFormatUtil.setJiffyLocale(availableLocales.values.first);
    _tokenExpirationSubscription = _getTokenExpirationStreamUseCase().listen((event) {
      emit(const MainState.tokenExpired());
    });

    _subscribeToPushNavigationStream();

    _subscribeToDeepLinkStream();

    try {
      await _maybeRegisterPushNotificationTokenUseCase();
    } catch (e, s) {
      Fimber.e('Push token registration failed', ex: e, stacktrace: s);
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

  MainState _handleNavigationAction(String path) {
    final uri = Uri.parse(path);
    final articleSegment = uri.pathSegments.firstWhere((element) => element == 'article', orElse: () => '');
    final articleIndex = uri.pathSegments.indexOf(articleSegment);

    if (articleIndex != -1) {
      final firstPart = const MainPageRoute().path + '/' + uri.pathSegments.take(max(0, articleIndex)).join('/');
      final secondPart = const MainPageRoute().path + '/' + uri.pathSegments.skip(max(0, articleIndex)).join('/');

      return MainState.multiNavigate([firstPart, secondPart]);
    }

    return MainState.navigate(const MainPageRoute().path + path);
  }
}
