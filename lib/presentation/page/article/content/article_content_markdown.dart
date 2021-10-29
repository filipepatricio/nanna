import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
        baseTextStyle: AppTypography.b2MediumSerif,
        selectable: true,
      ),
    );
  }
}
