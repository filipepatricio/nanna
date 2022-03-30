import 'package:better_informed_mobile/domain/daily_brief/data/media_item.dart';
import 'package:better_informed_mobile/presentation/util/cloudinary.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

const _audioCoverSize = 1024;

String? useArticleImageUrl(MediaItemArticle article) {
  final cloudinaryProvider = useCloudinaryProvider();
  return useMemoized(
    () {
      final optionalId = article.image?.publicId;
      if (optionalId != null) {
        return cloudinaryProvider
            .withPublicIdAsPng(optionalId)
            .transform()
            .autoGravity()
            .width(_audioCoverSize)
            .height(_audioCoverSize)
            .generateNotNull();
      }
    },
    [article],
  );
}
