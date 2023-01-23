import 'package:flutter/material.dart';

extension TargetPlatformExtension on TargetPlatform {
  bool get isApple => this == TargetPlatform.iOS || this == TargetPlatform.macOS;

  bool get isAndroid => this == TargetPlatform.android;
}
