import 'package:flutter/material.dart';

extension BrightnessExtension on ThemeData {
  bool get isDark => brightness == Brightness.dark;
}
