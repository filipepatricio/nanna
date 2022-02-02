import 'dart:math';

import 'package:flutter/cupertino.dart';

class TextUtil {
  const TextUtil._();

  static int getTextMaxLines(String text, TextStyle style, double maxHeight, BuildContext context) {
    //use a text painter to calculate the height taking into account text scale factor.
    //could be moved to a extension method or similar
    final oneLineSize = (TextPainter(
            text: TextSpan(text: text, style: style),
            maxLines: 1,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size;

    //lets not return 0 max lines or less
    final maxLines = max(1, (maxHeight / oneLineSize.height).floor());
    return maxLines;
  }

  static bool textFits(String text, TextStyle style, double maxHeight,
      {double minWidth = 0, double maxWidth = double.infinity}) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: minWidth, maxWidth: maxWidth);
    return textPainter.height <= maxHeight;
  }
}
