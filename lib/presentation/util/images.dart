import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/article/data/article.dt.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/brief_entry.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_dimens.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/widget/cloudinary/cloudinary_config.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

export 'cloudinary.dart';

Image remoteImage({
  required String url,
  required double width,
  required double height,
  BoxFit? fit,
  String? testImage,
}) {
  if (kIsTest) {
    return Image.asset(
      testImage ?? AppRasterGraphics.testReadingListCoverImage,
      width: width,
      height: height,
      fit: fit,
    );
  }

  return Image(
    image: CachedNetworkImageProvider(url),
    width: width,
    height: height,
    fit: fit,
  );
}

void precacheBriefFullScreenImages(
  BuildContext context,
  CloudinaryImageProvider cloudinaryProvider,
  List<BriefEntry> entries,
) {
  for (final entry in entries) {
    entry.item.mapOrNull(
      article: (article) {
        final articleImageHeight = AppDimens.articleHeaderImageHeight(context);
        final articleImageWidth = AppDimens.articleHeaderImageWidth(context);

        final config = CloudinaryConfig(width: articleImageWidth, height: articleImageHeight);

        article.article.mapOrNull(
          article: (article) {
            if (article.type == ArticleType.premium) {
              final articleImageUrl = article.imageUrl;
              if (articleImageUrl.isNotEmpty) {
                final url = config.applyAndGenerateUrl(context, articleImageUrl, cloudinaryProvider);
                precacheImage(CachedNetworkImageProvider(url), context);
              }
            }
          },
        );
      },
      topicPreview: (topic) {
        final topicHeaderImageHeight = AppDimens.topicViewHeaderImageHeight(context);
        final topicHeaderImageWidth = AppDimens.topicViewHeaderImageWidth(context);
        final config = CloudinaryConfig(width: topicHeaderImageWidth, height: topicHeaderImageHeight);
        final publicId = topic.topicPreview.heroImage.publicId;
        final url = config.applyAndGenerateUrl(context, publicId, cloudinaryProvider);
        precacheImage(CachedNetworkImageProvider(url), context);
      },
    );
  }
}
