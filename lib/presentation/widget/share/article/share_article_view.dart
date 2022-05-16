import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/images.dart';
import 'package:better_informed_mobile/presentation/widget/informed_markdown_body.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:better_informed_mobile/presentation/widget/share/image_load_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _cardShadow = BoxShadow(
  color: AppColors.shadowColor,
  offset: Offset(0.0, 4.0),
  blurRadius: 2.0,
  spreadRadius: -1.0,
);

const _viewHeight = 1280.0;
const _viewWidth = 720.0;

const _headerWidth = 520.0;
const _headerHeight = 878.0;

const _logoSize = 40.0;

class ShareArticleView extends HookWidget implements BaseShareCompletable {
  final MediaItemArticle article;
  final Completer _baseViewCompleter;

  ShareArticleView({
    required this.article,
    Key? key,
  })  : _baseViewCompleter = Completer(),
        super(key: key);

  @override
  Size get size => const Size(_viewWidth, _viewHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();
    final logoImageId = article.publisher.darkLogo?.publicId;

    final articleImage = useMemoized(
      () {
        if (!article.hasImage) return null;

        final image = article.image;

        if (image is ArticleImageCloudinary) {
          return cloudinaryImageAuto(
            cloudinary: cloudinary,
            publicId: image.cloudinaryImage.publicId,
            width: _headerWidth,
            height: _headerHeight,
            fit: BoxFit.cover,
            testImage: AppRasterGraphics.testArticleHeroImage,
          );
        }

        if (image is ArticleImageRemote) {
          return remoteImage(
            url: image.url,
            width: _headerWidth,
            height: _headerHeight,
            fit: BoxFit.cover,
            testImage: AppRasterGraphics.testArticleHeroImage,
          );
        }
      },
    );

    final logoImage = useMemoized(
      () {
        if (logoImageId == null) return null;

        return cloudinaryImageFit(
          cloudinary: cloudinary,
          publicId: logoImageId,
          width: _logoSize,
          height: _logoSize,
          fit: BoxFit.fill,
          testImage: AppRasterGraphics.testPublisherLogoDark,
        );
      },
      [article.image],
    );

    return ImageLoadResolver(
      images: [articleImage, logoImage],
      completer: _baseViewCompleter,
      child: _Background(
        child: _Sticker(
          article: article,
          headerImage: articleImage,
          logoImage: logoImage,
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final Widget child;

  const _Background({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        height: _viewHeight,
        width: _viewWidth,
        child: Stack(
          children: [
            Image.asset(AppRasterGraphics.shareStickerBackgroundPeach),
            Align(
              alignment: Alignment.center,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _Sticker extends StatelessWidget {
  final MediaItemArticle article;
  final Image? headerImage;
  final Image? logoImage;

  const _Sticker({
    required this.article,
    required this.headerImage,
    required this.logoImage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainImage = headerImage;

    return Container(
      width: _headerWidth,
      height: _headerHeight,
      decoration: const BoxDecoration(
        boxShadow: [_cardShadow],
        color: AppColors.pastelGreen,
      ),
      child: Stack(
        children: [
          if (mainImage != null) ...[
            mainImage,
            Container(color: AppColors.black40),
          ],
          Positioned.fill(
            left: AppDimens.xl,
            right: AppDimens.xl,
            bottom: AppDimens.xxxl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    if (logoImage != null) ...[
                      logoImage ?? const SizedBox.shrink(),
                      const SizedBox(width: AppDimens.m),
                    ],
                    Text(
                      article.publisher.name,
                      style: AppTypography.h3bold.copyWith(
                        color: mainImage == null ? AppColors.textPrimary : AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.l),
                InformedMarkdownBody(
                  markdown: article.title,
                  baseTextStyle: AppTypography.h0Bold.copyWith(
                    color: mainImage == null ? AppColors.textPrimary : AppColors.white,
                    height: 1.25,
                  ),
                  maxLines: 6,
                ),
                const SizedBox(height: AppDimens.xxxc),
                DottedArticleInfo(
                  article: article,
                  isLight: mainImage != null,
                  fullDate: true,
                  showDate: true,
                  showPublisher: false,
                  showReadTime: true,
                  textStyle: AppTypography.b2Regular.copyWith(height: 1.25),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
