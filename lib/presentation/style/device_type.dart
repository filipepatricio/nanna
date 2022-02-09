import 'package:flutter/material.dart';

bool get kIsSmallDevice => kDeviceType == DeviceType.small;

bool get kIsNotSmallDevice => kDeviceType != DeviceType.small;

DeviceType kDeviceType = DeviceType.regular;

enum DeviceType { small, regular, large }

DeviceType getDeviceType(Size screenSize) {
  // See: https://www.ios-resolution.com
  // 360 up to 768 are regular-sized devices
  if (screenSize.width < 360) {
    return DeviceType.small;
  } else if (screenSize.width >= 768) {
    return DeviceType.large;
  } else {
    return DeviceType.regular;
  }
}
