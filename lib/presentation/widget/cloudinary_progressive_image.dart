import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

const _lowestQuality = '1';
const _highestQuality = '100';
const _fadeDuration = Duration(milliseconds: 200);

class CloudinaryProgressiveImage extends StatelessWidget {
  final double width;
  final double height;
  final CloudinaryTransformation cloudinaryTransformation;
  final BoxFit fit;

  const CloudinaryProgressiveImage({
    required this.width,
    required this.height,
    required this.cloudinaryTransformation,
    this.fit = BoxFit.fill,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressiveImage.custom(
      placeholderBuilder: (context) => SizedBox(
        width: width,
        height: height,
      ),
      thumbnail: NetworkImage(
        cloudinaryTransformation.quality(_lowestQuality).generateNotNull(),
      ),
      image: NetworkImage(
        cloudinaryTransformation.quality(_highestQuality).generateNotNull(),
      ),
      width: width,
      height: height,
      fit: fit,
      fadeDuration: _fadeDuration,
    );
  }
}