import 'package:better_informed_mobile/domain/image/data/image.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_image.dt.freezed.dart';

@freezed
class ArticleImage with _$ArticleImage {
  const factory ArticleImage.cloudinary(CloudinaryImage cloudinaryImage) = ArticleImageCloudinary;

  const factory ArticleImage.remote({required String url}) = ArticleImageRemote;

  const factory ArticleImage.unknown() = ArticleImageUnknown;
}
