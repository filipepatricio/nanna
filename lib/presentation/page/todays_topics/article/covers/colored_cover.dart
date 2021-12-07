import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColoredCover extends StatelessWidget {
  final MediaItemArticle article;
  final Color backgroundColor;

  const ColoredCover({
    required this.backgroundColor,
    required this.article,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InformedMarkdownBody(
              markdown: article.title,
              baseTextStyle: AppTypography.h1SemiBold.copyWith(fontFamily: fontFamilyLora),
              maxLines: 5,
            ),
            const Spacer(),
            DottedArticleInfo(article: article, isLight: false),
          ],
        ),
      ),
    );
  }
}
