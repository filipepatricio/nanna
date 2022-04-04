import 'package:better_informed_mobile/domain/auth/use_case/sign_out_use_case.di.dart';
import 'package:better_informed_mobile/presentation/page/settings/main/settings_main_state.dt.dart';
import 'package:bloc/bloc.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class SettingsMainCubit extends Cubit<SettingsMainState> {
  final SignOutUseCase _signOutUseCase;

  SettingsMainCubit(this._signOutUseCase) : super(const SettingsMainState.init());

  Future<void> signOut() async {
    emit(const SettingsMainState.loading());

    try {
      await _signOutUseCase();
    } catch (e, s) {
      Fimber.e('Signing out failed', ex: e, stacktrace: s);
      emit(const SettingsMainState.init());
    }
  }

  Future<void> sendFeedbackEmail(String email, String subject, String body) async {
    final mailToLink = Uri.parse('mailto:$email?subject=$subject&body=$body').toString();

    try {
      await launch(mailToLink);
    } catch (_) {
      await _sendEmailWithFallbackOption(email, subject, body);
    }
  }

  Future<void> _sendEmailWithFallbackOption(String email, String subject, String body) async {
    final emailData = Email(
      body: body,
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
