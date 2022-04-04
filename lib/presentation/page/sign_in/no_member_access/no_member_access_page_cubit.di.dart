import 'package:better_informed_mobile/domain/auth/auth_exception.dt.dart';
import 'package:better_informed_mobile/domain/auth/data/sign_in_credentials.dart';
import 'package:better_informed_mobile/domain/auth/use_case/sign_in_with_invite_code_use_case.di.dart';
import 'package:better_informed_mobile/domain/onboarding/use_case/is_onboarding_seen_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/sign_in/no_member_access/no_member_access_page_state.dt.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

const _email = 'feedback@informed.so';
const _waitlistLink = 'https://get.informed.so/';

@injectable
class NoMemberAccessPageCubit extends Cubit<NoMemberAccessPageState> {
  final SignInWithInviteCodeUseCase _signInWithInviteCodeUseCase;
  final IsOnboardingSeenUseCase _isOnboardingSeenUseCase;

  late SignInCredentials _credentials;

  NoMemberAccessPageCubit(
    this._signInWithInviteCodeUseCase,
    this._isOnboardingSeenUseCase,
  ) : super(NoMemberAccessPageState.idle());

  void initialize(SignInCredentials credentials) {
    _credentials = credentials;
  }

  Future<void> sendAccessEmail(String subject, String body) async {
    final mailToLink = Uri.parse('mailto:$_email?subject=$subject&body=$body').toString();

    try {
      await launch(mailToLink);
    } catch (_) {
      await Clipboard.setData(const ClipboardData(text: _email));
      emit(NoMemberAccessPageState.emailCopied());
      emit(NoMemberAccessPageState.idle());
    }
  }

  Future<void> openWaitlist() async {
    await openInAppBrowser(
      _waitlistLink,
      (_, __) {
        emit(NoMemberAccessPageState.browserError(_waitlistLink));
        emit(NoMemberAccessPageState.idle());
      },
    );
  }

  Future<void> signInWithInviteCode(String code) async {
    emit(NoMemberAccessPageState.processing());

    try {
      await _signInWithInviteCodeUseCase.call(_credentials, code);
      final isOnboardingSeen = await _isOnboardingSeenUseCase.call();
      emit(NoMemberAccessPageState.success(isOnboardingSeen));
    } on AuthException catch (authException) {
      authException.map(
        noMemberAccess: (_) => emit(NoMemberAccessPageState.noMemberAccess()),
        unknown: (_) => emit(NoMemberAccessPageState.generalError()),
      );
    } catch (e, s) {
      Fimber.e('Signing in with invitation code failed', ex: e, stacktrace: s);
      emit(NoMemberAccessPageState.generalError());
    } finally {
      emit(NoMemberAccessPageState.idle());
    }
    return;
  }
}
