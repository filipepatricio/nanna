import 'package:flutter/foundation.dart';

String get platformStoreLink {
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'market://details?id=so.informed';
  }

  return 'https://apps.apple.com/fi/app/informed-news/id1577915307';
}
