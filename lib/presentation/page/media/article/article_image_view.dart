import 'package:better_informed_mobile/domain/article/data/article.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ArticleImageView extends HookWidget {
  final MediaItemArticle article;
  final ScrollController controller;
  final double fullHeight;
  final double additionalBottomMargin;

  const ArticleImageView({
    required this.article,
    required this.controller,
    required this.fullHeight,
    required this.additionalBottomMargin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = article.image?.publicId;
    final titleOpacityState = ValueNotifier(1.0);
    final halfHeight = fullHeight / 2;

    useEffect(
      () {
        final setTitleOpacity = () {
          if (controller.hasClients) {
            final currentOffset = controller.offset;
            final opacityThreshold = halfHeight * 1.5;

            if (currentOffset <= 0) {
              titleOpacityState.value = 1;
              return;
            }

            if (currentOffset > opacityThreshold) {
              titleOpacityState.value = 0;
              return;
            }

            titleOpacityState.value = 1 - (currentOffset / opacityThreshold);
          }
        };

        controller.addListener(setTitleOpacity);
        return () => controller.removeListener(setTitleOpacity);
      },
      [controller, imageId],
    );

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
          bottom: AppDimens.l,
          left: AppDimens.l,
          right: AppDimens.l,
          child: ValueListenableBuilder(
            valueListenable: titleOpacityState,
            builder: (BuildContext context, double value, Widget? child) {
              return FadeTransition(
                opacity: AlwaysStoppedAnimation(titleOpacityState.value),
                child: child,
              );
            },
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
                  SizedBox(height: AppDimens.l + additionalBottomMargin),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: AppDimens.l,
          right: AppDimens.l,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: article.type == ArticleType.freemium ? AppColors.darkLinen : AppColors.pastelGreen,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.4),
                  offset: const Offset(0, -AppDimens.xs),
                  blurRadius: AppDimens.xs,
                ),
              ],
            ),
            width: double.infinity,
            height: AppDimens.sl,
          ),
        ),
      ],
    );
  }
}
