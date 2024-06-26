import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';

class CloudinaryConfig {
  const CloudinaryConfig({
    this.height,
    this.width,
    this.autoGravity = true,
    this.autoQuality = true,
    this.sizeRoundUp = true,
  });

  final double? height;
  final double? width;
  final bool autoGravity;
  final bool autoQuality;
  final bool sizeRoundUp;

  String applyAndGenerateUrl(
    BuildContext context,
    String publicId,
    CloudinaryImageProvider provider, {
    ImageType? imageType,
  }) {
    return apply(context, publicId, provider).generateNotNull(publicId);
  }

  CloudinaryTransformation apply(BuildContext context, String publicId, CloudinaryImageProvider provider) {
    final image = provider.withPublicId(publicId);

    final transformation = image.transform();

    if (sizeRoundUp && _hasBothDimensions) {
      transformation.withLogicalSize(width!, height!, context);
    } else {
      if (height != null) transformation.height(DimensionUtil.getPhysicalPixelsAsInt(height!, context));
      if (width != null) transformation.width(DimensionUtil.getPhysicalPixelsAsInt(width!, context));
    }

    if (autoGravity) transformation.autoGravity();

    if (autoQuality) transformation.autoQuality();

    return transformation;
  }

  bool get _hasBothDimensions => height != null && width != null;
}
