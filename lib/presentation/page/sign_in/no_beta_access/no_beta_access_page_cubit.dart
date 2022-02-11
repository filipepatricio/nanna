import 'package:better_informed_mobile/presentation/page/sign_in/no_beta_access/no_beta_access_page_state.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

const _email = 'feedback@informed.so';
const _waitlistLink = 'https://get.informed.so/';

@injectable
class NoBetaAccessPageCubit extends Cubit<NoBetaAccessPageState> {
  NoBetaAccessPageCubit() : super(NoBetaAccessPageState.idle());

  Future<void> sendAccessEmail(String subject, String body) async {
    final mailToLink = Uri.parse('mailto:$_email?subject=$subject&body=$body').toString();

    try {
      await launch(mailToLink);
    } catch (_) {
      await Clipboard.setData(const ClipboardData(text: _email));
      emit(NoBetaAccessPageState.emailCopied());
      emit(NoBetaAccessPageState.idle());
    }
  }

  Future<void> openWaitlist() async {
    await openInAppBrowser(
      _waitlistLink,
      (_, __) {
        emit(NoBetaAccessPageState.browserError(_waitlistLink));
        emit(NoBetaAccessPageState.idle());
      },
    );
  }
}
