import 'package:flutter/material.dart';

extension LayoutUtilsExtension on Widget {
  Padding withPadding(double value) => Padding(padding: EdgeInsets.all(value), child: this);

  Padding withPaddingH(double value) => Padding(padding: EdgeInsets.symmetric(horizontal: value), child: this);

  Padding withPaddingV(double value) => Padding(padding: EdgeInsets.symmetric(vertical: value), child: this);

  Padding withPaddingOnly({double left = 0.0, double top = 0.0, double right = 0.0, double bottom = 0.0}) =>
      Padding(padding: EdgeInsets.only(left: left, top: top, bottom: bottom, right: right), child: this);
}
