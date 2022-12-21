import 'dart:ui';

extension ColorExt on Color {
  Color blendMultiply({Color? backgroundColor}) {
    final bgColor = backgroundColor ?? const Color(0xFFFFFFFF); //white by default
    final r = red * bgColor.red ~/ 255;
    final g = green * bgColor.green ~/ 255;
    final b = blue * bgColor.blue ~/ 255;
    final a = alpha * bgColor.alpha ~/ 255;

    return Color.fromARGB(a, r, g, b);
  }
}
