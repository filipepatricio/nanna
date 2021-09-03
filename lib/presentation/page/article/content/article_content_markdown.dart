import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class ArticleContentMarkdown extends StatelessWidget {
  final String markdown;
  final Function() scrollToPosition;

  const ArticleContentMarkdown({
    required this.markdown,
    required this.scrollToPosition,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => scrollToPosition());
    return InformedMarkdownBody(
      markdown: markdown,
      baseTextStyle: AppTypography.b2MediumSerif,
      selectable: true,
    );
  }
}
