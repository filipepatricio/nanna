import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _bottomMargin = 145.0;

class ArticleImageView extends HookWidget {
  final MediaItemArticle article;
  final ScrollController controller;
  final double fullHeight;

  const ArticleImageView({
    required this.article,
    required this.controller,
    required this.fullHeight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = article.image?.publicId;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (imageId != null) ...[
          SizedBox(
            width: double.infinity,
            height: fullHeight,
            child: CloudinaryProgressiveImage(
              cloudinaryTransformation: cloudinaryProvider
                  .withPublicIdAsJpg(imageId)
                  .transform()
                  .withLogicalSize(MediaQuery.of(context).size.width, fullHeight, context)
                  .autoGravity(),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: fullHeight,
            ),
          ),
        ] else
          Container(color: AppColors.background),
        Positioned.fill(
          child: Container(
            color: AppColors.black.withOpacity(0.40),
          ),
        ),
        Positioned.fill(
          left: AppDimens.l,
          right: AppDimens.l,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DottedArticleInfo(
                  article: article,
                  isLight: true,
                  showDate: false,
                  showReadTime: false,
                ),
                const SizedBox(height: AppDimens.m),
                Padding(
                  padding: const EdgeInsets.only(right: AppDimens.l),
                  child: Text(
                    article.title,
                    style: AppTypography.h0Bold.copyWith(color: AppColors.white),
                  ),
                ),
                const SizedBox(height: _bottomMargin),
                const AnimatedPointerDown(arrowColor: AppColors.white),
                const SizedBox(height: AppDimens.xxl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
