import 'package:flutter/material.dart';

enum DeviceType { small, regular, large }

/// See: https://www.ios-resolution.com
/// 360 up to 768 are regular-sized devices
DeviceType getDeviceType(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;

  if (screenSize.width < 360 || screenSize.height < 667) {
    return DeviceType.small;
  } else if (screenSize.width >= 768) {
    return DeviceType.large;
  } else {
    return DeviceType.regular;
  }
}

extension DeviceTypeExtension on DeviceType {
  bool get isSmallDevice => _isSmallDevice(this);

  bool get isNotSmallDevice => _isNotSmallDevice(this);
}

extension BuildContextDeviceTypExtension on BuildContext {
  DeviceType get deviceType => getDeviceType(this);

  bool get isSmallDevice => _isSmallDevice(deviceType);

  bool get isNotSmallDevice => _isNotSmallDevice(deviceType);
}

bool _isSmallDevice(DeviceType deviceType) => deviceType == DeviceType.small;

bool _isNotSmallDevice(DeviceType deviceType) => deviceType != DeviceType.small;
