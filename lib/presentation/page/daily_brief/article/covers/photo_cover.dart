import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/article_label.dart';
import 'package:better_informed_mobile/presentation/widget/article_label/exclusive_label.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PhotoCover extends HookWidget {
  final MediaItemArticle article;

  const PhotoCover({required this.article});

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
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
                        child: CloudinaryProgressiveImage(
                          cloudinaryTransformation: cloudinaryProvider
                              .withPublicId(imageId)
                              .transform()
                              .withLogicalSize(constrains.maxWidth, constrains.maxHeight, context)
                              .autoGravity(),
                          height: constrains.maxHeight,
                          width: constrains.maxWidth,
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
              DottedArticleInfo(article: article, isLight: false),
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
