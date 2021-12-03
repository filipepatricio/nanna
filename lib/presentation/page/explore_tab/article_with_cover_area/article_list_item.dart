import 'package:auto_route/auto_route.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/page/media/media_item_page_data.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary_progressive_image.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/publisher_logo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const listItemWidth = 155.0;
const listItemHeight = 260.0;

class ArticleListItem extends HookWidget {
  final MediaItemArticle article;
  final Color themeColor;
  final Color cardColor;
  final double height;
  final double width;

  const ArticleListItem({
    required this.article,
    required this.themeColor,
    this.cardColor = AppColors.transparent,
    double? height,
    double? width,
    Key? key,
  })  : height = height ?? listItemHeight,
        width = width ?? listItemWidth,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final cloudinaryProvider = useCloudinaryProvider();
    final imageId = article.image?.publicId;

    return GestureDetector(
      onTap: () => AutoRouter.of(context).push(
        MediaItemPageRoute(
          pageData: MediaItemPageData.singleItem(
            article: article,
          ),
        ),
      ),
      child: Stack(
        children: [
          if (imageId != null)
            CloudinaryProgressiveImage(
              cloudinaryTransformation: cloudinaryProvider
                  .withPublicIdAsJpg(imageId)
                  .transform()
                  .autoGravity()
                  .withLogicalSize(width, height, context),
              width: width,
              height: height,
            )
          else
            Container(
              color: cardColor,
              width: width,
              height: height,
            ),
          _ArticleImageOverlay(
            article: article,
            themeColor: themeColor,
            height: height,
            width: width,
          ),
        ],
      ),
    );
  }
}

class _ArticleImageOverlay extends StatelessWidget {
  final MediaItemArticle article;
  final Color themeColor;
  final double? height;
  final double? width;

  const _ArticleImageOverlay({
    required this.article,
    required this.themeColor,
    required this.height,
    required this.width,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageId = article.image?.publicId;

    return Container(
      color: imageId != null ? AppColors.black.withOpacity(0.6) : null,
      padding: const EdgeInsets.all(AppDimens.m),
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          if (imageId == null)
            PublisherLogo.dark(publisher: article.publisher)
          else
            PublisherLogo.light(publisher: article.publisher),
          const SizedBox(height: AppDimens.xs),
          InformedMarkdownBody(
            markdown: article.title,
            highlightColor: imageId == null ? AppColors.limeGreen : AppColors.transparent,
            baseTextStyle: AppTypography.h5BoldSmall.copyWith(
              height: 1.4,
              color: imageId == null ? AppColors.textPrimary : AppColors.lightGrey,
            ),
            maxLines: 4,
          ),
          const Spacer(),
          Text(
            tr(
              LocaleKeys.article_readMinutes,
              args: [article.timeToRead.toString()],
            ),
            style: AppTypography.metadata1Regular.copyWith(
              color: imageId == null ? AppColors.textPrimary : AppColors.lightGrey,
            ),
          ),
        ],
      ),
    );
  }
}
