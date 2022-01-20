import 'dart:async';

import 'package:better_informed_mobile/domain/auth/use_case/get_token_expiration_stream_use_case.dart';
import 'package:better_informed_mobile/domain/language/language_code.dart';
import 'package:better_informed_mobile/domain/push_notification/use_case/maybe_register_push_notification_token_use_case.dart';
import 'package:better_informed_mobile/presentation/page/main/main_state.dart';
import 'package:better_informed_mobile/presentation/util/date_format_util.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainCubit extends Cubit<MainState> {
  final GetTokenExpirationStreamUseCase _getTokenExpirationStreamUseCase;
  final MaybeRegisterPushNotificationTokenUseCase _maybeRegisterPushNotificationTokenUseCase;

  StreamSubscription? _tokenExpirationSubscription;

  MainCubit(this._getTokenExpirationStreamUseCase, this._maybeRegisterPushNotificationTokenUseCase)
      : super(const MainState.init());

  @override
  Future<void> close() async {
    await _tokenExpirationSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    await DateFormatUtil.setJiffyLocale(availableLocales.values.first);
    _tokenExpirationSubscription = _getTokenExpirationStreamUseCase().listen((event) {
      emit(const MainState.tokenExpired());
    });

    try {
      await _maybeRegisterPushNotificationTokenUseCase();
    } catch (e, s) {
      Fimber.e('Push token registration failed', ex: e, stacktrace: s);
    }
  }
}
