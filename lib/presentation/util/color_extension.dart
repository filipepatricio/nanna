import 'dart:ui';

import 'package:better_informed_mobile/presentation/style/colors.dart';

extension ColorExt on Color {
  Color blendMultiply({Color? backgroundColor}) {
    final bgColor = backgroundColor ?? AppColors.white;
    final r = red * bgColor.red ~/ 255;
    final g = green * bgColor.green ~/ 255;
    final b = blue * bgColor.blue ~/ 255;
    final a = alpha * bgColor.alpha ~/ 255;

    return Color.fromARGB(a, r, g, b);
  }
}
