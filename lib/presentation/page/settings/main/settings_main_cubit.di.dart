import 'package:better_informed_mobile/domain/auth/use_case/sign_out_use_case.di.dart';
import 'package:better_informed_mobile/domain/user/use_case/is_guest_mode_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class SettingsMainCubit extends Cubit<SettingsMainState> {
  SettingsMainCubit(
    this._signOutUseCase,
    this._isGuestModeUseCase,
  ) : super(const SettingsMainState.init());

  final SignOutUseCase _signOutUseCase;
  final IsGuestModeUseCase _isGuestModeUseCase;

  Future<void> initialize() async {
    if (await _isGuestModeUseCase()) {
      emit(const SettingsMainState.guest());
      return;
    }

    emit(const SettingsMainState.idle());
  }

  Future<void> signOut() async {
    emit(const SettingsMainState.loading());

    try {
      await _signOutUseCase();
    } catch (e, s) {
      Fimber.e('Signing out failed', ex: e, stacktrace: s);
      emit(const SettingsMainState.idle());
    }
  }

  Future<void> sendFeedbackEmail(String email, String subject) async {
    final mailToLink = Uri.parse('mailto:$email?subject=$subject');

    try {
      await launchUrl(mailToLink);
    } catch (_) {
      await _sendEmailWithFallbackOption(email, subject);
    }
  }

  Future<void> _sendEmailWithFallbackOption(String email, String subject) async {
    final emailData = Email(
      subject: subject,
      recipients: [email],
    );

    try {
      await FlutterEmailSender.send(emailData);
    } catch (_) {
      emit(SettingsMainState.sendingEmailError());
      state.mapOrNull(
        init: (state) => emit(state),
      );
    }
  }
}
