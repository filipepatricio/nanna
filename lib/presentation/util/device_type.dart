enum DeviceType {
  small,
  regular,
  tablet,
}

extension DeviceTypeExtension on DeviceType {
  double get widthBreakPoint {
    switch (this) {
      case DeviceType.small:
        return 320;
      case DeviceType.regular:
        return 375;
      case DeviceType.tablet:
        return 768;
    }
  }

  double get scaleFactor {
    switch (this) {
      case DeviceType.small:
        return 0.8;
      case DeviceType.regular:
        return 1.0;
      case DeviceType.tablet:
        return 1.0;
    }
  }
}
