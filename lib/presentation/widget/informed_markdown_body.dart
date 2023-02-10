import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
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
    this.highlightColor = AppColors.brandAccent,
    this.textAlignment = TextAlign.start,
    this.paddingBuilders,
    this.shareTextCallback,
    this.markdownImageBuilder,
    this.useTextHighlight = true,
    this.bulletPadding,
    this.quoteDecorationColor = AppColors.brandAccent,
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
    this.highlightColor = AppColors.brandAccent,
    this.textAlignment = TextAlign.start,
    this.paddingBuilders,
    this.shareTextCallback,
    this.markdownImageBuilder,
    this.useTextHighlight = true,
    this.bulletPadding,
    this.quoteDecorationColor = AppColors.brandAccent,
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
  final Color quoteDecorationColor;
  final Map<String, MarkdownPaddingBuilder>? paddingBuilders;
  final ShareTextCallback? shareTextCallback;
  final SelectionControllerBundle? selectionControllers;
  final MarkdownImageBuilder? markdownImageBuilder;
  final EdgeInsetsGeometry? bulletPadding;

  @override
  Widget build(BuildContext context) {
    final baseStyle = baseTextStyle.withPrimaryColorIfNull(context);
    final headingStyle = headingTextStyle?.withPrimaryColorIfNull(context);
    final strongStyle =
        strongTextStyle?.withPrimaryColorIfNull(context) ?? baseStyle.copyWith(fontWeight: FontWeight.bold);

    return MarkdownBody(
      data: markdown,
      selectable: selectable,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: baseStyle,
        pPadding: pPadding,
        h1: headingStyle,
        h2: headingStyle,
        h3: headingStyle,
        h4: headingStyle,
        h5: headingStyle,
        h6: headingStyle,
        strong: strongStyle,
        listBullet: baseStyle,
        listBulletPadding: const EdgeInsets.symmetric(vertical: AppDimens.s),
        blockquote: AppTypography.serifTitleSmallIvar,
        blockquoteDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: quoteDecorationColor,
              width: 1.5,
            ),
          ),
        ),
        blockquotePadding: const EdgeInsets.only(
          left: AppDimens.m,
          right: AppDimens.zero,
          top: AppDimens.zero,
          bottom: AppDimens.zero,
        ),
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

extension on TextStyle {
  TextStyle withPrimaryColorIfNull(BuildContext context) => copyWith(
        color: color ?? AppColors.of(context).textPrimary,
      );
}
