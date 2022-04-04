import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dt.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const String pngExtension = '.png';
const String jpgExtension = '.jpg';
const String webpExtension = '.webp';

class CloudinaryImageProvider {
  final String _cloudName;

  CloudinaryImageProvider._(this._cloudName);

  CloudinaryImage withPublicId(String publicId) => _fromPublicId(publicId);

  CloudinaryImage withPublicIdAsPng(String publicId) => _fromPublicId(publicId + pngExtension);

  CloudinaryImage withPublicIdAsPlatform(String publicId) =>
      _fromPublicId(publicId + (kIsAppleDevice ? jpgExtension : webpExtension));

  CloudinaryImage _fromPublicId(String publicId) {
    final encodedPublicId = Uri.encodeComponent(publicId);
    return CloudinaryImage.fromPublicId(_cloudName, encodedPublicId);
  }
}

CloudinaryImageProvider useCloudinaryProvider() {
  return useMemoized(() {
    final cloudName = getIt<AppConfig>().cloudinaryCloudName;
    return CloudinaryImageProvider._(cloudName);
  });
}

extension CloudinaryTransformationExtension on CloudinaryTransformation {
  CloudinaryTransformation withLogicalSize(double width, double height, BuildContext context) {
    // Maintain expected aspect ratio, but fetching next 100th measure of width (this would decrease number of different image sizes fetched)
    final aspectRatio = width / height;
    final roundedUpWidth = (width / 100).ceil() * 100.0;
    final roundedUpHeight = (roundedUpWidth / aspectRatio).ceilToDouble();

    return this
        .width(DimensionUtil.getPhysicalPixelsAsInt(roundedUpWidth, context))
        .height(DimensionUtil.getPhysicalPixelsAsInt(roundedUpHeight, context));
  }

  CloudinaryTransformation autoGravity() {
    return crop('fill').gravity('auto');
  }

  CloudinaryTransformation autoQuality() {
    return quality('auto');
  }

  String generateNotNull() {
    return generate()!;
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
    cloudinaryImage(
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
    cloudinaryImage(
      transformation: cloudinary.withPublicId(publicId).transform().width(width.toInt()).height(height.toInt()).fit(),
      width: width,
      height: height,
      fit: fit,
      testImage: testImage,
    );

Image cloudinaryImage({
  required CloudinaryTransformation transformation,
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

  return Image.network(
    transformation.generateNotNull(),
    width: width,
    height: height,
    fit: fit,
  );
}

String? useArticleImageUrl(MediaItemArticle article, int width, int height) {
  final cloudinaryProvider = useCloudinaryProvider();
  return useMemoized(
    () {
      final optionalId = article.image?.publicId;
      if (optionalId != null) {
        return cloudinaryProvider
            .withPublicIdAsPng(optionalId)
            .transform()
            .autoGravity()
            .width(width)
            .height(height)
            .generateNotNull();
      }
    },
    [article],
  );
}
