import 'dart:async';

import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/util/images.dart';
import 'package:better_informed_mobile/presentation/widget/share/base_share_completable.dart';
import 'package:better_informed_mobile/presentation/widget/share/image_load_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _backgroundWidth = 720.0;
const _backgroundHeight = 1280.0;

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
