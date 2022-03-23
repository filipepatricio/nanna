import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/in_app_browser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Credits extends StatelessWidget {
  const Credits({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: article.credits,
      styleSheet: MarkdownStyleSheet(
        p: AppTypography.articleTextRegular.copyWith(
          color: AppColors.textGrey,
          fontStyle: FontStyle.italic,
        ),
      ),
      onTapLink: (text, href, title) {
        if (href != null) {
          openInAppBrowser(href);
        }
      },
    );
  }
}
