import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
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

    return Container(
      width: AppDimens.articleItemWidth,
      height: AppDimens.articleItemHeight(context),
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
                              .withPublicIdAsJpg(imageId)
                              .transform()
                              .withLogicalSize(constrains.maxWidth, constrains.maxHeight, context)
                              .autoGravity(),
                          height: constrains.maxHeight,
                          width: constrains.maxWidth,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppDimens.m),
          Padding(
            padding: const EdgeInsets.only(right: AppDimens.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DottedArticleInfo(article: article, isLight: false),
                const SizedBox(height: AppDimens.s),
                InformedMarkdownBody(
                  markdown: article.title,
                  baseTextStyle: AppTypography.h3bold.copyWith(overflow: TextOverflow.ellipsis),
                  highlightColor: AppColors.transparent,
                  textAlignment: TextAlign.start,
                  maxLines: 3,
                ),
                const SizedBox(height: AppDimens.l),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
