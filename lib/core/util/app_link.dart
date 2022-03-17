import 'dart:io';

String get platformStoreLink {
  if (Platform.isAndroid) {
    return 'https://play.google.com/store/apps/details?id=so.informed';
  }

  return 'https://apps.apple.com/fi/app/informed-news/id1577915307';
}
