import 'package:flutter/cupertino.dart';

class NoGlowScrollBehavior extends ScrollBehavior {
  //Removes scroll limit reaching glow https://stackoverflow.com/a/51119796
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
