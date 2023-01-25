import 'package:better_informed_mobile/data/article/database/entity/image_entity.hv.dart';
import 'package:better_informed_mobile/data/hive_types.dart';
import 'package:hive/hive.dart';

part 'article_image_entity.hv.g.dart';

@HiveType(typeId: HiveTypes.articleImageEntity)
class ArticleImageEntity {
  ArticleImageEntity({
    ArticleCloudinaryImageEntity? cloudinary,
    ArticleRemoteImageEntity? remote,
    ArticleUnknownImageEntity? unknown,
  })  : _cloudinary = cloudinary,
        _remote = remote,
        _unknown = unknown;

  ArticleImageEntity.cloudinary(ArticleCloudinaryImageEntity cloudinary) : this(cloudinary: cloudinary);

  ArticleImageEntity.remote(ArticleRemoteImageEntity remote) : this(remote: remote);

  ArticleImageEntity.unknown() : this(unknown: ArticleUnknownImageEntity());

  T map<T>({
    required T Function(ArticleCloudinaryImageEntity cloudinary) cloudinary,
    required T Function(ArticleRemoteImageEntity remote) remote,
    required T Function(ArticleUnknownImageEntity unknown) unknown,
  }) {
    if (_cloudinary != null) {
      return cloudinary(_cloudinary!);
    } else if (_remote != null) {
      return remote(_remote!);
    } else if (_unknown != null) {
      return unknown(_unknown!);
    } else {
      throw Exception('Invalid state');
    }
  }

  @HiveField(0)
  final ArticleCloudinaryImageEntity? _cloudinary;
  @HiveField(1)
  final ArticleRemoteImageEntity? _remote;
  @HiveField(2)
  final ArticleUnknownImageEntity? _unknown;
}

@HiveType(typeId: HiveTypes.articleCloudinaryImageEntity)
class ArticleCloudinaryImageEntity {
  ArticleCloudinaryImageEntity({
    required this.image,
  });

  @HiveField(0)
  final ImageEntity image;
}

@HiveType(typeId: HiveTypes.articleRemoteImageEntity)
class ArticleRemoteImageEntity {
  ArticleRemoteImageEntity({required this.url});

  @HiveField(0)
  final String url;
}

@HiveType(typeId: HiveTypes.articleUnknownImageEntity)
class ArticleUnknownImageEntity {}
