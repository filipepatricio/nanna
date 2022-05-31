import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgSpan extends StatelessWidget implements RichTextBase {
  const SvgSpan({
    required this.rawSvg,
    super.key,
  });

  final String rawSvg;

  @override
  Widget build(BuildContext context) {
    return RichText(text: textSpan);
  }

  @override
  InlineSpan get textSpan => WidgetSpan(
        child: SvgPicture.string(rawSvg),
      );
}
