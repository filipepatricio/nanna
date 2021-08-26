import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/article_type_label.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:easy_localization/easy_localization.dart';
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
            if (article.type == ArticleType.premium) ...[
              const SizedBox(height: AppDimens.l),
              ArticleTypeLabel(article: article),
            ],
            const Spacer(),
            Text(
              article.title,
              style: AppTypography.h0SemiBold.copyWith(fontFamily: fontFamilyLora),
              maxLines: 4,
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            Row(
              children: [
                Text(article.publisher.name, style: AppTypography.metadata1Regular),
                const Text(' · ', style: AppTypography.metadata1Regular),
                Text(article.publicationDate, style: AppTypography.metadata1Regular),
                const Text(' · ', style: AppTypography.metadata1Regular),
                Text(
                  LocaleKeys.article_readMinutes.tr(args: [article.timeToRead.toString()]),
                  style: AppTypography.metadata1Regular,
                ),
              ],
            ),
            const SizedBox(height: AppDimens.l),
          ],
        ),
      ),
    );
  }
}
