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

Future<void> _openWithCustomTabs(String uri, OpenInAppBrowserErrorCallback? onError) async {
  await custom_tabs.launch(uri);
}

Future<void> _openWithAnyApp(String uri, OpenInAppBrowserErrorCallback? onError) async {
  try {
    await url_launcher.launch(uri);
  } catch (e, s) {
    onError?.call(e, s);
  }
}
