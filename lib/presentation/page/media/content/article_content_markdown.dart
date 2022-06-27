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
    required this.shareTextCallback,
    required this.scrollToPosition,
    Key? key,
  }) : super(key: key);
  final String markdown;
  final ShareTextCallback shareTextCallback;
  final Function() scrollToPosition;

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => scrollToPosition(),
        );
      },
      [],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: InformedMarkdownBody.selectable(
        markdown: markdown,
        selectionControllers: SelectionControllerBundle(),
        baseTextStyle: AppTypography.articleText,
        strongTextStyle: AppTypography.articleTextBold,
        shareTextCallback: shareTextCallback,
        paddingBuilders: <String, MarkdownPaddingBuilder>{
          'p': PPaddingBuilder(),
          'h1': HeadingsPaddingBuilder(),
          'h2': HeadingsPaddingBuilder(),
          'h3': HeadingsPaddingBuilder(),
          'h4': HeadingsPaddingBuilder(),
          'h5': HeadingsPaddingBuilder(),
          'h6': HeadingsPaddingBuilder(),
        },
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
