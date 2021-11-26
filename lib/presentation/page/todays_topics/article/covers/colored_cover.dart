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

  const ColoredCover({required this.backgroundColor, required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      width: AppDimens.articleItemWidth,
      height: AppDimens.articleItemHeight(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            InformedMarkdownBody(
              markdown: article.title,
              baseTextStyle: AppTypography.h0SemiBold.copyWith(fontFamily: fontFamilyLora),
              maxLines: 4,
            ),
            const Spacer(),
            DottedArticleInfo(article: article, isLight: false),
            const SizedBox(height: AppDimens.l),
          ],
        ),
      ),
    );
  }
}
