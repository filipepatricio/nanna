import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/domain/image/data/article_image.dt.dart';
import 'package:better_informed_mobile/domain/topic/data/topic_preview.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/util/di_util.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum ImageType { png, jpg, webp }

extension ImageTypeExtention on ImageType {
  String get ext {
    switch (this) {
      case ImageType.png:
        return '.png';
      case ImageType.jpg:
        return '.jpg';
      case ImageType.webp:
        return '.webp';
    }
  }
}

class CloudinaryImageProvider {
  CloudinaryImageProvider._(this._cloudName);
  final String _cloudName;

  CloudinaryImage withPublicId(String publicId) => _fromPublicId(publicId);

  CloudinaryImage _fromPublicId(String publicId) {
    final encodedPublicId = Uri.encodeComponent(publicId);
    return CloudinaryImage.fromPublicId(_cloudName, encodedPublicId);
  }
}

CloudinaryImageProvider useCloudinaryProvider() {
  final getIt = useGetIt();
  return useMemoized(() {
    final cloudName = getIt<AppConfig>().cloudinaryCloudName;
    return CloudinaryImageProvider._(cloudName);
  });
}

extension CloudinaryTransformationExtension on CloudinaryTransformation {
  CloudinaryTransformation withLogicalSize(double width, double height, BuildContext context) {
    // Maintain expected aspect ratio, but fetching next 100th measure of width (this would decrease number of different image sizes fetched)
    final aspectRatio = width / height;

    final physicalWidth = DimensionUtil.getPhysicalPixelsAsInt(width, context);
    final roundedUpWidth = (physicalWidth / 100).ceil() * 100;
    final roundedUpHeight = (roundedUpWidth / aspectRatio).ceil();

    return this.width(roundedUpWidth).height(roundedUpHeight);
  }

  CloudinaryTransformation autoGravity() {
    return crop('fill').gravity('auto');
  }

  CloudinaryTransformation autoQuality() {
    return quality('auto');
  }

  String generateAsPlatform(String publicId) {
    return generateNotNull(publicId, imageType: kIsAppleDevice ? ImageType.jpg : ImageType.webp);
  }

  String generateNotNull(String publicId, {ImageType? imageType}) {
    final generatedUrl = generate()!;
    final segments = generatedUrl.split('/');
    var url = generatedUrl;

    // Need this fix to work around a bug in new cloudinary sdk package - it removes the last part of the publicId if it ends with '.something'
    final realPublicId = publicId.split('/').last;

    final generatedPublicId = segments.last;

    if (realPublicId != generatedPublicId) {
      segments.removeLast();
      segments.add(realPublicId);
      url = segments.join('/');
    }
    return '$url${imageType?.ext ?? ''}';
  }
}

Image cloudinaryImageAuto({
  required CloudinaryImageProvider cloudinary,
  required String publicId,
  required double width,
  required double height,
  BoxFit? fit,
  String? testImage,
}) =>
    _cloudinaryImage(
      publicId: publicId,
      transformation: cloudinary
          .withPublicId(publicId)
          .transform()
          .width(width.toInt())
          .height(height.toInt())
          .autoGravity()
          .autoQuality(),
      width: width,
      height: height,
      fit: fit,
      testImage: testImage,
    );

Image cloudinaryImageFit({
  required CloudinaryImageProvider cloudinary,
  required String publicId,
  required double width,
  required double height,
  BoxFit? fit,
  String? testImage,
}) =>
    _cloudinaryImage(
      publicId: publicId,
      transformation: cloudinary
          .withPublicId(publicId)
          .transform()
          .width(
            width.toInt(),
          )
          .height(
            height.toInt(),
          )
          .fit(),
      width: width,
      height: height,
      fit: fit,
      testImage: testImage,
      imageType: ImageType.png,
    );

Image _cloudinaryImage({
  required String publicId,
  required CloudinaryTransformation transformation,
  required double width,
  required double height,
  BoxFit? fit,
  String? testImage,
  ImageType? imageType,
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
    image: CachedNetworkImageProvider(transformation.generateNotNull(publicId, imageType: imageType)),
    width: width,
    height: height,
    fit: fit,
  );
}

String? useArticleImageUrl(MediaItemArticle? article, int width, int height) {
  if (article == null) return null;

  final cloudinaryProvider = useCloudinaryProvider();
  return useMemoized(
    () {
      if (article.hasImage) {
        if (article.image is ArticleImageRemote) {
          return (article.image as ArticleImageRemote).url;
        }

        if (article.image is ArticleImageCloudinary) {
          final publicId = (article.image as ArticleImageCloudinary).cloudinaryImage.publicId;
          return cloudinaryProvider
              .withPublicId(publicId)
              .transform()
              .autoGravity()
              .width(width)
              .height(height)
              .generateNotNull(publicId, imageType: ImageType.png);
        }
      }
    },
    [article],
  );
}

String useTopicImageUrl(TopicPreview topic, int width, int height) {
  final cloudinaryProvider = useCloudinaryProvider();
  return useMemoized(
    () {
      return cloudinaryProvider
          .withPublicId(topic.heroImage.publicId)
          .transform()
          .autoQuality()
          .autoGravity()
          .width(width)
          .height(height)
          .generateAsPlatform(topic.heroImage.publicId);
    },
    [topic],
  );
}
