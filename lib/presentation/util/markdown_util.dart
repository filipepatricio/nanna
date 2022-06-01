import 'dart:convert';

import 'package:better_informed_mobile/presentation/widget/svg_span.dart';
import 'package:flutter/widgets.dart';

class MarkdownUtil {
  const MarkdownUtil._();

  static const _rawSvgScheme = 'rsvg';

  static String getRawSvgMarkdownImage(String rawSvg) {
    final rawSvgBase64 = base64Encode(utf8.encode(rawSvg));
    return '![]($_rawSvgScheme:image/svg;base64,$rawSvgBase64)';
  }

  static Widget rawSvgMarkdownBuilder(Uri uri, String? title, String? alt, double size) {
    if (uri.scheme == _rawSvgScheme) {
      final rawSvgBase64 = uri.path.split(',')[1];
      final rawSvg = utf8.decode(base64Decode(rawSvgBase64));
      return SvgSpan(rawSvg: rawSvg, size: size);
    }

    return const SizedBox.shrink();
  }
}
