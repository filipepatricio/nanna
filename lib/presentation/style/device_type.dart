import 'package:flutter/material.dart';

bool kIsSmallDevice = kDeviceType == DeviceType.small;

DeviceType kDeviceType = DeviceType.regular;

enum DeviceType { small, regular, large }

DeviceType getDeviceType(Size screenSize) {
  // See: https://www.ios-resolution.com
  if (screenSize.width < 360) {
    return DeviceType.small;
  } else if (screenSize.width >= 768) {
    return DeviceType.large;
  } else {
    return DeviceType.regular;
  }
}
