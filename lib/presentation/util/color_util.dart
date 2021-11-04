import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _fromHex(String hexCode) {
    var colorCode = hexCode.toUpperCase().replaceAll('#', '');
    if (colorCode.length == 6) {
      colorCode = 'FF' + colorCode;
    }
    return int.parse(colorCode, radix: 16);
  }

  HexColor(final String hexColor) : super(_fromHex(hexColor));
}
