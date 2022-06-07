import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/animated_pointer_down.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/photo_caption/photo_caption_button.dart';
import 'package:flutter/material.dart';

class ArticleImageView extends StatelessWidget {
  const ArticleImageView({
    required this.article,
    required this.controller,
    required this.fullHeight,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final PageController controller;
  final double fullHeight;

  @override
  Widget build(BuildContext context) {
    final hasImage = article.hasImage;
    final articleImage = article.image;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (hasImage)
          SizedBox(
            width: double.infinity,
            height: fullHeight,
            child: ArticleImage(
              image: articleImage!,
              cardColor: AppColors.background,
              fit: BoxFit.cover,
              showDarkened: true,
            ),
          )
        else
          Container(color: AppColors.background),
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
                  textStyle: AppTypography.b2Regular.copyWith(height: 1),
                ),
                const SizedBox(height: AppDimens.m),
                Padding(
                  padding: const EdgeInsets.only(right: AppDimens.l),
                  child: InformedMarkdownBody(
                    markdown: article.title,
                    highlightColor: AppColors.transparent,
                    baseTextStyle: AppTypography.h0ExtraBold.copyWith(color: AppColors.white),
                    maxLines: 5,
                  ),
                ),
                const SizedBox(height: AppDimens.xc),
                AnimatedPointerDown(
                  arrowColor: AppColors.white,
                  onTap: () => controller.animateToPage(
                    (controller.page?.ceil() ?? 0) + 1,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeIn,
                  ),
                ),
                const SizedBox(height: AppDimens.xxl),
              ],
            ),
          ),
        ),
        if (hasImage)
          articleImage!.maybeMap(
            cloudinary: (image) => PhotoCaptionButton(
              cloudinaryImage: image.cloudinaryImage,
              articleId: article.id,
            ),
            orElse: () => const SizedBox.shrink(),
          )
      ],
    );
  }
}
