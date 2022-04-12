import 'package:better_informed_mobile/domain/app_config/app_config.dart';
import 'package:better_informed_mobile/presentation/style/app_raster_graphics.dart';
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
