import 'package:better_informed_mobile/core/di/di_config.dart';
import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/util/dimension_util.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CloudinaryImageProvider {
  final String _cloudName;

  CloudinaryImageProvider._(this._cloudName);

  CloudinaryImage withPublicId(String publicId) => CloudinaryImage.fromPublicId(_cloudName, publicId);
}

CloudinaryImageProvider useCloudinaryProvider() {
  return useMemoized(() {
    final cloudName = getIt<AppConfig>().cloudinaryCloudName;
    return CloudinaryImageProvider._(cloudName);
  });
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
