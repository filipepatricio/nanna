import 'dart:ui';

extension ColorExt on Color {
  Color blendMultiply(Color backgroundColor) {
    final r = red * backgroundColor.red ~/ 255;
    final g = green * backgroundColor.green ~/ 255;
    final b = blue * backgroundColor.blue ~/ 255;
    final a = alpha * backgroundColor.alpha ~/ 255;

    return Color.fromARGB(a, r, g, b);
  }
}
