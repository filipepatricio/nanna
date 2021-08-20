import 'package:cloudinary_sdk/cloudinary_sdk.dart';

const _cloudinaryCloudName = 'informed-development';

extension CloudinaryImageExtension on CloudinaryImage {
  static CloudinaryImage withPublicId(String publicId) {
    return CloudinaryImage.fromPublicId(_cloudinaryCloudName, publicId);
  }
}
