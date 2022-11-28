import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/util/selection_controller_bundle.dart';
import 'package:better_informed_mobile/presentation/widget/informed_rich_text.dart';
import 'package:better_informed_mobile/presentation/widget/markdown_bullet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;

class InformedMarkdownBody extends StatelessWidget {
  const InformedMarkdownBody({
    required this.markdown,
    required this.baseTextStyle,
    this.strongTextStyle,
    this.headingTextStyle,
    this.pPadding,
    this.maxLines,
    this.highlightColor = AppColors.limeGreen,
    this.textAlignment = TextAlign.start,
    this.paddingBuilders,
    this.shareTextCallback,
    this.markdownImageBuilder,
    this.useTextHighlight = true,
    this.bulletPadding,
    Key? key,
  })  : selectable = false,
        selectionControllers = null,
        super(key: key);

  const InformedMarkdownBody.selectable({
    required this.markdown,
    required this.baseTextStyle,
    required this.selectionControllers,
    this.strongTextStyle,
    this.headingTextStyle,
    this.pPadding,
    this.maxLines,
    this.highlightColor = AppColors.limeGreen,
    this.textAlignment = TextAlign.start,
    this.paddingBuilders,
    this.shareTextCallback,
    this.markdownImageBuilder,
    this.useTextHighlight = true,
    this.bulletPadding,
    Key? key,
  })  : selectable = true,
        super(key: key);

  final String markdown;
  final TextStyle baseTextStyle;
  final TextStyle? strongTextStyle;
  final TextStyle? headingTextStyle;
  final EdgeInsets? pPadding;
  final bool selectable;
  final bool useTextHighlight;
  final Color highlightColor;
  final int? maxLines;
  final TextAlign textAlignment;
  final Map<String, MarkdownPaddingBuilder>? paddingBuilders;
  final ShareTextCallback? shareTextCallback;
  final SelectionControllerBundle? selectionControllers;
  final MarkdownImageBuilder? markdownImageBuilder;
  final EdgeInsetsGeometry? bulletPadding;

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
        pPadding: pPadding,
        h1: headingTextStyle,
        h2: headingTextStyle,
        h3: headingTextStyle,
        h4: headingTextStyle,
        h5: headingTextStyle,
        h6: headingTextStyle,
        strong: strongTextStyle ?? baseTextStyle.copyWith(fontWeight: FontWeight.bold),
        listBullet: baseTextStyle,
        listBulletPadding: const EdgeInsets.symmetric(vertical: AppDimens.s),
      ),
      paddingBuilders: paddingBuilders ?? <String, MarkdownPaddingBuilder>{},
      bulletBuilder: (index, style) => MarkdownBullet(padding: bulletPadding),
      imageBuilder: markdownImageBuilder,
      richTextBuilder: (span, selectable, {textAlign, key}) {
        return selectable
            ? InformedRichText.selectable(
                textSpan: span!,
                useTextHighlight: useTextHighlight,
                highlightColor: highlightColor,
                selectionControllers: selectionControllers,
                maxLines: maxLines,
                textAlign: textAlignment,
                shareCallback: shareTextCallback,
              )
            : InformedRichText(
                textSpan: span!,
                useTextHighlight: useTextHighlight,
                highlightColor: highlightColor,
                maxLines: maxLines,
                textAlign: textAlignment,
                shareCallback: shareTextCallback,
              );
      },
    );
  }
}
