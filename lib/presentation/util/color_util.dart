import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_fromHex(hexColor));
  static int _fromHex(String hexCode) {
    var colorCode = hexCode.toUpperCase().replaceAll('#', '');
    colorCode = colorCode.padLeft(8, 'F');
    return int.parse(colorCode, radix: 16);
  }
}
