import 'package:better_informed_mobile/domain/article/data/article_data.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/article_type_label.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhotoStackedCover extends StatelessWidget {
  final Article article;

  const PhotoStackedCover({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.articleItemWidth,
      height: MediaQuery.of(context).size.height * 0.52,
      child: Stack(
        children: [
          Image.asset(
            article.sourceUrl ?? 'assets/image/article_placeholder.png',
            fit: BoxFit.cover,
          ),
          if (article.type == ArticleType.premium) ...[
            Positioned(
              top: AppDimens.l,
              left: AppDimens.l,
              child: ArticleTypeLabel(article: article),
            ),
          ],
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    article.title,
                    style: AppTypography.h3Bold.copyWith(color: AppColors.white),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: AppDimens.l),
                  Row(
                    children: [
                      Text(article.publisherName,
                          style: AppTypography.metadata1Regular.copyWith(color: AppColors.white)),
                      Text(
                        ' · ',
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.white),
                      ),
                      Text(
                        article.publicationDate,
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.white),
                      ),
                      Text(
                        ' · ',
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.white),
                      ),
                      Text(
                        article.timeToRead,
                        style: AppTypography.metadata1Regular.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.l),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
