import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/style/colors.dart';
import 'package:better_informed_mobile/presentation/style/shadows.dart';
import 'package:better_informed_mobile/presentation/style/typography.dart';
import 'package:better_informed_mobile/presentation/style/vector_graphics.dart';
import 'package:better_informed_mobile/presentation/util/images.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_background_view.dart';
import 'package:better_informed_mobile/presentation/widget/share/article/share_article_view_content.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:better_informed_mobile/presentation/widget/share/image_load_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

const _stickerWidth = 480.0;
const _stickerMaxHeight = 640.0;

const _backgroundWidth = 720.0;
const _backgroundHeight = 1280.0;

class ShareQuoteStickerView extends HookWidget implements BaseShareCompletable {
  ShareQuoteStickerView({
    required this.quote,
    required this.article,
    super.key,
  });

  final String quote;
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

    return ImageLoadResolver(
      completer: _baseViewCompleter,
      images: [publisherImage],
      child: Center(
        child: Material(
          color: AppColors.transparent,
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: article.category.color ?? AppColors.background,
              borderRadius: BorderRadius.circular(4),
              boxShadow: cardShadows,
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
                const SizedBox(height: AppDimens.l),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: ShareArticleViewContent(
                    article: article,
                    publisherImage: publisherImage,
                    titleMaxLines: 2,
                  ),
                ),
                const SizedBox(height: AppDimens.l),
                Container(
                  margin: const EdgeInsets.only(left: AppDimens.l),
                  padding: const EdgeInsets.all(AppDimens.l),
                  color: AppColors.background,
                  child: Text(
                    '“$quote”',
                    style: AppTypography.articleTextRegular.copyWith(
                      fontSize: 28,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.xl),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppDimens.l),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(
                      AppVectorGraphics.launcherLogoInformed,
                      width: 140,
                      height: 32,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.l),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShareQuoteCombinedView extends HookWidget implements BaseShareCompletable {
  ShareQuoteCombinedView({
    required this.quote,
    required this.article,
    super.key,
  });

  final String quote;
  final MediaItemArticle article;

  final Completer _baseViewCompleter = Completer();

  @override
  Size get size => const Size(_backgroundWidth, _backgroundHeight);

  @override
  Completer get viewReadyCompleter => _baseViewCompleter;

  @override
  Widget build(BuildContext context) {
    final background = useMemoized(() => ShareArticleBackgroundView(article: article));
    final foreground = useMemoized(() => ShareQuoteStickerView(article: article, quote: quote));

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
