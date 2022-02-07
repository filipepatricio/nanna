import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/widget/custom_rich_text.dart';
import 'package:better_informed_mobile/presentation/widget/markdown_bullet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class InformedMarkdownBody extends StatelessWidget {
  final String markdown;
  final TextStyle baseTextStyle;
  final TextStyle? strongTextStyle;
  final bool selectable;
  final Color highlightColor;
  final int? maxLines;
  final TextAlign textAlignment;
  final Map<String, MarkdownPaddingBuilder>? paddingBuilders;

  const InformedMarkdownBody({
    required this.markdown,
    required this.baseTextStyle,
    this.strongTextStyle,
    this.maxLines,
    this.selectable = false,
    this.highlightColor = AppColors.limeGreen,
    this.textAlignment = TextAlign.start,
    this.paddingBuilders,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: markdown,
      selectable: selectable,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: baseTextStyle,
        pPadding: const EdgeInsets.only(bottom: AppDimens.xs),
        strong: strongTextStyle ?? baseTextStyle.copyWith(fontWeight: FontWeight.bold),
        listBullet: baseTextStyle,
        listBulletPadding: const EdgeInsets.symmetric(vertical: AppDimens.s),
      ),
      paddingBuilders: paddingBuilders ?? <String, MarkdownPaddingBuilder>{},
      bulletBuilder: (index, style) => const MarkdownBullet(),
      richTextBuilder: (span, selectable, {textAlign, key}) {
        return CustomRichText(
          textSpan: span!,
          highlightColor: highlightColor,
          selectable: selectable,
          maxLines: maxLines,
          textAlign: textAlignment,
        );
      },
    );
  }
}
