import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ArticleContentMarkdown extends HookWidget {
  final String markdown;
  final Function() scrollToPosition;

  const ArticleContentMarkdown({
    required this.markdown,
    required this.scrollToPosition,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        WidgetsBinding.instance?.addPostFrameCallback((_) => scrollToPosition());
      },
      [],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
      child: InformedMarkdownBody(
        markdown: markdown,
        baseTextStyle: AppTypography.articleText,
        strongTextStyle: AppTypography.articleTextBold,
        selectable: true,
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
