import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:better_informed_mobile/exports.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/util/images.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:better_informed_mobile/presentation/widget/share/image_load_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _stickerWidth = 480.0;
const _stickerMaxHeight = 640.0;

const _backgroundWidth = 720.0;
const _backgroundHeight = 1280.0;

class ShareArticleStickerView extends HookWidget implements BaseShareCompletable {
  ShareArticleStickerView({
    required this.article,
    super.key,
  });

  final MediaItemArticle article;

  final Completer _baseViewCompleter = Completer();

  @override
  Size get size => const Size(_stickerWidth, _stickerMaxHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();

    final publisherImage = useMemoized(() {
      final logo = article.publisher.darkLogo;

      if (logo == null) return null;

      return cloudinaryImageAuto(
        cloudinary: cloudinary,
        publicId: logo.publicId,
        width: AppDimens.xl,
        height: AppDimens.xl,
        fit: BoxFit.contain,
        testImage: AppRasterGraphics.testPublisherLogoDark,
        imageType: ImageType.png,
      );
    });

    final author = article.author;

    return ImageLoadResolver(
      completer: _baseViewCompleter,
      images: [publisherImage],
      child: Center(
        child: Material(
          color: AppColors.transparent,
          child: Container(
            padding: const EdgeInsets.all(AppDimens.l),
            decoration: BoxDecoration(
              color: article.category.color ?? AppColors.background,
              borderRadius: BorderRadius.circular(4),
            ),
            constraints: const BoxConstraints(
              maxHeight: _stickerMaxHeight,
              maxWidth: _stickerWidth,
              minWidth: _stickerWidth,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    if (publisherImage != null) ...[
                      publisherImage,
                      const SizedBox(width: AppDimens.s),
                    ],
                    Expanded(
                      child: Text(
                        article.publisher.name,
                        style: AppTypography.b1Medium.copyWith(
                          height: 1,
                          fontSize: 24,
                          fontWeight: FontWeight.lerp(
                            FontWeight.w500,
                            FontWeight.w600,
                            0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.m),
                Text(
                  article.strippedTitle,
                  style: AppTypography.articleQuote.copyWith(
                    fontSize: 36,
                    height: 1.1,
                    fontWeight: FontWeight.lerp(
                      FontWeight.w500,
                      FontWeight.w600,
                      0.5,
                    ),
                  ),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
                if (author != null) ...[
                  const SizedBox(height: AppDimens.m),
                  Text(
                    LocaleKeys.shareArticle_author.tr(
                      args: [
                        author,
                      ],
                    ),
                    style: AppTypography.b1Regular.copyWith(
                      fontSize: 24,
                      height: 1,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShareArticleBackgroundView extends HookWidget implements BaseShareCompletable {
  ShareArticleBackgroundView({
    required this.article,
    super.key,
  });

  final MediaItemArticle article;

  final Completer _baseViewCompleter = Completer();

  @override
  Size get size => const Size(_backgroundWidth, _backgroundHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final cloudinary = useCloudinaryProvider();

    final backgroundImage = useMemoized(
      () {
        if (!article.hasImage) return null;

        final image = article.image;

        if (image is ArticleImageCloudinary) {
          return cloudinaryImageAuto(
            cloudinary: cloudinary,
            publicId: image.cloudinaryImage.publicId,
            width: _backgroundWidth,
            height: _backgroundHeight,
            fit: BoxFit.cover,
            testImage: AppRasterGraphics.testArticleHeroImage,
          );
        }

        if (image is ArticleImageRemote) {
          return remoteImage(
            url: image.url,
            width: _backgroundWidth,
            height: _backgroundHeight,
            fit: BoxFit.cover,
            testImage: AppRasterGraphics.testArticleHeroImage,
          );
        }
      },
    );

    return ImageLoadResolver(
      images: [backgroundImage],
      completer: _baseViewCompleter,
      child: backgroundImage ?? const SizedBox.shrink(),
    );
  }
}

class ShareArticleCombinedView extends HookWidget implements BaseShareCompletable {
  ShareArticleCombinedView({
    required this.article,
    super.key,
  });

  final MediaItemArticle article;

  final Completer _baseViewCompleter = Completer();

  @override
  Size get size => const Size(_backgroundWidth, _backgroundHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final background = useMemoized(() => ShareArticleBackgroundView(article: article));
    final foreground = useMemoized(() => ShareArticleStickerView(article: article));

    _baseViewCompleter.complete(
      Future.wait(
        [
          background.viewReadyCompleter.future,
          foreground.viewReadyCompleter.future,
        ],
      ),
    );

    return Stack(
      children: [
        background,
        Positioned.fill(
          child: Center(
            child: foreground,
          ),
        ),
      ],
    );
  }
}
