import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/widget/custom_rich_text.dart';
import 'package:better_informed_mobile/presentation/widget/markdown_bullet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class InformedMarkdownBody extends StatelessWidget {
  final String markdown;
  final TextStyle baseTextStyle;
  final bool selectable;

  const InformedMarkdownBody({
    required this.markdown,
    required this.baseTextStyle,
    this.selectable = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: markdown,
      selectable: selectable,
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: baseTextStyle,
        strong: baseTextStyle.copyWith(decoration: TextDecoration.underline),
        listBullet: baseTextStyle,
        listBulletPadding: const EdgeInsets.symmetric(vertical: AppDimens.s),
      ),
      bulletBuilder: (index, style) => const MarkdownBullet(),
      richTextBuilder: (span, selectable, {textAlign, key}) {
        return CustomRichText(textSpan: span!, selectable: selectable);
      },
    );
  }
}
