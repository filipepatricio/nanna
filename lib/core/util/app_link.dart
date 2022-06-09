import 'dart:io';

String get platformStoreLink {
  if (Platform.isAndroid) {
    return 'market://details?id=so.informed';
  }

  return 'https://apps.apple.com/fi/app/informed-news/id1577915307';
}
