import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';

class ArticleCoverContent extends StatelessWidget {
  const ArticleCoverContent({
    required this.article,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;

  @override
  Widget build(BuildContext context) {
    final timeToRead = article.timeToRead;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimens.s),
        DottedArticleInfo(
          article: article,
          isLight: false,
          showLogo: false,
          showDate: false,
          showReadTime: false,
          color: AppColors.textGrey,
          textStyle: AppTypography.caption1Medium.copyWith(height: 1.1),
        ),
        const SizedBox(height: AppDimens.s),
        SizedBox(
          height: AppDimens.l + AppDimens.s,
          child: InformedMarkdownBody(
            maxLines: 2,
            markdown: article.title,
            highlightColor: AppColors.transparent,
            baseTextStyle: AppTypography.metadata1ExtraBold,
          ),
        ),
        if (timeToRead != null) ...[
          const SizedBox(height: AppDimens.s),
          Text(
            LocaleKeys.article_readMinutes.tr(args: [timeToRead.toString()]),
            style: AppTypography.caption1Medium.copyWith(
              height: 1.2,
              color: AppColors.textGrey,
            ),
          ),
        ]
      ],
    );
  }
}
