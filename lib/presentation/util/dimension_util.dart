import 'package:flutter/cupertino.dart';

class DimensionUtil {
  const DimensionUtil._();

  static double getPhysicalPixels(double logicalSize, BuildContext context) =>
      logicalSize * MediaQuery.of(context).devicePixelRatio;

  static int getPhysicalPixelsAsInt(double logicalSize, BuildContext context) =>
      getPhysicalPixels(logicalSize, context).round();
}
