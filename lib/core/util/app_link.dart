import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

String get platformStoreLink {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'market://details?id=so.informed';
  }

  return 'https://apps.apple.com/fi/app/informed-news/id1577915307';
}

String get appleCodeRedemptionLink {
  return 'https://apps.apple.com/redeem?ctx=offercodes&id=1577915307';
}

Future<void> openUrlWithAnyApp(String uri, OpenInAppBrowserErrorCallback? onError) async {
  try {
    await launchUrl(Uri.parse(uri));
  } catch (e, s) {
    onError?.call(e, s);
  }
}
