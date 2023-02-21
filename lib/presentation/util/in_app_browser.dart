import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/util/platform_util.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_message.dart';
import 'package:better_informed_mobile/presentation/widget/snackbar/snackbar_parent_view.dart';
import 'package:flutter/foundation.dart';
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

void showBrowserError(BuildContext context, String uri, SnackbarController controller) {
  controller.showMessage(
    _browserErrorMessage(context, uri, controller),
  );
}

Future<void> _openWithCustomTabs(String uri, OpenInAppBrowserErrorCallback? onError) async {
  if (defaultTargetPlatform.isApple) {
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

SnackbarMessage _browserErrorMessage(BuildContext context, String uri, SnackbarController snackbarController) {
  return SnackbarMessage.simple(
    message: context.l10n.common_error_noBrowser,
    subMessage: uri,
    action: SnackbarAction(
      label: context.l10n.common_copy,
      callback: () => _copyUriToClipboard(context, uri, snackbarController),
    ),
    type: SnackbarMessageType.error,
  );
}

void _copyUriToClipboard(BuildContext context, String uri, SnackbarController snackbarController) {
  Clipboard.setData(ClipboardData(text: uri));
  snackbarController.showMessage(
    SnackbarMessage.simple(
      message: context.l10n.common_linkCopied,
      type: SnackbarMessageType.success,
    ),
  );
}
