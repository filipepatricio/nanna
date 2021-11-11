import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/daily_brief/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PhotoStackedCover extends HookWidget {
  final MediaItemArticle article;

  const PhotoStackedCover({required this.article});

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = article.image?.publicId;

    return Container(
      width: AppDimens.articleItemWidth,
      height: AppDimens.articleItemHeight(context),
      child: Stack(
        children: [
          if (imageId != null) ...[
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constrains) {
                  return CloudinaryProgressiveImage(
                    cloudinaryTransformation: cloudinaryProvider
                        .withPublicIdAsJpg(imageId)
                        .transform()
                        .withLogicalSize(constrains.maxWidth, constrains.maxHeight, context)
                        .autoGravity(),
                    height: constrains.maxHeight,
                    width: constrains.maxWidth,
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.40),
              ),
            ),
          ],
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: AppDimens.l, right: AppDimens.m, bottom: AppDimens.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    article.title,
                    style: AppTypography.h3bold.copyWith(color: AppColors.white),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimens.l),
                  DottedArticleInfo(article: article, isLight: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
