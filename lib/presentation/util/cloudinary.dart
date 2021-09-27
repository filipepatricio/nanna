import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/widgets.dart';

const _cloudinaryCloudName = 'informed-development';

extension CloudinaryImageExtension on CloudinaryImage {
  static CloudinaryImage withPublicId(String publicId) {
    return CloudinaryImage.fromPublicId(_cloudinaryCloudName, publicId);
  }
}

extension CloudinaryTransformationExtension on CloudinaryTransformation {
  CloudinaryTransformation withLogicalSize(double width, double height, BuildContext context) {
    return this
        .width(DimensionUtil.getPhysicalPixelsAsInt(width, context))
        .height(DimensionUtil.getPhysicalPixelsAsInt(height, context));
  }

  CloudinaryTransformation autoGravity() {
    return crop('fill').gravity('auto');
  }

  String generateNotNull() {
    return generate()!;
  }
}
