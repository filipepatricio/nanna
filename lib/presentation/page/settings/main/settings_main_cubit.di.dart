import 'package:better_informed_mobile/domain/auth/use_case/sign_out_use_case.di.dart';
import 'package:better_informed_mobile/domain/feature_flags/use_case/should_use_paid_subscriptions_use_case.di.dart';
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
    this._shouldUsePaidSubscriptionsUseCase,
  ) : super(const SettingsMainState.init());

  final SignOutUseCase _signOutUseCase;
  final ShouldUsePaidSubscriptionsUseCase _shouldUsePaidSubscriptionsUseCase;

  Future<void> initialize() async {
    emit(SettingsMainState.idle(subscriptionsEnabled: await _shouldUsePaidSubscriptionsUseCase()));
  }

  Future<void> signOut() async {
    emit(const SettingsMainState.loading());

    try {
      await _signOutUseCase();
    } catch (e, s) {
      Fimber.e('Signing out failed', ex: e, stacktrace: s);
      emit(SettingsMainState.idle(subscriptionsEnabled: await _shouldUsePaidSubscriptionsUseCase()));
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
