import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/article_text_scale_factor_notifier.di.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/selection_controller_bundle.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/informed_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ArticleContentMarkdown extends HookWidget {
  const ArticleContentMarkdown({
    required this.markdown,
    required this.categoryColor,
    required this.shareTextCallback,
  });

  final String markdown;
  final Color categoryColor;
  final ShareTextCallback shareTextCallback;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: context.watch<ArticleTextScaleFactorNotifier>().textScaleFactor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
        child: InformedMarkdownBody.selectable(
          markdown: markdown,
          selectionControllers: SelectionControllerBundle(),
          baseTextStyle: AppTypography.articleText,
          strongTextStyle: AppTypography.articleTextBold,
          headingTextStyle: AppTypography.serifTitleSmallIvar,
          shareTextCallback: shareTextCallback,
          useTextHighlight: false,
          paddingBuilders: <String, MarkdownPaddingBuilder>{
            'p': PPaddingBuilder(),
            'h1': HeadingsPaddingBuilder(),
            'h2': HeadingsPaddingBuilder(),
            'h3': HeadingsPaddingBuilder(),
            'h4': HeadingsPaddingBuilder(),
            'h5': HeadingsPaddingBuilder(),
            'h6': HeadingsPaddingBuilder(),
          },
          quoteDecorationColor: categoryColor,
        ),
      ),
    );
  }
}

class PPaddingBuilder extends MarkdownPaddingBuilder {
  @override
  EdgeInsets getPadding() => const EdgeInsets.only(bottom: AppDimens.m + AppDimens.xxs);
}

class HeadingsPaddingBuilder extends MarkdownPaddingBuilder {
  @override
  EdgeInsets getPadding() => const EdgeInsets.only(top: AppDimens.sl, bottom: AppDimens.m);
}
