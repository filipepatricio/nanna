import 'dart:async';

import 'package:better_informed_mobile/domain/auth/data/exceptions.dart';
import 'package:better_informed_mobile/domain/auth/use_case/send_magic_link_use_case.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_in_with_default_provider_use_case.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_in_with_magic_link_token_use_case.dart';
import 'package:better_informed_mobile/domain/auth/use_case/subscribe_for_magic_link_token_use_case.dart';
import 'package:better_informed_mobile/domain/general/is_email_valid_use_case.dart';
import 'package:better_informed_mobile/domain/onboarding/use_case/is_onboarding_seen_use_case.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/sign_in_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInPageCubit extends Cubit<SignInPageState> {
  final IsEmailValidUseCase _isEmailValidUseCase;
  final SendMagicLinkUseCase _sendMagicLinkUseCase;
  final SignInWithDefaultProviderUseCase _signInWithDefaultProviderUseCase;
  final SubscribeForMagicLinkTokenUseCase _subscribeForMagicLinkTokenUseCase;
  final SignInWithMagicLinkTokenUseCase _signInWithMagicLinkTokenUseCase;
  final IsOnboardingSeenUseCase _isOnboardingSeenUseCase;

  StreamSubscription? _magicLinkSubscription;
  late String _email;

  SignInPageCubit(
    this._isEmailValidUseCase,
    this._sendMagicLinkUseCase,
    this._signInWithDefaultProviderUseCase,
    this._subscribeForMagicLinkTokenUseCase,
    this._signInWithMagicLinkTokenUseCase,
    this._isOnboardingSeenUseCase,
  ) : super(SignInPageState.idle(false));

  @override
  Future<void> close() async {
    await _magicLinkSubscription?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    await _subscribeForMagicLink();
  }

  Future<void> updateEmail(String email) async {
    _email = email;
    final valid = await _isEmailValidUseCase(email);
    emit(SignInPageState.idle(valid));
  }

  Future<void> sendMagicLink() async {
    emit(SignInPageState.processing());
    await _sendMagicLinkUseCase(_email);
    emit(SignInPageState.magicLink());
  }

  Future<void> signInWithProvider() async {
    emit(SignInPageState.processing());
    try {
      await _signInWithDefaultProviderUseCase();
      await _finishSignIn();
    } on SignInAbortedException {
      // Do nothing
    } catch (e, s) {
      Fimber.e('Signing in with provider failed', ex: e, stacktrace: s);
    } finally {
      emit(SignInPageState.idle(false));
    }
  }

  Future<void> _subscribeForMagicLink() async {
    _magicLinkSubscription = _subscribeForMagicLinkTokenUseCase().listen((event) async {
      await _signInWithMagicLink(event);
    });
  }

  Future<void> _signInWithMagicLink(String event) async {
    emit(SignInPageState.processing());

    try {
      await _signInWithMagicLinkTokenUseCase(event);
      await _finishSignIn();
    } catch (e, s) {
      Fimber.e('Signing in with magic link failed', ex: e, stacktrace: s);
    } finally {
      emit(SignInPageState.idle(false));
    }
  }

  Future<void> _finishSignIn() async {
    final isOnboardingSeen = await _isOnboardingSeenUseCase.call();
    emit(SignInPageState.success(isOnboardingSeen));
  }
}
