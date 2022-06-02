import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgSpan extends StatelessWidget implements RichTextBase {
  const SvgSpan({
    required this.rawSvg,
    required this.size,
    super.key,
  });

  final String rawSvg;
  final double size;

  @override
  Widget build(BuildContext context) {
    return RichText(text: textSpan);
  }

  @override
  InlineSpan get textSpan => WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SvgPicture.string(
          rawSvg,
          height: size,
          width: size,
          alignment: Alignment.center,
        ),
      );
}
