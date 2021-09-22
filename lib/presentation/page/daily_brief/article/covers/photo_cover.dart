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

class PhotoCover extends StatelessWidget {
  final ArticleHeader article;

  const PhotoCover({required this.article});

  @override
  Widget build(BuildContext context) {
    final imageId = article.image?.publicId;
    final containerHeight = MediaQuery.of(context).size.height * 0.52;
    return Container(
      width: AppDimens.articleItemWidth,
      height: containerHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constrains) {
                return Stack(
                  children: [
                    if (imageId != null) ...[
                      Positioned.fill(
                        child: Image.network(
                          CloudinaryImageExtension.withPublicId(imageId)
                              .transform()
                              .width(DimensionUtil.getPhysicalPixelsAsInt(constrains.maxHeight, context))
                              .generate()!,
                          fit: BoxFit.cover,
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
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppDimens.m),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              DottedArticleInfo(article: article),
              const SizedBox(height: AppDimens.s),
              Text(
                article.title,
                style: AppTypography.h3bold,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: AppDimens.l),
            ],
          ),
        ],
      ),
    );
  }
}
