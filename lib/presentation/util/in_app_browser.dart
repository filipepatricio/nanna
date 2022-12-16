import 'dart:io';

import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dt.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:url_launcher/url_launcher.dart' as url_launcher;

typedef OpenInAppBrowserErrorCallback = Function(dynamic error, StackTrace stackTrace);

Future<void> openInAppBrowser(String uri, [OpenInAppBrowserErrorCallback? onError]) async {
  try {
    await _openWithCustomTabs(uri, onError);
  } catch (_) {
    await _openWithAnyApp(uri, onError);
  }
}

void showBrowserError(String uri, SnackbarController controller) {
  controller.showMessage(
    _browserErrorMessage(uri, controller),
  );
}

Future<void> _openWithCustomTabs(String uri, OpenInAppBrowserErrorCallback? onError) async {
  if (Platform.isIOS) {
    await _openWithAnyApp(uri, onError);
  } else {
    await custom_tabs.launch(uri);
  }
}

Future<void> _openWithAnyApp(String uri, OpenInAppBrowserErrorCallback? onError) async {
  try {
    await url_launcher.launchUrl(Uri.parse(uri));
  } catch (e, s) {
    onError?.call(e, s);
  }
}

SnackbarMessage _browserErrorMessage(String uri, SnackbarController snackbarController) {
  return SnackbarMessage.custom(
    message: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: LocaleKeys.common_error_noBrowser.tr(),
            style: AppTypography.b2Regular.copyWith(color: AppColors.stateTextSecondary),
          ),
          TextSpan(
            text: uri,
            style: AppTypography.b2Regular.copyWith(
              color: AppColors.stateTextSecondary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => _copyUriToClipboard(uri, snackbarController),
          ),
        ],
      ),
    ),
    type: SnackbarMessageType.negative,
  );
}

void _copyUriToClipboard(String uri, SnackbarController snackbarController) {
  Clipboard.setData(ClipboardData(text: uri));
  snackbarController.showMessage(
    SnackbarMessage.simple(
      message: tr(LocaleKeys.common_linkCopied),
      type: SnackbarMessageType.positive,
    ),
  );
}
