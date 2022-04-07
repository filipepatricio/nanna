import 'package:better_informed_mobile/data/util/dto_config.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'article_image_dto.dt.freezed.dart';
part 'article_image_dto.dt.g.dart';

@Freezed(unionKey: '__typename', fallbackUnion: unknownKey)
class ArticleImageDTO with _$ArticleImageDTO {
  @FreezedUnionValue('CloudinaryImage')
  factory ArticleImageDTO.cloudinary(String publicId) = ArticleImageDTOCloudinary;

  @FreezedUnionValue('RemoteImage')
  factory ArticleImageDTO.remote(String url) = ArticleImageDTORemote;

  @FreezedUnionValue(unknownKey)
  factory ArticleImageDTO.unknown() = _ArticleImageDTOUnknown;

  factory ArticleImageDTO.fromJson(Map<String, dynamic> json) => _$ArticleImageDTOFromJson(json);
}
