import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PhotoStackedCover extends HookWidget {
  final MediaItemArticle article;

  const PhotoStackedCover({required this.article, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = article.image?.publicId;

    return Container(
      height: AppDimens.topicViewArticleSectionImageHeight,
      width: double.infinity,
      child: Stack(
        children: [
          if (imageId != null) ...[
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constrains) {
                  return CloudinaryProgressiveImage(
                    testImage: AppRasterGraphics.testArticleHeroImage,
                    cloudinaryTransformation: cloudinaryProvider
                        .withPublicIdAsPlatform(imageId)
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
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.l),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InformedMarkdownBody(
                    markdown: article.title,
                    baseTextStyle: AppTypography.headline4Bold.copyWith(
                      color: AppColors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                    highlightColor: AppColors.transparent,
                    maxLines: 5,
                  ),
                  const Spacer(),
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
