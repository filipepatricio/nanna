import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/article_label.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/exclusive_label.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ColoredCover extends StatelessWidget {
  final ArticleHeader article;

  const ColoredCover({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.rose,
      width: AppDimens.articleItemWidth,
      height: MediaQuery.of(context).size.height * 0.52,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppDimens.l, left: AppDimens.s),
              child: article.type == ArticleType.premium
                  ? const ExclusiveLabel()
                  : ArticleLabel.opinion(backgroundColor: AppColors.background),
            ),
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
