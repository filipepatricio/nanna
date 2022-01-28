import 'package:better_informed_mobile/presentation/page/profile_tab/profile_page_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit() : super(ProfilePageState.initialLoading());

  Future<void> initialize() async {
    emit(ProfilePageState.idle());
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
      emit(ProfilePageState.sendingEmailError());
    }
  }
}
