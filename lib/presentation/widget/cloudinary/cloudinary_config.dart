import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';

class CloudinaryConfig {
  const CloudinaryConfig({
    this.height,
    this.width,
    this.platformBasedExtension = false,
    this.autoGravity = false,
    this.autoQuality = false,
  });

  final double? height;
  final double? width;
  final bool platformBasedExtension;
  final bool autoGravity;
  final bool autoQuality;

  CloudinaryTransformation apply(BuildContext context, String publicId, CloudinaryImageProvider provider) {
    final image = platformBasedExtension ? provider.withPublicIdAsPlatform(publicId) : provider.withPublicId(publicId);

    final transformation = image.transform();

    if (height != null) transformation.height(DimensionUtil.getPhysicalPixelsAsInt(height!, context));

    if (width != null) transformation.width(DimensionUtil.getPhysicalPixelsAsInt(width!, context));

    if (autoGravity) transformation.autoGravity();

    if (autoQuality) transformation.autoQuality();

    return transformation;
  }
}
