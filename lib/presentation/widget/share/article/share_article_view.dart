import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/page/todays_topics/article/covers/dotted_article_info.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
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

const _headerWidth = 480.0;
const _headerHeight = 640.0;

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
    final articleImageId = article.image?.publicId;
    final logoImageId = article.publisher.darkLogo?.publicId;

    final articleImage = useMemoized(
      () {
        if (articleImageId == null) return null;

        final imageUrl = cloudinary
            .withPublicId(articleImageId)
            .transform()
            .width(_headerWidth.toInt())
            .height(_headerHeight.toInt())
            .autoGravity()
            .autoQuality()
            .generateNotNull();

        return Image.network(
          imageUrl,
          width: _headerWidth,
          height: _headerHeight,
          fit: BoxFit.fill,
        );
      },
    );

    final logoImage = useMemoized(
      () {
        if (logoImageId == null) return null;

        final imageUrl = cloudinary
            .withPublicIdAsPng(logoImageId)
            .transform()
            .width(_logoSize.toInt())
            .height(_logoSize.toInt())
            .fit()
            .generateNotNull();

        return Image.network(
          imageUrl,
          width: _logoSize,
          height: _logoSize,
          fit: BoxFit.fill,
        );
      },
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
      child: Container(
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
            Container(color: AppColors.black.withOpacity(0.4)),
          ],
          Positioned.fill(
            left: AppDimens.xl,
            right: AppDimens.xl,
            bottom: AppDimens.xxxl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    if (logoImage != null) ...[
                      logoImage ?? const SizedBox(),
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
                const SizedBox(height: AppDimens.xxxl),
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
