import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/article/data/article_header.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/article_label.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/exclusive_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PhotoStackedCover extends StatelessWidget {
  final ArticleHeader article;

  const PhotoStackedCover({required this.article});

  @override
  Widget build(BuildContext context) {
    final imageId = article.image?.publicId;
    final containerHeight = MediaQuery.of(context).size.height * 0.52;

    return Container(
      width: AppDimens.articleItemWidth,
      height: containerHeight,
      child: Stack(
        children: [
          if (imageId != null) ...[
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constrains) {
                  return Image.network(
                    CloudinaryImageExtension.withPublicId(imageId)
                        .transform()
                        .height(DimensionUtil.getPhysicalPixelsAsInt(constrains.maxHeight, context))
                        .generate()!,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.30),
              ),
            ),
          ],
          Positioned(
            top: AppDimens.l,
            left: AppDimens.l,
            child: article.type == ArticleType.premium
                ? const ExclusiveLabel()
                : ArticleLabel.opinion(backgroundColor: AppColors.background),
          ),
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
                    style: AppTypography.h3bold.copyWith(color: AppColors.white),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: AppDimens.l),
                  DottedArticleInfo(article: article, textColor: AppColors.white),
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
