import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/generated/local_keys.g.dart';
import 'package:better_informed_mobile/presentation/page/media/article/article_image.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ArticleAudioViewCover extends StatelessWidget {
  const ArticleAudioViewCover({
    required this.article,
    required this.width,
    required this.height,
    this.shouldShowTimeToRead = true,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final double width;
  final double height;
  final bool shouldShowTimeToRead;

  @override
  Widget build(BuildContext context) {
    final hasImage = article.hasImage;
    return Stack(
      children: [
        if (hasImage)
          ArticleImage(
            image: article.image!,
            cardColor: article.category.color,
          )
        else ...[
          Container(
            color: article.category.color,
            width: width,
            height: height,
          ),
          _ArticleImageOverlay(
            article: article,
            height: height,
            width: width,
            shouldShowTimeToRead: shouldShowTimeToRead,
          )
        ]
      ],
    );
  }
}

class _ArticleImageOverlay extends StatelessWidget {
  const _ArticleImageOverlay({
    required this.article,
    required this.height,
    required this.width,
    required this.shouldShowTimeToRead,
    Key? key,
  }) : super(key: key);

  final MediaItemArticle article;
  final double height;
  final double width;
  final bool shouldShowTimeToRead;

  @override
  Widget build(BuildContext context) {
    final timeToRead = article.timeToRead;
    final hasImage = article.hasImage;

    return Container(
      padding: const EdgeInsets.fromLTRB(AppDimens.m, AppDimens.l, AppDimens.m, AppDimens.m),
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (hasImage) ...[
                PublisherLogo.light(publisher: article.publisher),
              ] else ...[
                PublisherLogo.dark(publisher: article.publisher),
              ]
            ],
          ),
          const SizedBox(height: AppDimens.m),
          InformedMarkdownBody(
            maxLines: hasImage ? 4 : 5,
            markdown: article.title,
            highlightColor: hasImage ? AppColors.transparent : AppColors.limeGreen,
            baseTextStyle: AppTypography.h5BoldSmall.copyWith(
              height: hasImage ? 1.71 : 1.5,
              color: hasImage ? AppColors.white : AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (timeToRead != null && shouldShowTimeToRead)
            Text(
              LocaleKeys.article_readMinutes.tr(args: [timeToRead.toString()]),
              style: AppTypography.systemText.copyWith(
                color: hasImage ? AppColors.white : AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}
